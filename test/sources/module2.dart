library test_module2;

import 'package:swift_composer/swift_composer.dart';

@Compose
abstract class Foo {

  @InjectClassName
  String get className;

  @InjectConfig
  String get stringField2;
}

@Compose
abstract class ComplexGeneric<A,B> {
  B method(A param) {
    return null;
  }
}

@Compose
abstract class SuperComplexGeneric<A, B> extends ComplexGeneric<Foo, A> {
  A method(Foo param) {
    B local;
    return null;
  }
}
