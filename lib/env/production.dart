// lib/env/env.dart
import 'package:envied/envied.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/env/env_fields.dart';

part 'production.g.dart';

@Envied(path: 'assets/env/production.env', name: 'Env', obfuscate: true)
final class ProdEnv implements Env, EnvFields {
  @override
  @EnviedField(varName: 'BASE_URL')
  final String baseUrl = _Env.baseUrl;

  // @override
  // @EnviedField(varName: 'PLACES_API_KEY')
  // final String placesApiKey = _Env.placesApiKey;

  // @override
  // @EnviedField(varName: 'APP_VERSION')
  // final String appVersion = _Env.appVersion;
}
