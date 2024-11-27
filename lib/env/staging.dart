import 'package:envied/envied.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/env/env_fields.dart';

part 'staging.g.dart';

@Envied(path: 'assets/env/staging.env', name: 'Env', obfuscate: true)
final class QaEnv implements Env, EnvFields {
  @override
  @EnviedField(varName: 'BASE_URL')
  final String baseUrl = _Env.baseUrl;



  @override
  @EnviedField(varName: 'INTRO_GIF_URL')
  final String introGifUrl = _Env.introGifUrl;
}
