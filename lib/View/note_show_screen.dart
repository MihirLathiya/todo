import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo/Constant/app_color.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/Controller/mobile_auth_controller.dart';
import 'package:todo/View/tas_edit_screen.dart';

class ShowNotes extends StatefulWidget {
  final String? title, ds, date, id;
  final bool? value;
  const ShowNotes(
      {Key? key, this.title, this.ds, this.date, this.id, this.value})
      : super(key: key);

  @override
  State<ShowNotes> createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Note',
          style: AppTextStyle.whiteSize22W600,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(
                () => TaskEditScreen(
                  title: widget.title,
                  ds: widget.ds,
                  date: widget.date,
                  id: widget.id,
                  value: widget.value,
                ),
                transition: Transition.upToDown,
              );
            },
            child: SvgPicture.asset(
              'assets/edit.svg',
              height: 25,
              width: 25,
              color: AppColor.white,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Ary you sure to delete this not?',
                      style: AppTextStyle.blackSize18,
                    ),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('User')
                              .doc(firebaseAuth.currentUser!.uid)
                              .collection('Notes')
                              .doc(widget.id)
                              .delete();
                          Get.back();
                          Get.back();
                        },
                        icon: Icon(Icons.done),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  );
                },
              );
            },
            child: SvgPicture.asset(
              'assets/trash.svg',
              height: 25,
              width: 25,
              color: AppColor.white,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey,
              offset: Offset(1, 1),
            )
          ],
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Title',
                  style: AppTextStyle.blackSize25W600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${widget.title}',
                textAlign: TextAlign.center,
                style: AppTextStyle.blackSize18W600,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Date',
                  style: AppTextStyle.blackSize25W600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${widget.date}',
                textAlign: TextAlign.center,
                style: AppTextStyle.blackSize18W600,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Description',
                  style: AppTextStyle.blackSize25W600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${widget.ds}',
                textAlign: TextAlign.center,
                style: AppTextStyle.blackSize18W600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
