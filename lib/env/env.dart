import 'package:popcart/app/service_locator.dart';
import 'package:popcart/env/development.dart';
import 'package:popcart/env/env_fields.dart';
import 'package:popcart/env/production.dart';
import 'package:popcart/env/staging.dart';

enum AppEnvironment { dev, qa, prod }

abstract interface class Env implements EnvFields {
  factory Env() => _instance;

  static final Env _instance = switch (locator<AppEnvironment>()) {
    AppEnvironment.dev => DevEnv(),
    AppEnvironment.qa => QaEnv(),
    AppEnvironment.prod => ProdEnv(),
  };
}
