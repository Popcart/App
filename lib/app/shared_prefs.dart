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
  bool get isBuyer => _sharedPrefs.getBool('isBuyer') ?? false;
  bool get showFundWalletDialog => _sharedPrefs.getBool('showFundWallet') ?? true;
  String get userUid => _sharedPrefs.getString('uid') ?? '';
  String get username => _sharedPrefs.getString('username') ?? '';

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

  set showFundWalletDialog(bool value) {
    _sharedPrefs.setBool('showFundWallet', value);
  }

  set userUid(String value) {
    _sharedPrefs.setString('uid', value);
  }

  set username(String value) {
    _sharedPrefs.setString('username', value);
  }

  set isBuyer(bool value) {
    _sharedPrefs.setBool('isBuyer', value);
  }

  Future<void> clearAll() async {
    await _sharedPrefs.clear();
  }

}
