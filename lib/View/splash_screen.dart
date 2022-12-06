import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/PrefrenceManager/preference.dart';
import 'package:todo/View/Auth/auth_screen.dart';
import 'package:todo/View/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Get.offAll(() => PreferenceManager.getLogIn() == true ||
              PreferenceManager.getLogIn() != null
          ? HomeScreen()
          : AuthScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'T O D O ',
              style: AppTextStyle.blackSize22W600,
            )
          ],
        ),
      ),
    );
  }
}
