library;

import 'package:swift_composer/swift_composer.dart';

@Compose
abstract class SimpleGeneric<T> implements Pluggable {
  void method(T param) {}
}

@Compose
abstract class Param {}

@Compose
abstract class SimpleSpecific extends SimpleGeneric<Param> {}

@Compose
abstract class ComplexGeneric<A, B> {
  @Inject
  A get injectedA;

  @Inject
  B get injectedB;

  B? method(A param) {
    return null;
  }
}

@Compose
abstract class SuperComplexGeneric<A, B> extends ComplexGeneric<Param, A> {
  B? local;

  @override
  A? method(Param param) {
    return null;
  }
}
