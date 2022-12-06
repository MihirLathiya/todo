import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static GetStorage getStorage = GetStorage();

  static String mobile = "mobile";
  static String logIn = "logIn";
  static String name = "name";
  static String bio = "bio";

  ///mobile
  static Future setMobile(String value) async {
    await getStorage.write(mobile, value);
  }

  static String getMobile() {
    return getStorage.read(mobile);
  }

  /// BIO

  static Future setBio(bool value) async {
    await getStorage.write(bio, value);
  }

  static getBio() {
    return getStorage.read(bio);
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
