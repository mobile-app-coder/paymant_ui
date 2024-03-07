import 'package:shared_preferences/shared_preferences.dart';

class SwitchService {
  static storeTypeDatabase(bool? typeDatabase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("typeDatabase", typeDatabase ?? true);
  }

  static Future<bool> loadTypeDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? typeDatabase = prefs.getBool('typeDatabase');
    return typeDatabase ?? true;
  }
}
