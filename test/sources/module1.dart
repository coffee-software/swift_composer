library test_module1;

import 'package:swift_composer/swift_composer.dart';

@Compose
abstract class Foo implements Pluggable {

  @InjectClassName
  String get className;

  @InjectConfig
  String get stringField;

  @InjectConfig
  int get integerField;

  String format(String prefix) => prefix + className + stringField + integerField.toString();
}

@Compose
abstract class FooChild extends Foo {

  @InjectConfig
  double get doubleField;

  @InjectConfig
  bool get booleanField;

}

@Compose
abstract class FooChild2 extends Foo {
  @Require
  String requiredString;
}

@Compose
abstract class Bar {

  @InjectConfig
  String get stringField;

  @InjectClassNames
  List<String> get classNames;

}

@Compose
abstract class BarChild extends Bar {

}

@Compose
abstract class SimpleGeneric<T> {
  void method(T param) {

  }
}
