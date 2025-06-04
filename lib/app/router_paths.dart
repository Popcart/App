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

  AnalyticPath get analytics => AnalyticPath();
  Path get orders => Path('/orders');
  InventoryPath get inventory => InventoryPath();
  SellerLiveStreamPath get live => SellerLiveStreamPath();
  SellerAccountPath get account => SellerAccountPath();
}

class AnalyticPath extends Path<AnalyticPath> {
  AnalyticPath() : super('/analytics');

  Path get topProduct => Path('/top-product');
  Path get inventoryProduct => Path('/inventory-product');
}

class SellerLiveStreamPath extends Path<SellerLiveStreamPath> {
  SellerLiveStreamPath() : super('/seller-live');

  Path get goLive => Path('/seller-go-live');
}

class InventoryPath extends Path<InventoryPath> {
  InventoryPath() : super('/inventory');

  Path get addProduct => Path('/add-product');
  Path get editProduct => Path('/edit-product');
}

class SellerAccountPath extends Path<SellerAccountPath> {
  SellerAccountPath() : super('/seller');

  Path get settings => Path('/seller-settings');
}

class BuyerPath extends Path<BuyerPath> {
  BuyerPath() : super('/buyer');

  Path get auctions => Path('/auction');
  Path get stores => Path('/stores');
  BuyerLiveStreamPath get buyerLive => BuyerLiveStreamPath();
  BuyerAccountPath get buyerAccount => BuyerAccountPath();
}

class BuyerAccountPath extends Path<BuyerAccountPath> {
  BuyerAccountPath() : super('/buyer-account');

  Path get settings => Path('/buyer-settings');
}

class BuyerLiveStreamPath extends Path<BuyerLiveStreamPath> {
  BuyerLiveStreamPath() : super('/buyer-live');

  Path get goLive => Path('/buyer-go-live');
}

