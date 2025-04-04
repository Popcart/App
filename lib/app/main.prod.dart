

import 'package:popcart/app/app.dart';
import 'package:popcart/app/bloc_observer.dart';
import 'package:popcart/env/env.dart';

void main() {
  bootstrap(PopCart.new, environment: AppEnvironment.prod);
}
