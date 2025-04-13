import 'package:go_router_paths/go_router_paths.dart';

class AppPath {
  static final splash = SplashPath();
  static final auth = AuthPath();
  static final authorizedUser = AuthorizedUserPath();
}

class SplashPath extends Path<SplashPath> {
  SplashPath() : super('/');
}

class AuthPath extends Path<AuthPath> {
  AuthPath() : super('/auth');

  Path get otp => Path('/otp');
  Path get accountType => Path('/account-type');
  Path get signup => Path('/signup');
  Path get businessDetails => Path('/business-details');
  Path get interestScreen => Path('/interest-screen');
}


class AuthorizedUserPath extends Path<AuthorizedUserPath> {
  AuthorizedUserPath() : super('/authorized-user');

  AuctionsPath get auctions => AuctionsPath();
  LivePath get live => LivePath();
  AccountPath get account => AccountPath();
}

class AuctionsPath extends Path<AuctionsPath> {
  AuctionsPath() : super('/auctions');
}

class LivePath extends Path<LivePath> {
  LivePath() : super('/live');

  Path get scheduleSession => Path('schedule-session');
  Path get selectProducts => Path('select-products');
  Path get sellerLivestream => Path('seller-livestream');
  Path get buyerLivestream => Path('buyer-livestream');
  
}

class AccountPath extends Path<AccountPath> {
  AccountPath() : super('/account');

  Path get settings => Path('settings');
}
