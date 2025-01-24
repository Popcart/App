import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }


  bool? get firstTime => _sharedPrefs.getBool('firstTime');
  String? get accessToken => _sharedPrefs.getString('accessToken');
  String? get refreshToken => _sharedPrefs.getString('refreshToken');
  bool get loggedIn => _sharedPrefs.getBool('loggedIn') ?? false;

  set firstTime(bool? value) {
    _sharedPrefs.setBool('firstTime', value!);
  }

  set accessToken(String? value) {
    _sharedPrefs.setString('accessToken', value!);
  }

  set refreshToken(String? value) {
    _sharedPrefs.setString('refreshToken', value!);
  }

  set loggedIn(bool value) {
    _sharedPrefs.setBool('loggedIn', value);
  }

}
