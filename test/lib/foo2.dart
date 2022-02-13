library foo2;

import 'package:swift_composer/swift_composer.dart';

@Compose
abstract class Foo {

  @InjectClassName
  String get className;

  @InjectConfig
  String? get stringField2;
}
