// lib/env/env.dart
import 'package:envied/envied.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/env/env_fields.dart';

part 'production.g.dart';

@Envied(path: 'assets/env/production.env', name: 'Env', obfuscate: true)
final class ProdEnv implements Env, EnvFields {

  @override
  @EnviedField(varName: 'SELLER_DASHBOARD_URL')
  final String sellerDashboardUrl = _Env.sellerDashboardUrl;
  
  @override
  @EnviedField(varName: 'AUTH_SERVICE_BASE_URL')
  final String authServiceBaseUrl =  _Env.authServiceBaseUrl;
  
  @override
  @EnviedField(varName: 'LIVESTREAM_SERVICE_BASE_URL')
  final String livestreamServiceBaseUrl = _Env.livestreamServiceBaseUrl;

  @override
  @EnviedField(varName: 'AGORA_APP_ID')
  final String agoraAppId = _Env.agoraAppId;
}
