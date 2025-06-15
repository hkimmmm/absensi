import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  final SharedPreferences prefs;
  SharedPrefsService(this.prefs);

  Future<void> saveToken(String token) async {
    await prefs.setString('token', token);
  }

  String? get token => prefs.getString('token');
}
