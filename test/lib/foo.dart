library foo;

import 'package:swift_composer/swift_composer.dart';

@Compose
abstract class Foo implements Pluggable {
  @InjectClassName
  String get className;

  @InjectConfig
  String get stringField;

  @InjectConfig
  int get integerField;

  String format(String prefix) => "Foo: $prefix $className $stringField $integerField";
}

@Compose
abstract class FooChild extends Foo {
  @InjectConfig
  double get doubleField;

  @InjectConfig
  bool get booleanField;

  @override
  String format(String prefix) => "FooChild:${super.format(prefix)} $doubleField $booleanField";
}

@Compose
abstract class FooChild2 extends Foo {
  @Require
  late String requiredString;

  @override
  String format(String prefix) => "FooChild2:${super.format(prefix)} $requiredString";
}
