import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todo/Controller/mobile_auth_controller.dart';

class TaskAddControllers extends GetxController {
  TextEditingController date = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isPrivate = false;

  updatePrivate(bool val) {
    isPrivate = val;
    update();
  }

  pickDate(context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      date.text = DateFormat.yMMMEd().format(pickedDate);
    } else {
      print("Time is not selected");
    }
    update();
  }

  taskAdd(RoundedLoadingButtonController buttonController) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('Notes')
          .add({
        'title': name.text.trim(),
        'des': description.text.trim(),
        'date': date.text.trim(),
        'isPrivate': isPrivate
      });
      Get.back();
      buttonController.reset();
    } catch (e) {
      buttonController.reset();
    }
  }

  bool? canCheckBiometric;

  //checking biometrics
  //this function will check the sensors and will tell us
  // if we can use them or not
  Future<void> checkBiometric() async {
    try {
      canCheckBiometric = await LocalAuthentication().canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    log('BIO METRIC : $canCheckBiometric');
    update();
  }
}