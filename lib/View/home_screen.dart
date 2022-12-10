import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/Constant/app_color.dart';
import 'package:todo/Constant/text_style.dart';
import 'package:todo/Controller/ad_controller.dart';
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
  final drawerKey = GlobalKey<ScaffoldState>();

  AdController _adController = Get.put(AdController());
  @override
  void initState() {
    _adController.LoadInterstitialAd();
    try {
      _adController.LoadBannerAdd();
    } catch (e) {
      log('ERROR :- $e');
    }

    super.initState();
  }

  @override
  void dispose() {
    _adController.bannerAd!.dispose();
    _adController.interstitialAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: drawerKey,
        // backgroundColor: Colors.yellow.shade50,
        appBar: AppBar(
          backgroundColor: AppColor.black,
          elevation: 0,
          title: Text(
            'Task',
            style: AppTextStyle.whiteSize22W600,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(
                  () => TaskAddScreen(),
                  transition: Transition.rightToLeft,
                );
              },
              child: SvgPicture.asset(
                'assets/plus-square.svg',
                height: 27,
                width: 27,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  drawerKey.currentState!.openDrawer();
                },
                child: SvgPicture.asset(
                  'assets/menu.svg',
                  height: 27,
                  width: 27,
                ),
              ),
            ],
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
                      "",
                      style: AppTextStyle.blackSize18,
                    ),
                    accountEmail: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${PreferenceManager.getName()}",
                          style: AppTextStyle.whiteSize18,
                        ),
                        Text(
                          "${PreferenceManager.getMobile()}",
                          style: AppTextStyle.whiteSize18,
                        ),
                      ],
                    ),
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
                    title: Text(
                      'Private notes',
                      style: AppTextStyle.blackSize18,
                    ),
                    onTap: () {
                      Get.back();
                      Get.to(() => PrivateNoteScreen());
                    },
                  ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(
                    'Log out',
                    style: AppTextStyle.blackSize18,
                  ),
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
        body: GetBuilder<AdController>(
          builder: (adController) {
            return GetBuilder<SearchController>(
              builder: (controller) {
                return Column(
                  children: [
                    if (adController.bannerAd != null)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: adController.bannerAd!.size.width.toDouble(),
                          height: adController.bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: adController.bannerAd!),
                        ),
                      ),
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
                                    .contains(
                                        controller.searchText.toLowerCase());
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
                                          Get.to(
                                              () => ShowNotes(
                                                    date: data[index]['date'],
                                                    title: data[index]['title'],
                                                    ds: data[index]['des'],
                                                    id: data[index].id,
                                                    value: data[index]
                                                        ['isPrivate'],
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${data[index]['title']}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .visible,
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
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style:
                                                      AppTextStyle.blackSize18,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  '${data[index]['date']}',
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style:
                                                      AppTextStyle.blackSize18,
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
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ));
  }
}
