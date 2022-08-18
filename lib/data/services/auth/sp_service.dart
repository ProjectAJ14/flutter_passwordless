import 'package:shared_preferences/shared_preferences.dart';

class SPService {
  static late SharedPreferences instance;

  static Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }

  static void clear() {
    instance.clear();
  }
}
