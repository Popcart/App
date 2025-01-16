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

  
  @override
  @EnviedField(varName: 'INTRO_GIF_URL')
  final String introGifUrl = _Env.introGifUrl;

  @override
  @EnviedField(varName: 'SELLER_DASHBOARD_URL')
  final String sellerDashboardUrl = _Env.sellerDashboardUrl;
}
