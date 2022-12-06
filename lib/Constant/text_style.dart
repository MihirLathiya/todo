import 'package:flutter/material.dart';
import 'package:todo/Constant/app_color.dart';

class AppTextStyle {
  static TextStyle blackSize18 = TextStyle(
    color: AppColor.black,
    fontSize: 18,
  );
  static TextStyle blackSize18W600 = TextStyle(
    color: AppColor.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static TextStyle greySize18W600 = TextStyle(
    color: AppColor.grey,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static TextStyle blackSize25W600 =
      TextStyle(fontSize: 25, fontWeight: FontWeight.w600);
  static TextStyle whiteSize18 = TextStyle(
    color: AppColor.white,
    fontSize: 18,
  );
  static TextStyle blackSize22W600 = TextStyle(
    color: AppColor.black,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  );
  static TextStyle whiteSize22W600 = TextStyle(
    color: AppColor.white,
    fontWeight: FontWeight.w600,
    fontSize: 22,
  );
}
