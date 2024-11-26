// lib/env/env.dart

import 'package:envied/envied.dart';
import 'package:popcart/env/env.dart';
import 'package:popcart/env/env_fields.dart';

part 'development.g.dart';

@Envied(path: 'assets/env/development.env', name: 'Env', obfuscate: true)
final class DevEnv implements Env, EnvFields {
  @override
  @EnviedField(varName: 'BASE_URL')
  final String baseUrl = _Env.baseUrl;

}
