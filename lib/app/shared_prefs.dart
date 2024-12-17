import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }


  bool? get firstTime => _sharedPrefs.getBool('firstTime');
  String? get accessToken => _sharedPrefs.getString('accessToken');

  set firstTime(bool? value) {
    _sharedPrefs.setBool('firstTime', value!);
  }

  set accessToken(String? value) {
    _sharedPrefs.setString('accessToken', value!);
  }

}
