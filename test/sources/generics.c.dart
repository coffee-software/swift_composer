// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generics.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2021-08-21 15:23:10.921595
//loading config file /home/fsw/workspace/swift_composer/test/lib/module1.di.yaml
// **************************************************************************
// import package:swift_composer/swift_composer.dart
// import asset:swift_composer/test/lib/module1.dart as module_test
// **************************************************************************
//no interceptor for [AnnotatedWith]
// **************************************************************************
//no interceptor for [Pluggable]
// **************************************************************************
//no interceptor for [TypePlugin]
// **************************************************************************
//interceptor for [module_test.Foo]
//type arguments[1]:
//type arguments[2]:
//can be singleton: TRUE
//parent: Object [@pragma pragma(String name, [Object? options])]
//parent: Pluggable []
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//config: module_test.Foo 1
//config: stringField FooField
//config: integerField 124
//TYPE PATH:
//   module_test.Foo
class $module_test_Foo extends module_test.Foo implements Pluggable {
  $module_test_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => "module_test.Foo";
  String get stringField => "FooField";
  int get integerField => 124;
}

// **************************************************************************
//interceptor for [module_test.FooChild]
//type arguments[1]:
//type arguments[2]:
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
//parent: Object [@pragma pragma(String name, [Object? options])]
//parent: Pluggable []
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//config: module_test.FooChild 1
//config: stringField FooChildField
//config: doubleField 0.55
//config: booleanField true
//config: module_test.Foo 2
//config: integerField 124
//TYPE PATH:
//   module_test.FooChild
//   module_test.Foo
class $module_test_FooChild extends module_test.FooChild implements Pluggable {
  $module_test_FooChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  double get doubleField => 0.55;
  bool get booleanField => true;
  String get className => "module_test.FooChild";
  String get stringField => "FooChildField";
  int get integerField => 124;
}

