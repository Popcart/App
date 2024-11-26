

import 'package:popcart/app/app.dart';
import 'package:popcart/app/bootstrap.dart';
import 'package:popcart/env/env.dart';

void main() {
  bootstrap(PopCart.new, environment: AppEnvironment.qa);
}
