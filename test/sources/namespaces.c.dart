// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namespaces.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

//no interceptor for [AnnotatedWith]
//no interceptor for [TypePlugin]
//interceptor for [test_module1.Foo]
//interceptor for test_module1.Foo
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
class $test_module1_Foo extends test_module1.Foo {
  $test_module1_Foo() {}
  T plugin<T>() {}
  String get className => "test_module1.Foo";
  String get stringField => "FooField";
  int get integerField => 124;
}

//interceptor for [test_module1.FooChild]
//interceptor for test_module1.FooChild
//can be singleton: TRUE
//parent: FooChild [@bool get Compose]
//parent: Foo [@bool get Compose]
class $test_module1_FooChild extends test_module1.FooChild {
  $test_module1_FooChild() {}
  T plugin<T>() {}
  String get className => "test_module1.FooChild";
  String get stringField => "FooChildField";
  int get integerField => 124;
  double get doubleField => 0.55;
  bool get booleanField => true;
}

//interceptor for [test_module1.FooChild2]
//interceptor for test_module1.FooChild2
//can be singleton: FALSE
//parent: FooChild2 [@bool get Compose]
//parent: Foo [@bool get Compose]
class $test_module1_FooChild2 extends test_module1.FooChild2 {
  $test_module1_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {}
  String get className => "test_module1.FooChild2";
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

//interceptor for [test_module1.Bar]
//interceptor for test_module1.Bar
//can be singleton: TRUE
//parent: Bar [@bool get Compose]
class $test_module1_Bar extends test_module1.Bar {
  $test_module1_Bar() {}
  T plugin<T>() {}
  String get stringField => "BarField";
  List<String> get classNames => [];
}

//interceptor for [test_module1.BarChild]
//interceptor for test_module1.BarChild
//can be singleton: TRUE
//parent: BarChild [@bool get Compose]
//parent: Bar [@bool get Compose]
class $test_module1_BarChild extends test_module1.BarChild {
  $test_module1_BarChild() {}
  T plugin<T>() {}
  String get stringField => "BarChildField";
  List<String> get classNames => ['test_module1.BarChild'];
}

//interceptor for [test_module1.SimpleGeneric]
//interceptor for test_module1.SimpleGeneric
//can be singleton: FALSE
//parent: SimpleGeneric [@bool get Compose]
class $test_module1_SimpleGeneric<T> extends test_module1.SimpleGeneric<T> {
  $test_module1_SimpleGeneric() {}
  T plugin<T>() {}
}

//interceptor for [test_module2.Foo]
//interceptor for test_module2.Foo
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
class $test_module2_Foo extends test_module2.Foo {
  $test_module2_Foo() {}
  T plugin<T>() {}
  String get className => "test_module2.Foo";
  String get stringField2 => null;
}

//interceptor for [test_module2.ComplexGeneric]
//interceptor for test_module2.ComplexGeneric
//can be singleton: FALSE
//parent: ComplexGeneric [@bool get Compose]
class $test_module2_ComplexGeneric<A, B>
    extends test_module2.ComplexGeneric<A, B> {
  $test_module2_ComplexGeneric() {}
  T plugin<T>() {}
}

//interceptor for [test_module2.SuperComplexGeneric]
//interceptor for test_module2.SuperComplexGeneric
//A[427294693] => Foo[385541647]
//B[463434057] => A[148323164]
//can be singleton: FALSE
//parent: SuperComplexGeneric [@bool get Compose]
//parent: ComplexGeneric [@bool get Compose]
class $test_module2_SuperComplexGeneric<A, B>
    extends test_module2.SuperComplexGeneric<A, B> {
  $test_module2_SuperComplexGeneric() {}
  T plugin<T>() {}
}

//interceptor for [Container]
//interceptor for Container
//can be singleton: TRUE
//parent: Container [@bool get Compose]
class $Container extends Container {
  $Container() {
//ComplexGeneric
//create
//List
//create
//List
//create
//SuperComplexGeneric
//create
  }
  T plugin<T>() {}
}

//interceptor for [GenericContainer]
//interceptor for GenericContainer
//can be singleton: FALSE
//parent: GenericContainer [@bool get Compose]
class $GenericContainer<T> extends GenericContainer<T> {
  $GenericContainer() {
//ComplexGeneric
//create
//List
//create
//List
//create
//SuperComplexGeneric
//create
  }
  T plugin<T>() {}
}

//interceptor for [FooContainer]
//interceptor for FooContainer
//T[517265325] => Foo[180531561]
//can be singleton: TRUE
//parent: FooContainer [@bool get Compose]
//parent: GenericContainer [@bool get Compose]
class $FooContainer extends FooContainer {
  $FooContainer() {
//ComplexGeneric
//create
//List
//create
//List
//create
//SuperComplexGeneric
//create
  }
  T plugin<T>() {}
}

class $ObjectManager {
  $test_module1_Foo _test_module1_Foo;
  $test_module1_Foo get test_module1_Foo {
    if (_test_module1_Foo == null) {
      _test_module1_Foo = new $test_module1_Foo();
    }
    return _test_module1_Foo;
  }

  $test_module1_FooChild _test_module1_FooChild;
  $test_module1_FooChild get test_module1_FooChild {
    if (_test_module1_FooChild == null) {
      _test_module1_FooChild = new $test_module1_FooChild();
    }
    return _test_module1_FooChild;
  }

  $test_module1_Bar _test_module1_Bar;
  $test_module1_Bar get test_module1_Bar {
    if (_test_module1_Bar == null) {
      _test_module1_Bar = new $test_module1_Bar();
    }
    return _test_module1_Bar;
  }

  $test_module1_BarChild _test_module1_BarChild;
  $test_module1_BarChild get test_module1_BarChild {
    if (_test_module1_BarChild == null) {
      _test_module1_BarChild = new $test_module1_BarChild();
    }
    return _test_module1_BarChild;
  }

  $test_module2_Foo _test_module2_Foo;
  $test_module2_Foo get test_module2_Foo {
    if (_test_module2_Foo == null) {
      _test_module2_Foo = new $test_module2_Foo();
    }
    return _test_module2_Foo;
  }

  $Container _container;
  $Container get container {
    if (_container == null) {
      _container = new $Container();
    }
    return _container;
  }

  $FooContainer _fooContainer;
  $FooContainer get fooContainer {
    if (_fooContainer == null) {
      _fooContainer = new $FooContainer();
    }
    return _fooContainer;
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 5ms
