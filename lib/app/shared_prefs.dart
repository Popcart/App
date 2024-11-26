import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  //Auth data
  String get accessToken => _sharedPrefs.getString('access_token') ?? '';
  String get userId => _sharedPrefs.getString('userId') ?? '';
  String get fullName => _sharedPrefs.getString('fullName') ?? '';
  bool get isLoggedIn => _sharedPrefs.getBool('isLoggedIn') ?? false;
  bool get seenOnboarding => _sharedPrefs.getBool('onboarding') ?? false;
  String get refreshToken => _sharedPrefs.getString('refresh_token') ?? '';
  String get email => _sharedPrefs.getString('email') ?? '';
  bool get biometrics => _sharedPrefs.getBool('biometrics') ?? false;
  String get currency => _sharedPrefs.getString('currencyy') ?? 'NGN';

  set currency(String value) {
    _sharedPrefs.setString('currencyy', value);
  }

  set accessToken(String value) {
    _sharedPrefs.setString('access_token', value);
  }

  set refreshToken(String value) {
    _sharedPrefs.setString('refresh_token', value);
  }

  set userId(String value) {
    _sharedPrefs.setString('userId', value);
  }

  set email(String value) {
    _sharedPrefs.setString('email', value);
  }

  set fullName(String value) {
    _sharedPrefs.setString('fullName', value);
  }

  set isLoggedIn(bool value) {
    _sharedPrefs.setBool('isLoggedIn', value);
  }

  set seenOnboarding(bool value) {
    _sharedPrefs.setBool('onboarding', value);
  }

  set biometrics(bool value) {
    _sharedPrefs.setBool('biometrics', value);
  }

  void clearAll() {
    _sharedPrefs.clear();
  }
}

// final sharedPrefs = locator.get<SharedPrefs>();
