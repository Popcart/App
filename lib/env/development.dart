// lib/env/env.dart

import 'package:envied/envied.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/env/env_fields.dart';

part 'development.g.dart';

@Envied(path: 'assets/env/development.env', name: 'Env', obfuscate: true)
final class DevEnv implements Env, EnvFields {

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
