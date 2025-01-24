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

  Path get selectSellerType => Path('select-seller-type');
  Path get login => Path('/login');
  BuyerSignupPath get buyerSignup => BuyerSignupPath();
  SellerSignupPath get sellerSignup => SellerSignupPath();
}

class BuyerSignupPath extends Path<BuyerSignupPath> {
  BuyerSignupPath() : super('/buyer-signup');

  Path get verifyPhoneNumber => Path('verify-phone-number');
  Path get chooseUsername => Path('choose-username');
  Path get completeBuyerSignup => Path('complete-buyer-signup');
  Path get selectInterests => Path('select-interests');
}

class SellerSignupPath extends Path<SellerSignupPath> {
  SellerSignupPath() : super('/seller-signup');

  BusinessSignupPath get businessSignup => BusinessSignupPath();
}

class BusinessSignupPath extends Path<BusinessSignupPath> {
  BusinessSignupPath() : super('/business-signup');

  Path get completeRegisteredBusinessSignup =>
      Path('complete-registered-business-signup');
  Path get completeIndividualBusinessSignup =>
      Path('complete-individual-business-signup');
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
}

class AccountPath extends Path<AccountPath> {
  AccountPath() : super('/account');
}