// **************************************************************************
//interceptor for [module_test.FooChild2]
//type arguments[1]:
//type arguments[2]:
//can be singleton: FALSE
//parent: Foo [@bool get Compose]
//parent: Object [@pragma pragma(String name, [Object? options])]
//parent: Pluggable []
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//config: module_test.FooChild2 1
//config: stringField FooChild2Field
//config: doubleField 0.55
//config: booleanField true
//config: module_test.Foo 2
//config: integerField 124
//TYPE PATH:
//   module_test.FooChild2
//   module_test.Foo
class $module_test_FooChild2 extends module_test.FooChild2
    implements Pluggable {
  $module_test_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => "module_test.FooChild2";
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

// **************************************************************************
//interceptor for [module_test.Bar]
//type arguments[1]:
//type arguments[2]:
//can be singleton: TRUE
//parent: Object [@pragma pragma(String name, [Object? options])]
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//config: module_test.Bar 1
//config: stringField BarField
//TYPE PATH:
//   module_test.Bar
class $module_test_Bar extends module_test.Bar implements Pluggable {
  $module_test_Bar() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get stringField => "BarField";
  List<String> get classNames => [];
}

// **************************************************************************
//interceptor for [module_test.BarChild]
//type arguments[1]:
//type arguments[2]:
//can be singleton: TRUE
//parent: Bar [@bool get Compose]
//parent: Object [@pragma pragma(String name, [Object? options])]
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//config: module_test.BarChild 1
//config: stringField BarChildField
//config: module_test.Bar 2
//TYPE PATH:
//   module_test.BarChild
//   module_test.Bar
class $module_test_BarChild extends module_test.BarChild implements Pluggable {
  $module_test_BarChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get stringField => "BarChildField";
  List<String> get classNames => ['module_test.BarChild'];
}

// **************************************************************************
//interceptor for [module_test.SimpleGeneric]
//type arguments[1]:
//T[99166349] => T[99166349]
//type arguments[2]:
//can be singleton: TRUE
//parameter: T 99166349
//argument: T 99166349
//parent: Object [@pragma pragma(String name, [Object? options])]
//parent: Pluggable []
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//NO ELEMENT!
//config: module_test.SimpleGeneric<module_test.T> 1
//TYPE PATH:
//NO ELEMENT!
//   module_test.SimpleGeneric<module_test.T>
class $module_test_SimpleGeneric<T> extends module_test.SimpleGeneric<T>
    implements Pluggable {
  $module_test_SimpleGeneric() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
//NO ELEMENT!
}

// **************************************************************************
//no interceptor for [Generic]
// **************************************************************************
//interceptor for [Generic2]
//type arguments[1]:
//T[457198808] => A[140979402]
//F extends Foo[247699225] => FooChild[76213371]
//A[140979402] => A[140979402]
//type arguments[2]:
//can be singleton: TRUE
//parameter: A 140979402
//argument: A 140979402
//parent: Generic [@bool get ComposeSubtypes]
//parameter: T 457198808
//parameter: F 247699225
//argument: A 140979402
//argument: FooChild 76213371
//parent: Object [@pragma pragma(String name, [Object? options])]
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//NO ELEMENT!
//NO ELEMENT!
//config: Generic2<A> 1
//config: Generic<A,module_test.FooChild> 2
//TYPE PATH:
//NO ELEMENT!
//   Generic2<A>
//NO ELEMENT!
//   Generic<A,module_test.FooChild>
class $Generic2<A> extends Generic2<A> implements Pluggable {
  $Generic2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  Map<String, module_test.FooChild> get instancesOfFoo =>
      $om.instancesOfmodule_test_FooChild;
//candidate: AnnotatedWith
//element ok
//name not fit
//interceptor ok
//candidate: Pluggable
//element ok
//name not fit
//candidate: TypePlugin
//element ok
//name not fit
//candidate: module_test.Foo
//element ok
//name not fit
//interceptor ok
//candidate: module_test.FooChild
//element ok
//candidate: module_test.FooChild2
//element ok
//name not fit
//interceptor ok
//candidate: module_test.Bar
//element ok
//name not fit
//interceptor ok
//candidate: module_test.BarChild
//element ok
//name not fit
//interceptor ok
//candidate: module_test.SimpleGeneric
//element ok
//name not fit
//interceptor ok
//candidate: Generic
//element ok
//name not fit
//candidate: Generic2
//element ok
//name not fit
//interceptor ok
//candidate: TypedGeneric2
//element ok
//name not fit
//interceptor ok
//candidate: String
//element ok
//name not fit
//candidate: int
//element ok
//name not fit
//candidate: double
//element ok
//name not fit
//candidate: bool
//element ok
//name not fit
//interceptor ok
//candidate: List<String>
//element ok
//name not fit
//candidate: module_test.T
//candidate: module_test.SimpleGeneric<module_test.T>
//element ok
//name not fit
//candidate: void
//candidate: A
//candidate: Generic2<A>
//element ok
//name not fit
//candidate: Generic<A,module_test.FooChild>
//element ok
//name not fit
//candidate: Map<String,module_test.FooChild>
//element ok
//name not fit
  module_test.FooChild factoryForFoo(String className) {
    switch (className) {
      case 'module_test.FooChild':
        return new $module_test_FooChild();
    }
    throw new Exception('no type for' + className);
  }
}

// **************************************************************************
//interceptor for [TypedGeneric2]
//type arguments[1]:
//A[140979402] => Foo[319114392]
//T[457198808] => Foo[319114392]
//F extends Foo[247699225] => FooChild[76213371]
//type arguments[2]:
//can be singleton: TRUE
//parent: Generic2 [@bool get Compose]
//parameter: A 140979402
//argument: Foo 319114392
//parent: Generic [@bool get ComposeSubtypes]
//parameter: T 457198808
//parameter: F 247699225
//argument: Foo 319114392
//argument: FooChild 76213371
//parent: Object [@pragma pragma(String name, [Object? options])]
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//config: TypedGeneric2 1
//config: Generic2<module_test.Foo> 2
//config: Generic<module_test.Foo,module_test.FooChild> 3
//TYPE PATH:
//   TypedGeneric2
//   Generic2<module_test.Foo>
//   Generic<module_test.Foo,module_test.FooChild>
class $TypedGeneric2 extends TypedGeneric2 implements Pluggable {
  $TypedGeneric2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  Map<String, module_test.FooChild> get instancesOfFoo =>
      $om.instancesOfmodule_test_FooChild;
//candidate: AnnotatedWith
//element ok
//name not fit
//interceptor ok
//candidate: Pluggable
//element ok
//name not fit
//candidate: TypePlugin
//element ok
//name not fit
//candidate: module_test.Foo
//element ok
//name not fit
//interceptor ok
//candidate: module_test.FooChild
//element ok
//candidate: module_test.FooChild2
//element ok
//name not fit
//interceptor ok
//candidate: module_test.Bar
//element ok
//name not fit
//interceptor ok
//candidate: module_test.BarChild
//element ok
//name not fit
//interceptor ok
//candidate: module_test.SimpleGeneric
//element ok
//name not fit
//interceptor ok
//candidate: Generic
//element ok
//name not fit
//candidate: Generic2
//element ok
//name not fit
//interceptor ok
//candidate: TypedGeneric2
//element ok
//name not fit
//interceptor ok
//candidate: String
//element ok
//name not fit
//candidate: int
//element ok
//name not fit
//candidate: double
//element ok
//name not fit
//candidate: bool
//element ok
//name not fit
//interceptor ok
//candidate: List<String>
//element ok
//name not fit
//candidate: module_test.T
//candidate: module_test.SimpleGeneric<module_test.T>
//element ok
//name not fit
//candidate: void
//candidate: A
//candidate: Generic2<A>
//element ok
//name not fit
//candidate: Generic<A,module_test.FooChild>
//element ok
//name not fit
//candidate: Map<String,module_test.FooChild>
//element ok
//name not fit
//candidate: Generic2<module_test.Foo>
//element ok
//name not fit
//interceptor ok
//candidate: Generic<module_test.Foo,module_test.FooChild>
//element ok
//name not fit
  module_test.FooChild factoryForFoo(String className) {
    switch (className) {
      case 'module_test.FooChild':
        return new $module_test_FooChild();
    }
    throw new Exception('no type for' + className);
  }
}

// **************************************************************************
//no interceptor for [String]
// **************************************************************************
//no interceptor for [int]
// **************************************************************************
//no interceptor for [double]
// **************************************************************************
//no interceptor for [bool]
// **************************************************************************
//no interceptor for [List<String>]
// **************************************************************************
//no interceptor for [module_test.T]
// **************************************************************************
//no interceptor for [module_test.SimpleGeneric<module_test.T>]
// **************************************************************************
//no interceptor for [void]
// **************************************************************************
//no interceptor for [A]
// **************************************************************************
//no interceptor for [Generic2<A>]
// **************************************************************************
//no interceptor for [Generic<A,module_test.FooChild>]
// **************************************************************************
//no interceptor for [Map<String,module_test.FooChild>]
// **************************************************************************
//interceptor for [Generic2<module_test.Foo>]
//type arguments[1]:
//T[457198808] => A[140979402]
//F extends Foo[247699225] => FooChild[76213371]
//A[140979402] => A[140979402]
//type arguments[2]:
//ENCLOSING: XXX
//Foo[887780481]
//can be singleton: TRUE
//parameter: A 140979402
//argument: A 140979402
//parent: Generic [@bool get ComposeSubtypes]
//parameter: T 457198808
//parameter: F 247699225
//argument: A 140979402
//argument: FooChild 76213371
//parent: Object [@pragma pragma(String name, [Object? options])]
//CONFIG
//config: module_test.Foo {stringField: FooField, integerField: 124}
//config: module_test.FooChild {stringField: FooChildField, doubleField: 0.55, booleanField: true}
//config: module_test.FooChild2 {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
//config: module_test.Bar {stringField: BarField}
//config: module_test.BarChild {stringField: BarChildField}
//NO ELEMENT!
//NO ELEMENT!
//config: Generic2<A> 1
//config: Generic<A,module_test.FooChild> 2
//TYPE PATH:
//NO ELEMENT!
//   Generic2<A>
//NO ELEMENT!
//   Generic<A,module_test.FooChild>
//parametrized type
class $Generic2_module_test_Foo_ extends $Generic2<$module_test_Foo>
    implements Pluggable {
  $Generic2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  Map<String, module_test.FooChild> get instancesOfFoo =>
      $om.instancesOfmodule_test_FooChild;
//candidate: AnnotatedWith
//element ok
//name not fit
//interceptor ok
//candidate: Pluggable
//element ok
//name not fit
//candidate: TypePlugin
//element ok
//name not fit
//candidate: module_test.Foo
//element ok
//name not fit
//interceptor ok
//candidate: module_test.FooChild
//element ok
//candidate: module_test.FooChild2
//element ok
//name not fit
//interceptor ok
//candidate: module_test.Bar
//element ok
//name not fit
//interceptor ok
//candidate: module_test.BarChild
//element ok
//name not fit
//interceptor ok
//candidate: module_test.SimpleGeneric
//element ok
//name not fit
//interceptor ok
//candidate: Generic
//element ok
//name not fit
//candidate: Generic2
//element ok
//name not fit
//interceptor ok
//candidate: TypedGeneric2
//element ok
//name not fit
//interceptor ok
//candidate: String
//element ok
//name not fit
//candidate: int
//element ok
//name not fit
//candidate: double
//element ok
//name not fit
//candidate: bool
//element ok
//name not fit
//interceptor ok
//candidate: List<String>
//element ok
//name not fit
//candidate: module_test.T
//candidate: module_test.SimpleGeneric<module_test.T>
//element ok
//name not fit
//candidate: void
//candidate: A
//candidate: Generic2<A>
//element ok
//name not fit
//candidate: Generic<A,module_test.FooChild>
//element ok
//name not fit
//candidate: Map<String,module_test.FooChild>
//element ok
//name not fit
//candidate: Generic2<module_test.Foo>
//element ok
//name not fit
//interceptor ok
//candidate: Generic<module_test.Foo,module_test.FooChild>
//element ok
//name not fit
  module_test.FooChild factoryForFoo(String className) {
    switch (className) {
      case 'module_test.FooChild':
        return new $module_test_FooChild();
    }
    throw new Exception('no type for' + className);
  }
}

// **************************************************************************
//no interceptor for [Generic<module_test.Foo,module_test.FooChild>]
// **************************************************************************
// All Types:
//AnnotatedWith AnnotatedWith
//Pluggable Pluggable
//TypePlugin TypePlugin
//module_test.Foo module_test.Foo
//module_test.FooChild module_test.FooChild
//module_test.FooChild2 module_test.FooChild2
//module_test.Bar module_test.Bar
//module_test.BarChild module_test.BarChild
//module_test.SimpleGeneric module_test.SimpleGeneric
//Generic Generic
//Generic2 Generic2
//TypedGeneric2 TypedGeneric2
//String String
//int int
//double double
//bool bool
//List<String> List<String>
//module_test.T module_test.T
//module_test.SimpleGeneric<module_test.T> module_test.SimpleGeneric<module_test.T>
//void void
//A A
//Generic2<A> Generic2<A>
//Generic<A,module_test.FooChild> Generic<A,module_test.FooChild>
//Map<String,module_test.FooChild> Map<String,module_test.FooChild>
//Generic2<module_test.Foo> Generic2<module_test.Foo>
//Generic<module_test.Foo,module_test.FooChild> Generic<module_test.Foo,module_test.FooChild>
// **************************************************************************
class $ObjectManager {
  $module_test_Foo? _module_test_Foo;
  $module_test_Foo get module_test_Foo {
    if (_module_test_Foo == null) {
      _module_test_Foo = new $module_test_Foo();
    }
    return _module_test_Foo as $module_test_Foo;
  }

  $module_test_FooChild? _module_test_FooChild;
  $module_test_FooChild get module_test_FooChild {
    if (_module_test_FooChild == null) {
      _module_test_FooChild = new $module_test_FooChild();
    }
    return _module_test_FooChild as $module_test_FooChild;
  }

  $module_test_Bar? _module_test_Bar;
  $module_test_Bar get module_test_Bar {
    if (_module_test_Bar == null) {
      _module_test_Bar = new $module_test_Bar();
    }
    return _module_test_Bar as $module_test_Bar;
  }

  $module_test_BarChild? _module_test_BarChild;
  $module_test_BarChild get module_test_BarChild {
    if (_module_test_BarChild == null) {
      _module_test_BarChild = new $module_test_BarChild();
    }
    return _module_test_BarChild as $module_test_BarChild;
  }

  $module_test_SimpleGeneric? _module_test_SimpleGeneric;
  $module_test_SimpleGeneric get module_test_SimpleGeneric {
    if (_module_test_SimpleGeneric == null) {
      _module_test_SimpleGeneric = new $module_test_SimpleGeneric();
    }
    return _module_test_SimpleGeneric as $module_test_SimpleGeneric;
  }

  $Generic2? _generic2;
  $Generic2 get generic2 {
    if (_generic2 == null) {
      _generic2 = new $Generic2();
    }
    return _generic2 as $Generic2;
  }

  $TypedGeneric2? _typedGeneric2;
  $TypedGeneric2 get typedGeneric2 {
    if (_typedGeneric2 == null) {
      _typedGeneric2 = new $TypedGeneric2();
    }
    return _typedGeneric2 as $TypedGeneric2;
  }

  $Generic2_module_test_Foo_? _generic2_module_test_Foo_;
  $Generic2_module_test_Foo_ get generic2_module_test_Foo_ {
    if (_generic2_module_test_Foo_ == null) {
      _generic2_module_test_Foo_ = new $Generic2_module_test_Foo_();
    }
    return _generic2_module_test_Foo_ as $Generic2_module_test_Foo_;
  }

  Map<String, module_test.FooChild> get instancesOfmodule_test_FooChild {
    return {
//candidate: AnnotatedWith
//element ok
//name not fit
//interceptor ok
//candidate: Pluggable
//element ok
//name not fit
//candidate: TypePlugin
//element ok
//name not fit
//candidate: module_test.Foo
//element ok
//name not fit
//interceptor ok
//candidate: module_test.FooChild
//element ok
//candidate: module_test.FooChild2
//element ok
//name not fit
//interceptor ok
//candidate: module_test.Bar
//element ok
//name not fit
//interceptor ok
//candidate: module_test.BarChild
//element ok
//name not fit
//interceptor ok
//candidate: module_test.SimpleGeneric
//element ok
//name not fit
//interceptor ok
//candidate: Generic
//element ok
//name not fit
//candidate: Generic2
//element ok
//name not fit
//interceptor ok
//candidate: TypedGeneric2
//element ok
//name not fit
//interceptor ok
//candidate: String
//element ok
//name not fit
//candidate: int
//element ok
//name not fit
//candidate: double
//element ok
//name not fit
//candidate: bool
//element ok
//name not fit
//interceptor ok
//candidate: List<String>
//element ok
//name not fit
//candidate: module_test.T
//candidate: module_test.SimpleGeneric<module_test.T>
//element ok
//name not fit
//candidate: void
//candidate: A
//candidate: Generic2<A>
//element ok
//name not fit
//candidate: Generic<A,module_test.FooChild>
//element ok
//name not fit
//candidate: Map<String,module_test.FooChild>
//element ok
//name not fit
//candidate: Generic2<module_test.Foo>
//element ok
//name not fit
//interceptor ok
//candidate: Generic<module_test.Foo,module_test.FooChild>
//element ok
//name not fit
      "module_test.FooChild": new $module_test_FooChild(),
    };
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 230ms
