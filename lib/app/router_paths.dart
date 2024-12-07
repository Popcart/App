import 'package:go_router_paths/go_router_paths.dart';

class AppPath {
  static final splash = SplashPath();
  static final auth = AuthPath();
}

class SplashPath extends Path<SplashPath> {
  SplashPath() : super('/');
}

class AuthPath extends Path<AuthPath> {
  AuthPath() : super('/auth');

  // Path get selectUserType   => Path('select-user-type');
}
