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

  SellerPath get seller => SellerPath();
  BuyerPath get buyer => BuyerPath();
}

class SellerPath extends Path<SellerPath> {
  SellerPath() : super('/seller');

  Path get analytics => Path('/analytics');
  Path get orders => Path('/orders');
  InventoryPath get inventory => InventoryPath();
  Path get live => Path('/live');
  SellerAccountPath get sellerAccount => SellerAccountPath();
}
class InventoryPath extends Path<InventoryPath> {
  InventoryPath() : super('/inventory');

  Path get addProduct => Path('/add-product');
}

class SellerAccountPath extends Path<SellerAccountPath> {
  SellerAccountPath() : super('/seller-account');

  Path get settings => Path('/settings');
}

class BuyerPath extends Path<BuyerPath> {
  BuyerPath() : super('/buyer');

  Path get settings => Path('/settings');
}

