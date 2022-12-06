import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todo/Controller/mobile_auth_controller.dart';

class TaskUpdateControllers extends GetxController {
  TextEditingController date = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isPrivate = false;
  updatePrivate(val) {
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

  taskAdd(RoundedLoadingButtonController buttonController, id) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('Notes')
          .doc(id)
          .update({
        'title': name.text.trim(),
        'des': description.text.trim(),
        'date': date.text.trim(),
        'isPrivate': isPrivate
      });
      Get.back();
      Get.back();
      buttonController.reset();
    } catch (e) {
      buttonController.reset();
    }
  }
}
