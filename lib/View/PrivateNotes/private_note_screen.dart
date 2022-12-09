import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:todo/Constant/app_color.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/Controller/local_auth_controller.dart';
import 'package:todo/Controller/mobile_auth_controller.dart';
import 'package:todo/View/note_show_screen.dart';

class PrivateNoteScreen extends StatefulWidget {
  const PrivateNoteScreen({Key? key}) : super(key: key);

  @override
  State<PrivateNoteScreen> createState() => _PrivateNoteScreenState();
}

class _PrivateNoteScreenState extends State<PrivateNoteScreen> {
  LocalAuthController localAuthController = Get.put(LocalAuthController());
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColor.black),
  );
  @override
  void initState() {
    localAuthController.getAvailableBiometrics();
    localAuthController.authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Private Note',
          style: AppTextStyle.whiteSize22W600,
        ),
      ),
      body: GetBuilder<LocalAuthController>(
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  style: AppTextStyle.blackSize18,
                  controller: controller.search,
                  onChanged: (val) {
                    controller.updateSearch(val);
                    log('HELL ${controller.searchText}');
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: AppTextStyle.blackSize18,
                    border: outlineInputBorder,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColor.black,
                    ),
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc(firebaseAuth.currentUser!.uid)
                      .collection('Notes')
                      .where('isPrivate', isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> data = snapshot.data!.docs;
                      if (controller.searchText.isNotEmpty) {
                        data = data.where((element) {
                          return element
                              .get('title')
                              .toString()
                              .toLowerCase()
                              .contains(controller.searchText.toLowerCase());
                        }).toList();
                      }

                      if (controller.authorized == "Authorized success") {
                        return data.length == 0
                            ? Center(
                                child: Text('No private note added'),
                              )
                            : MasonryGridView.count(
                                padding: EdgeInsets.only(
                                    top: 20, right: 10, left: 10),
                                physics: BouncingScrollPhysics(),
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          () => ShowNotes(
                                                date: data[index]['date'],
                                                title: data[index]['title'],
                                                ds: data[index]['des'],
                                                id: data[index].id,
                                                value: data[index]['isPrivate'],
                                              ),
                                          transition: index % 2 == 0
                                              ? Transition.leftToRight
                                              : Transition.rightToLeft);
                                    },
                                    child: Container(
                                      height: 200,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(),
                                        color: AppColor.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            color: Colors.grey,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${data[index]['title']}',
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    style: AppTextStyle
                                                        .blackSize22W600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              '${data[index]['des']}',
                                              overflow: TextOverflow.visible,
                                              style: AppTextStyle.blackSize18,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              '${data[index]['date']}',
                                              overflow: TextOverflow.visible,
                                              style: AppTextStyle.blackSize18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      } else {
                        return Center(
                          child: Text('Authorized First'),
                        );
                      }
                    } else {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
