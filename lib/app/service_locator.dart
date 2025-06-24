import 'package:get_it/get_it.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/repository/livestreams_repo.dart';
import 'package:popcart/core/repository/onboarding_repo.dart';
import 'package:popcart/core/repository/order_repo.dart';
import 'package:popcart/core/repository/products_repo.dart';
import 'package:popcart/core/repository/sellers_repo.dart';
import 'package:popcart/core/repository/user_repo.dart';
import 'package:popcart/env/env.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

GetIt locator = GetIt.instance;

enum ApiService { auth, user, inventory, seller, livestreams, orders, products }

Future<void> setupLocator({
  required AppEnvironment environment,
}) async {
  locator
    ..registerLazySingleton<AppEnvironment>(() => environment)
    ..registerSingleton<SharedPrefs>(SharedPrefs())
    ..registerLazySingleton<ApiHandler>(
      () => ApiHandler(baseUrl: '${Env().authServiceBaseUrl}/auth/'),
      instanceName: ApiService.auth.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () => ApiHandler(baseUrl: '${Env().authServiceBaseUrl}/user/'),
      instanceName: ApiService.user.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () => ApiHandler(baseUrl: '${Env().authServiceBaseUrl}/inventory/'),
      instanceName: ApiService.inventory.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () => ApiHandler(baseUrl: '${Env().authServiceBaseUrl}/sellers/'),
      instanceName: ApiService.seller.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () =>
          ApiHandler(baseUrl: '${Env().livestreamServiceBaseUrl}/livestreams/'),
      instanceName: ApiService.livestreams.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () =>
          ApiHandler(baseUrl: '${Env().authServiceBaseUrl}/orders/'),
      instanceName: ApiService.orders.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () =>
          ApiHandler(baseUrl: '${Env().authServiceBaseUrl}/products/'),
      instanceName: ApiService.products.name,
    )


    ..registerLazySingleton<LivestreamsRepo>(
      () => LivestreamsRepoImpl(
        locator.get<ApiHandler>(
          instanceName: ApiService.livestreams.name,
        ),
      ),
    )
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        locator.get<ApiHandler>(
          instanceName: ApiService.user.name,
        ),
      ),
    )
    ..registerLazySingleton<SellersRepo>(
      () => SellersRepoImpl(
        locator.get<ApiHandler>(
          instanceName: ApiService.seller.name,
        ),
      ),
    )
    ..registerLazySingleton<InventoryRepo>(
      () => InventoryRepoImpl(
        locator.get<ApiHandler>(
          instanceName: ApiService.inventory.name,
        ),
      ),
    )
    ..registerLazySingleton<OnboardingRepo>(
      () => OnboardingRepoImpl(
        locator.get<ApiHandler>(
          instanceName: ApiService.auth.name,
        ),
      ),
    )
    ..registerLazySingleton<OrderRepo>(
      () => OrderRepoImpl(
        locator.get<ApiHandler>(
          instanceName: ApiService.orders.name,
        ),
      ),
    )
  ..registerLazySingleton<ProductsRepo>(
    () => ProductsRepoImpl(
      locator.get<ApiHandler>(
        instanceName: ApiService.products.name,
      ),
    ),
  );
  //  ..registerLazySingleton<PeerToPeerRepository>(
  //   () => PeerToPeerRepositoryImpl(
  //     locator.get<ApiHandler>(
  //       instanceName: ApiService.auth.name,
  //     ),
  //   ),
  // )
  // ..registerLazySingleton<PaymentRepository>(
  //   () => PaymentRepositoryImpl(
  //     locator.get<ApiHandler>(
  //       instanceName: ApiService.auth.name,
  //     ),
  //   ),
  // )..registerLazySingleton<ProfileRepository>(
  //   () => ProfileRepositoryImpl(
  //     locator.get<ApiHandler>(
  //       instanceName: ApiService.auth.name,
  //     ),
  //   ),
  // );
}

extension GetItExtensions on GetIt {
  void setApiHandlerToken(String token) {
    for (final element in ApiService.values) {
      get<ApiHandler>(
        instanceName: element.name,
      ).addToken(token);
    }
  }

  void clearApiHandlerToken() {
    for (final element in ApiService.values) {
      get<ApiHandler>(
        instanceName: element.name,
      ).clearToken();
    }
  }
}
