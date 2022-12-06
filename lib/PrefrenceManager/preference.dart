import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static GetStorage getStorage = GetStorage();

  static String mobile = "mobile";
  static String logIn = "logIn";
  static String name = "name";

  ///mobile
  static Future setMobile(String value) async {
    await getStorage.write(mobile, value);
  }

  static String getMobile() {
    return getStorage.read(mobile);
  }

  ///NAME
  static Future setName(String value) async {
    await getStorage.write(name, value);
  }

  static getName() {
    return getStorage.read(name);
  }

  ///Log In
  static Future setLogIn(bool value) async {
    await getStorage.write(logIn, value);
  }

  static getLogIn() {
    return getStorage.read(logIn);
  }

  static Future getClear() {
    return getStorage.erase();
  }
}
