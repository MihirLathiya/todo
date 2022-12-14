import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final double? height;
  final String? family;
  final double? latterSpace;
  final double? wordSpace;
  final TextOverflow? overFlow;
  final int? maxLine;
  final TextAlign? textAlign;
  const CommonText(
      {Key? key,
      required this.text,
      this.size = 15,
      this.color,
      this.weight,
      this.height,
      this.family,
      this.latterSpace,
      this.wordSpace,
      this.overFlow,
      this.maxLine,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      overflow: overFlow,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: family,
        wordSpacing: wordSpace,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}

String stripePublishKey =
    'pk_test_51LF9k4SDjpVX8m04CKxiHxTb0z6xq1pn8TIfwQI1LYQvhVOYDd2rPrYzPI2S9j0nNrYbRyd2oZNDG6mgSgaD1mfq00yo7VxAUT';
