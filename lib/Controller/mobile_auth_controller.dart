import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todo/PrefrenceManager/preference.dart';
import 'package:todo/View/Auth/otp_screen.dart';
import 'package:todo/View/home_screen.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class MobileController extends GetxController {
  final TextEditingController phone = TextEditingController();
  final TextEditingController name = TextEditingController();
  String verificationIds = "";
  String otpValue = "";

  fillOtp(val) {
    otpValue = val;
    update();
  }

  sendOtp(
      BuildContext context, RoundedLoadingButtonController controller) async {
    update();
    try {
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91" + phone.text,
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            showAlert("Otp send");
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            verificationIds = verificationId;
            Get.to(
              () => OtpScreen(),
              transition: Transition.downToUp,
            );
            controller.reset();

            update();
          },
          verificationFailed: (FirebaseAuthException e) {
            controller.reset();
            update();
            if (e.code == 'invalid-phone-number') {
              showAlert('Invalid MobileNumber');
              print('Invalid MobileNumber');
            } else if (e.code == 'missing-phone-number') {
              showAlert('Missing Phone Number');
            } else if (e.code == 'user-disabled') {
              showAlert('Number is Disabled');
              print('Number is Disabled');
            } else if (e.code == 'quota-exceeded') {
              showAlert('You try too many time. try later ');
            } else if (e.code == 'captcha-check-failed') {
              showAlert('Try Again');
            } else {
              showAlert('Verification Failed!');
            }
            print('>>> Verification Failed');
          });
    } on FirebaseAuthException catch (e) {
      print('$e');
    }
  }

  ///Verify Otp
  Future verifyOtp(RoundedLoadingButtonController controller) async {
    try {
      update();

      UserCredential userCred = await firebaseAuth.signInWithCredential(
        await PhoneAuthProvider.credential(
          verificationId: verificationIds,
          smsCode: otpValue.trim(),
        ),
      );

      if (userCred.user != null) {
        showAlert('success user signed with phone number');
        Get.offAll(
          () => HomeScreen(),
          transition: Transition.upToDown,
        );
        PreferenceManager.setLogIn(true);
        PreferenceManager.setName(name.text.trim());
        PreferenceManager.setMobile(phone.text.trim());

        await FirebaseFirestore.instance
            .collection('User')
            .doc(firebaseAuth.currentUser!.uid)
            .set({'number': phone.text.trim(), 'name': name.text.trim()});
        controller.reset();
        update();

        return true;
      }
    } on FirebaseAuthException catch (e) {
      controller.reset();

      update();
      if (e.code == 'invalid-verification-code') {
        showAlert('Invalid Code');
      } else if (e.code == 'expired-action-code') {
        showAlert('Code Expired');
      } else if (e.code == 'invalid-verification-code') {
        showAlert('Invalid Code');
      } else if (e.code == 'user-disabled') {
        showAlert('User Disabled');
      }
      debugPrint(e.toString());
    }
  }
}

void showAlert(String? msg) {
  Fluttertoast.showToast(msg: msg!);
}
