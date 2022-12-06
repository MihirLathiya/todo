import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  TextEditingController search = TextEditingController();
  String searchText = '';

  updateSearch(val) {
    searchText = val;
    update();
  }
}
