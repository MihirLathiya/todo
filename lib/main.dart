import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:todo/custom/lib/flutter_stripe.dart';

import 'Constant/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      'pk_test_51MERU3SGK02RDB5LjmUwYVgsrJJAsLytuQG9r7QIkPnwvcPaihzUAZ7W0apFXwuG6NGGDzgTvD5dLX1hYnu82ONb00QYKH6K98';
  Stripe.merchantIdentifier = 'stripe payment';
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'T O D O ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
