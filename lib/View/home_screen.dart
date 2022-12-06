import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:todo/Constant/app_color.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/Controller/mobile_auth_controller.dart';
import 'package:todo/Controller/search_controller.dart';
import 'package:todo/PrefrenceManager/preference.dart';
import 'package:todo/View/Auth/auth_screen.dart';
import 'package:todo/View/PrivateNotes/private_note_screen.dart';
import 'package:todo/View/note_show_screen.dart';
import 'package:todo/View/task_add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColor.black),
  );
  SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.yellow.shade50,
        appBar: AppBar(
          backgroundColor: AppColor.black,
          elevation: 0,
          title: Text(
            'Task',
            style: AppTextStyle.whiteSize22W600,
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColor.black,
                  ), //BoxDecoration
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: AppColor.black),
                    accountName: Text(
                      "${PreferenceManager.getName() ?? ''}",
                      style: TextStyle(fontSize: 18),
                    ),
                    accountEmail: Text("${PreferenceManager.getMobile()}"),
                    currentAccountPictureSize: Size.square(50),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: AppColor.white,
                      child: Text(
                        "${PreferenceManager.getName().toString().split('').first.toUpperCase()}",
                        style: TextStyle(fontSize: 30.0, color: AppColor.black),
                      ), //Text
                    ), //circleAvatar
                  ), //UserAccountDrawerHeader
                ), //Dr
                if (PreferenceManager.getBio() == true) // awerHeader
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Private notes'),
                    onTap: () {
                      Get.back();
                      Get.to(() => PrivateNoteScreen());
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onTap: () {
                    PreferenceManager.getClear();
                    Get.offAll(
                      () => AuthScreen(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          onPressed: () {
            Get.to(() => TaskAddScreen());
          },
          child: Icon(
            Icons.add,
          ),
        ),
        body: GetBuilder<SearchController>(
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
                        .where('isPrivate', isEqualTo: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasData) {
                        // var data = snapshot.data!.docs;
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

                        return data.length == 0
                            ? Center(
                                child: Text('No note added'),
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
                                      Get.to(() => ShowNotes(
                                            date: data[index]['date'],
                                            title: data[index]['title'],
                                            ds: data[index]['des'],
                                            id: data[index].id,
                                            value: data[index]['isPrivate'],
                                          ));
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
                                            offset: Offset(2, 2),
                                          )
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
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }
}
