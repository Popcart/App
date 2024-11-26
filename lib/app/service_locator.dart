import 'package:get_it/get_it.dart';
import 'package:popcart/app/shared_prefs.dart';
import 'package:popcart/env/env.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

GetIt locator = GetIt.instance;

enum ApiService { auth }

Future<void> setupLocator({
  required AppEnvironment environment,
}) async {
  locator
    ..registerSingleton<SharedPrefs>(SharedPrefs())
    ..registerLazySingleton<AppEnvironment>(() => environment);
  // ..registerLazySingleton<ApiHandler>(
  //   () => ApiHandler(baseUrl: Env().baseUrl),
  //   instanceName: ApiService.auth.name,
  // )
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
  // void setApiHandlerToken(String token) {
  //   for (final element in ApiService.values) {
  //     get<ApiHandler>(
  //       instanceName: element.name,
  //     ).addToken(token);
  //   }
  // }

  // void clearApiHandlerToken() {
  //   for (final element in ApiService.values) {
  //     get<ApiHandler>(
  //       instanceName: element.name,
  //     ).clearToken();
  //   }
  // }
}
