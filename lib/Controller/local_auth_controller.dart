import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthController extends GetxController {
  LocalAuthentication auth = LocalAuthentication();
  TextEditingController search = TextEditingController();
  String searchText = '';
  List<BiometricType>? _availableBiometric;
  String authorized = "Not authorized";
  bool? canCheckBiometric;

  //checking biometrics
  //this function will check the sensors and will tell us
  // if we can use them or not
  Future<void> checkBiometric() async {
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    log('BIO METRIC : $canCheckBiometric');
    update();
  }

  //this function will get all the available biometrics inside our device
  //it will return a list of objects, but for our example it will only
  //return the fingerprint biometric
  Future<void> getAvailableBiometrics() async {
    List<BiometricType>? availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    _availableBiometric = availableBiometric;
    update();
  }

  //this function will open an authentication dialog
  // and it will check if we are authenticated or not
  // so we will add the major action here like moving to another activity
  // or just display a text that will tell us that we are authenticated

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: "Scan your finger print to authenticate",
      );
    } on PlatformException catch (e) {
      print(e);
    }

    authorized =
        authenticated ? "Authorized success" : "Failed to authenticate";
    update();

    log('MESSAGES :- ${authorized}');
  }

  updateSearch(val) {
    searchText = val;
    update();
  }
}
