import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todo/Constant/app_color.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/Controller/mobile_auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  RoundedLoadingButtonController btController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<MobileController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter OTP',
                  style: AppTextStyle.blackSize22W600,
                ),
                SizedBox(
                  height: 20,
                ),
                OTPTextField(
                  length: 6,
                  width: 260,
                  fieldWidth: 40,
                  keyboardType: TextInputType.number,
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 7,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    borderColor: Colors.black54,
                    disabledBorderColor: Color(0xffE8ECF4),
                    enabledBorderColor: AppColor.black,
                    errorBorderColor: AppColor.black,
                    focusBorderColor: AppColor.black,
                  ),
                  onChanged: (value) {
                    value;
                    log('VALUE := $value');
                  },
                  onCompleted: (pin) {
                    log('PIN := $pin');
                    controller.fillOtp(pin);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: RoundedLoadingButton(
                    color: AppColor.black,
                    controller: btController,
                    onPressed: () {
                      controller.verifyOtp(btController);
                    },
                    child: Text(
                      'Verify Otp',
                      style: AppTextStyle.whiteSize18,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
