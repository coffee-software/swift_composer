// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generics.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

//no interceptor for [AnnotatedWith]
//no interceptor for [Pluggable]
//no interceptor for [TypePlugin]
//interceptor for [module_test.Foo]
//interceptor for module_test.Foo
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
class $module_test_Foo extends module_test.Foo {
  $module_test_Foo() {}
  T plugin<T>() {}
  String get className => "module_test.Foo";
  String get stringField => "FooField";
  int get integerField => 124;
}

//interceptor for [module_test.FooChild]
//interceptor for module_test.FooChild
//can be singleton: TRUE
//parent: FooChild [@bool get Compose]
//parent: Foo [@bool get Compose]
class $module_test_FooChild extends module_test.FooChild {
  $module_test_FooChild() {}
  T plugin<T>() {}
  String get className => "module_test.FooChild";
  String get stringField => "FooChildField";
  int get integerField => 124;
  double get doubleField => 0.55;
  bool get booleanField => true;
}

//interceptor for [module_test.FooChild2]
//interceptor for module_test.FooChild2
//can be singleton: FALSE
//parent: FooChild2 [@bool get Compose]
//parent: Foo [@bool get Compose]
class $module_test_FooChild2 extends module_test.FooChild2 {
  $module_test_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {}
  String get className => "module_test.FooChild2";
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

//interceptor for [module_test.Bar]
//interceptor for module_test.Bar
//can be singleton: TRUE
//parent: Bar [@bool get Compose]
class $module_test_Bar extends module_test.Bar {
  $module_test_Bar() {}
  T plugin<T>() {}
  String get stringField => "BarField";
  List<String> get classNames => [];
}

//interceptor for [module_test.BarChild]
//interceptor for module_test.BarChild
//can be singleton: TRUE
//parent: BarChild [@bool get Compose]
//parent: Bar [@bool get Compose]
class $module_test_BarChild extends module_test.BarChild {
  $module_test_BarChild() {}
  T plugin<T>() {}
  String get stringField => "BarChildField";
  List<String> get classNames => ['module_test.BarChild'];
}

//interceptor for [module_test.SimpleGeneric]
//interceptor for module_test.SimpleGeneric
//can be singleton: FALSE
//parent: SimpleGeneric [@bool get Compose]
class $module_test_SimpleGeneric<T> extends module_test.SimpleGeneric<T> {
  $module_test_SimpleGeneric() {}
  T plugin<T>() {}
}

//interceptor for [Generic]
//interceptor for Generic
//can be singleton: FALSE
//parent: Generic [@bool get Compose]
class $Generic<T, F extends module_test.Foo> extends Generic<T, F> {
  $Generic() {}
  T plugin<T>() {}
}

//interceptor for [Generic2]
//interceptor for Generic2
//T[457198808] => A[140979402]
//F[247699225] => FooChild[474600074]
//can be singleton: FALSE
//parent: Generic2 [@bool get Compose]
//parent: Generic [@bool get Compose]
class $Generic2<A> extends Generic2<A> {
  $Generic2() {}
  T plugin<T>() {}
}

//interceptor for [TypedGeneric2]
//interceptor for TypedGeneric2
//A[140979402] => Foo[180531561]
//T[457198808] => Foo[180531561]
//F[247699225] => FooChild[474600074]
//can be singleton: TRUE
//parent: TypedGeneric2 [@bool get Compose]
//parent: Generic2 [@bool get Compose]
//parent: Generic [@bool get Compose]
class $TypedGeneric2 extends TypedGeneric2 {
  $TypedGeneric2() {}
  T plugin<T>() {}
}

class $ObjectManager {
  $module_test_Foo _module_test_Foo;
  $module_test_Foo get module_test_Foo {
    if (_module_test_Foo == null) {
      _module_test_Foo = new $module_test_Foo();
    }
    return _module_test_Foo;
  }

  $module_test_FooChild _module_test_FooChild;
  $module_test_FooChild get module_test_FooChild {
    if (_module_test_FooChild == null) {
      _module_test_FooChild = new $module_test_FooChild();
    }
    return _module_test_FooChild;
  }

  $module_test_Bar _module_test_Bar;
  $module_test_Bar get module_test_Bar {
    if (_module_test_Bar == null) {
      _module_test_Bar = new $module_test_Bar();
    }
    return _module_test_Bar;
  }

  $module_test_BarChild _module_test_BarChild;
  $module_test_BarChild get module_test_BarChild {
    if (_module_test_BarChild == null) {
      _module_test_BarChild = new $module_test_BarChild();
    }
    return _module_test_BarChild;
  }

  $TypedGeneric2 _typedGeneric2;
  $TypedGeneric2 get typedGeneric2 {
    if (_typedGeneric2 == null) {
      _typedGeneric2 = new $TypedGeneric2();
    }
    return _typedGeneric2;
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 7ms
