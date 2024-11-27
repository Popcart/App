import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }


  bool? get firstTime => _sharedPrefs.getBool('firstTime');

  set firstTime(bool? value) {
    _sharedPrefs.setBool('firstTime', value!);
  }

}
