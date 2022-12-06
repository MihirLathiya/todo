import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todo/Constant/app_color.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/Controller/task_update_controller.dart';
import 'package:todo/PrefrenceManager/preference.dart';

class TaskEditScreen extends StatefulWidget {
  final String? title, ds, date, id;
  final bool? value;
  const TaskEditScreen(
      {Key? key, this.title, this.ds, this.date, this.id, this.value})
      : super(key: key);

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  TaskUpdateControllers taskUpdateControllers =
      Get.put(TaskUpdateControllers());
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColor.black),
  );

  @override
  void initState() {
    // TODO: implement initState

    taskUpdateControllers.name.text = widget.title!;
    taskUpdateControllers.description.text = widget.ds!;
    taskUpdateControllers.date.text = widget.date!;
    taskUpdateControllers.updatePrivate(widget.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        title: Text(
          'Task Update',
          style: AppTextStyle.whiteSize22W600,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: GetBuilder<TaskUpdateControllers>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Title',
                    style: AppTextStyle.blackSize18W600,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    style: AppTextStyle.blackSize18,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Add Title';
                      }
                    },
                    controller: controller.name, cursorColor: AppColor.black,

                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: AppTextStyle.blackSize18,
                      border: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Description',
                    style: AppTextStyle.blackSize18W600,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    cursorColor: AppColor.black,
                    style: AppTextStyle.blackSize18,
                    controller: controller.description,
                    maxLines: 8,
                    // keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: AppTextStyle.blackSize18,
                      border: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Date',
                    style: AppTextStyle.blackSize18W600,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.pickDate(context);
                    },
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      width: Get.width,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: Text(
                        '${controller.date.text}',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (PreferenceManager.getBio() == true)
                    Row(
                      children: [
                        Switch(
                          activeColor: AppColor.black,
                          value: controller.isPrivate,
                          onChanged: (val) {
                            controller.updatePrivate(val);
                          },
                        ),
                        Text(
                          controller.isPrivate == true
                              ? 'Added to Private'
                              : 'Add to Private',
                          style: controller.isPrivate == true
                              ? AppTextStyle.blackSize18W600
                              : AppTextStyle.greySize18W600,
                        )
                      ],
                    ),
                  if (PreferenceManager.getBio() == null)
                    Text(
                      '* Your device not support biometric authentication so you can Not access private note feature ',
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 50,
                      width: 150,
                      child: RoundedLoadingButton(
                        color: AppColor.black,
                        controller: _buttonController,
                        onPressed: () {
                          controller.taskAdd(_buttonController, widget.id);
                        },
                        child: Text(
                          'Update',
                          style: AppTextStyle.whiteSize18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
