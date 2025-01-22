import 'package:get_it/get_it.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/core/api/api_helper.dart';
import 'package:popcart/core/repository/inventory_repo.dart';
import 'package:popcart/core/repository/onboarding_repo.dart';
import 'package:popcart/core/repository/user_repo.dart';
import 'package:popcart/env/env.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

GetIt locator = GetIt.instance;

enum ApiService { auth, user, inventory }

Future<void> setupLocator({
  required AppEnvironment environment,
}) async {
  locator
    ..registerLazySingleton<AppEnvironment>(() => environment)
    ..registerSingleton<SharedPrefs>(SharedPrefs())
    ..registerLazySingleton<ApiHandler>(
      () => ApiHandler(baseUrl: '${Env().baseUrl}/auth/'),
      instanceName: ApiService.auth.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () => ApiHandler(baseUrl: '${Env().baseUrl}/user/'),
      instanceName: ApiService.user.name,
    )
    ..registerLazySingleton<ApiHandler>(
      () => ApiHandler(baseUrl: '${Env().baseUrl}/inventory/'),
      instanceName: ApiService.inventory.name,
    )
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        locator.get<ApiHandler>(
          instanceName: ApiService.user.name,
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
    );

  // ..registerLazySingleton<BiometricsHelper>(BiometricsHelper.new)
  // ..registerLazySingleton<AuthService>(
  //   () => AuthImplementation(
  //     apiHandler: locator.get<ApiHandler>(
  //       instanceName: ApiService.auth.name,
  //     ),
  //   ),
  // )
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
