import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todo/Constant/app_color.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/Controller/local_auth_controller.dart';
import 'package:todo/Controller/mobile_auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  MobileController mobileController = Get.put(MobileController());
  RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColor.black),
  );
  final _formKey = GlobalKey<FormState>();
  LocalAuthController localAuthController = Get.put(LocalAuthController());
  @override
  void initState() {
    localAuthController.checkBiometric();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GetBuilder<MobileController>(
            builder: (controller) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.18,
                    ),
                    SvgPicture.asset(
                      'assets/lohgo.svg',
                      height: Get.height * 0.190,
                      width: Get.height * 0.190,
                    ),
                    Spacer(),
                    TextFormField(
                      style: AppTextStyle.blackSize18,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter Name';
                        }
                      },
                      cursorColor: AppColor.black,
                      controller: controller.name,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Enter Name',
                        hintStyle: AppTextStyle.blackSize18,
                        border: outlineInputBorder,
                        prefixIcon: Icon(
                          Icons.perm_identity_sharp,
                          color: AppColor.black,
                        ),
                        enabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      cursorColor: AppColor.black,
                      style: AppTextStyle.blackSize18,
                      validator: (val) {
                        RegExp regex = RegExp(
                            r'^(?:(?:\+|0{0,2})91(\s*|[\-])?|[0]?)?([6789]\d{2}([ -]?)\d{3}([ -]?)\d{4})$');
                        if (!regex.hasMatch(val!)) {
                          return 'Enter valid Number';
                        }
                      },
                      controller: controller.phone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Number',
                        hintStyle: AppTextStyle.blackSize18,
                        border: outlineInputBorder,
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: AppColor.black,
                        ),
                        enabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: RoundedLoadingButton(
                        color: AppColor.black,
                        controller: _buttonController,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.sendOtp(context, _buttonController);
                          }
                        },
                        child:
                            Text('Send Otp', style: AppTextStyle.whiteSize18),
                      ),
                    ),
                    SizedBox(
                      height: 170,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
