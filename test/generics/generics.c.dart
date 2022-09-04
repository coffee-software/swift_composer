// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generics.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2022-09-04 12:20:41.453848
// **************************************************************************
// CONFIG
// no config file for root: /home/fsw/workspace/swift_shop/packages/swift_composer/.dart_tool/..//lib/swift_composer.di.yaml
// config file for module_test: /home/fsw/workspace/swift_shop/packages/swift_composer/test/generics/../lib/foo.di.yaml
// no config file for root: /home/fsw/workspace/swift_shop/packages/swift_composer/test/generics/generics.di.yaml
// **************************************************************************
// MERGED CONFIG
// module_test.Foo: {stringField: FooField, integerField: 124}
// module_test.FooChild: {stringField: FooChildField, doubleField: 0.55, booleanField: true}
// module_test.FooChild2: {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
// **************************************************************************
// ALL TYPES INFO
// **************************************************************************
// SubtypesOf => SubtypesOf  GENERIC [T = T   473656069 = 473656069   473656069 = TypeParameterTypeImpl]
// AnnotatedWith => AnnotatedWith   [      ]
// Pluggable => Pluggable   [      ]
// TypePlugin => TypePlugin  GENERIC [T = T   380287154 = 380287154   380287154 = TypeParameterTypeImpl]
// module_test.Foo => module_test.Foo INTERCEPTED  [      ]
// module_test.FooChild => module_test.FooChild INTERCEPTED  [      ]
// module_test.FooChild2 => module_test.FooChild2 INTERCEPTED  [      ]
// Generic => Generic  GENERIC [T = T,F = F   47868079 = 47868079,190009810 = 190009810   47868079 = TypeParameterTypeImpl,190009810 = TypeParameterTypeImpl]
// Generic2 => Generic2  GENERIC [T = A,F = FooChild,A = A   47868079 = 35319755,190009810 = 267179846,35319755 = 35319755   47868079 = TypeParameterTypeImpl,190009810 = InterfaceTypeImpl,35319755 = TypeParameterTypeImpl]
// TypedGeneric2 => TypedGeneric2 INTERCEPTED  [A = Foo,T = Foo,F = FooChild   35319755 = 4632883,47868079 = 4632883,190009810 = 267179846   35319755 = InterfaceTypeImpl,47868079 = InterfaceTypeImpl,190009810 = InterfaceTypeImpl]
// Object => Object   [      ]
// String => String   [T = String   99862877 = 55285317   99862877 = InterfaceTypeImpl]
// List<String> => List<String>   [T = E,E = String   265238202 = 263610483,263610483 = 55285317   265238202 = TypeParameterTypeImpl,263610483 = InterfaceTypeImpl]
// T => T   [      ]
// List<T> => List<T>   [T = E,E = T   265238202 = 263610483,263610483 = 473656069   265238202 = TypeParameterTypeImpl,263610483 = TypeParameterTypeImpl]
// dynamic => dynamic   [      ]
// ST => ST   [      ]
// int => int   [T = num   99862877 = 235444537   99862877 = InterfaceTypeImpl]
// double => double   [T = num   99862877 = 235444537   99862877 = InterfaceTypeImpl]
// bool => bool   [      ]
// F => F   [      ]
// Map<String,F> => Map<String,F>   [K = String,V = F   56096514 = 55285317,255678796 = 190009810   56096514 = InterfaceTypeImpl,255678796 = TypeParameterTypeImpl]
// A => A   [      ]
// Generic<A,module_test.FooChild> => Generic<A,module_test.FooChild>   [T = A,F = FooChild   47868079 = 35319755,190009810 = 267179846   47868079 = TypeParameterTypeImpl,190009810 = InterfaceTypeImpl]
// Map<String,module_test.FooChild> => Map<String,module_test.FooChild>   [K = String,V = F   56096514 = 55285317,255678796 = 190009810   56096514 = InterfaceTypeImpl,255678796 = TypeParameterTypeImpl]
// Generic2<module_test.Foo> => Generic2<module_test.Foo> INTERCEPTED  [T = A,F = FooChild,A = Foo   47868079 = 35319755,190009810 = 267179846,35319755 = 4632883   47868079 = TypeParameterTypeImpl,190009810 = InterfaceTypeImpl,35319755 = InterfaceTypeImpl]
// Generic<module_test.Foo,module_test.FooChild> => Generic<module_test.Foo,module_test.FooChild>   [T = Foo,F = FooChild   47868079 = 4632883,190009810 = 267179846   47868079 = InterfaceTypeImpl,190009810 = InterfaceTypeImpl]
// **************************************************************************
// no interceptor for [SubtypesOf]
// type arguments[1]:
// T[473656069] => T[473656069]
// type arguments[2]:
// can be singleton: FALSE
// parameter: T 473656069
// argument: T 473656069
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: SubtypesOf 1
// TYPE PATH:
//  SubtypesOf
// **************************************************************************
// no interceptor for [AnnotatedWith]
// type arguments[1]:
// type arguments[2]:
// can be singleton: FALSE
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: AnnotatedWith 1
// TYPE PATH:
//  AnnotatedWith
// **************************************************************************
// no interceptor for [Pluggable]
// type arguments[1]:
// type arguments[2]:
// can be singleton: FALSE
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Pluggable 1
// TYPE PATH:
//  Pluggable
// **************************************************************************
// no interceptor for [TypePlugin]
// type arguments[1]:
// T[380287154] => T[380287154]
// type arguments[2]:
// can be singleton: FALSE
// parameter: T 380287154
// argument: T 380287154
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: TypePlugin 1
// TYPE PATH:
//  TypePlugin
// **************************************************************************
// interceptor for [module_test.Foo]
// type arguments[1]:
// type arguments[2]:
// can be singleton: TRUE
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: Pluggable []
// CONFIG
// config: module_test.Foo 1
// config: stringField FooField
// config: integerField 124
// TYPE PATH:
//  module_test.Foo
class $module_test_Foo extends module_test.Foo implements Pluggable {
  $module_test_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// String className
// c: String
  String get className => "module_test.Foo";
// String stringField
// c: String
  String get stringField => "FooField";
// int integerField
// c: int
  int get integerField => 124;
}

// **************************************************************************
// interceptor for [module_test.FooChild]
// type arguments[1]:
// type arguments[2]:
// can be singleton: TRUE
// parent: Foo [@bool get Compose]
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: Pluggable []
// CONFIG
// config: module_test.FooChild 1
// config: stringField FooChildField
// config: doubleField 0.55
// config: booleanField true
// config: module_test.Foo 2
// config: integerField 124
// TYPE PATH:
//  module_test.FooChild
//  module_test.Foo
class $module_test_FooChild extends module_test.FooChild implements Pluggable {
  $module_test_FooChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// double doubleField
// c: double
  double get doubleField => 0.55;
// bool booleanField
// c: bool
  bool get booleanField => true;
// String className
// c: String
  String get className => "module_test.FooChild";
// String stringField
// c: String
  String get stringField => "FooChildField";
// int integerField
// c: int
  int get integerField => 124;
}

// **************************************************************************
// interceptor for [module_test.FooChild2]
// type arguments[1]:
// type arguments[2]:
// can be singleton: FALSE
// parent: Foo [@bool get Compose]
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: Pluggable []
// CONFIG
// config: module_test.FooChild2 1
// config: stringField FooChild2Field
// config: doubleField 0.55
// config: booleanField true
// config: module_test.Foo 2
// config: integerField 124
// TYPE PATH:
//  module_test.FooChild2
//  module_test.Foo
class $module_test_FooChild2 extends module_test.FooChild2
    implements Pluggable {
  $module_test_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// String requiredString
// c: String
// String className
// c: String
  String get className => "module_test.FooChild2";
// String stringField
// c: String
  String get stringField => "FooChild2Field";
// int integerField
// c: int
  int get integerField => 124;
}

// **************************************************************************
// no interceptor for [Generic]
// type arguments[1]:
// T[47868079] => T[47868079]
// F extends Foo[190009810] => F[190009810]
// type arguments[2]:
// can be singleton: FALSE
// parameter: T 47868079
// parameter: F 190009810
// argument: T 47868079
// argument: F 190009810
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Generic 1
// TYPE PATH:
//  Generic
// **************************************************************************
// no interceptor for [Generic2]
// type arguments[1]:
// T[47868079] => A[35319755]
// F extends Foo[190009810] => FooChild[267179846]
// A[35319755] => A[35319755]
// type arguments[2]:
// can be singleton: FALSE
// parameter: A 35319755
// argument: A 35319755
// parent: Generic [@bool get ComposeSubtypes]
// parameter: T 47868079
// parameter: F 190009810
// argument: A 35319755
// argument: FooChild 267179846
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Generic2 1
// config: Generic 2
// TYPE PATH:
//  Generic2
//  Generic
// **************************************************************************
// interceptor for [TypedGeneric2]
// type arguments[1]:
// A[35319755] => Foo[4632883]
// T[47868079] => Foo[4632883]
// F extends Foo[190009810] => FooChild[267179846]
// type arguments[2]:
// can be singleton: TRUE
// parent: Generic2 [@bool get Compose]
// parameter: A 35319755
// argument: Foo 4632883
// parent: Generic [@bool get ComposeSubtypes]
// parameter: T 47868079
// parameter: F 190009810
// argument: Foo 4632883
// argument: FooChild 267179846
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: TypedGeneric2 1
// config: Generic2 2
// config: Generic 3
// TYPE PATH:
//  TypedGeneric2
//  Generic2
//  Generic
class $TypedGeneric2 extends TypedGeneric2 implements Pluggable {
  $TypedGeneric2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// Map<String,module_test.FooChild> instancesOfFoo
// c: Map<String,module_test.FooChild>
  Map<String, module_test.FooChild> get instancesOfFoo =>
      $om.instancesOfmodule_test_FooChild;
//method factoryForFoo override
  module_test.FooChild factoryForFoo(String className) {
    switch (className) {
      case 'module_test.FooChild':
        return new $module_test_FooChild();
    }
    throw new Exception('no type for ' + className);
  }
}

// **************************************************************************
// no interceptor for [Object]
// type arguments[1]:
// type arguments[2]:
// can be singleton: FALSE
// CONFIG
// config: Object 1
// TYPE PATH:
//  Object
// **************************************************************************
// no interceptor for [String]
// type arguments[1]:
// T[99862877] => String[55285317]
// type arguments[2]:
// can be singleton: FALSE
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: Comparable []
// parameter: T 99862877
// argument: String 55285317
// parent: Pattern []
// CONFIG
// config: String 1
// TYPE PATH:
//  String
// **************************************************************************
// no interceptor for [List<String>]
// type arguments[1]:
// T[265238202] => E[263610483]
// E[268730869] => E[263610483]
// E[263610483] => String[55285317]
// type arguments[2]:
// ENCLOSING: XXX
// String[391684894]
// can be singleton: FALSE
// parameter: E 263610483
// argument: E 263610483
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: EfficientLengthIterable []
// parameter: T 265238202
// argument: E 263610483
// parent: Iterable []
// parameter: E 268730869
// argument: E 263610483
// CONFIG
// config: List 1
// TYPE PATH:
//  List
// **************************************************************************
// no interceptor for [T]
// type arguments[1]:
// type arguments[2]:
// **************************************************************************
// no interceptor for [List<T>]
// type arguments[1]:
// T[265238202] => E[263610483]
// E[268730869] => E[263610483]
// E[263610483] => T[473656069]
// type arguments[2]:
// ENCLOSING: NULL
// T[663018988]
// can be singleton: FALSE
// parameter: E 263610483
// argument: E 263610483
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: EfficientLengthIterable []
// parameter: T 265238202
// argument: E 263610483
// parent: Iterable []
// parameter: E 268730869
// argument: E 263610483
// CONFIG
// config: List 1
// TYPE PATH:
//  List
// **************************************************************************
// no interceptor for [dynamic]
// type arguments[1]:
// type arguments[2]:
// **************************************************************************
// no interceptor for [ST]
// type arguments[1]:
// type arguments[2]:
// **************************************************************************
// no interceptor for [int]
// type arguments[1]:
// T[99862877] => num[235444537]
// type arguments[2]:
// can be singleton: FALSE
// parent: num []
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: Comparable []
// parameter: T 99862877
// argument: num 235444537
// CONFIG
// config: int 1
// config: num 2
// TYPE PATH:
//  int
//  num
// **************************************************************************
// no interceptor for [double]
// type arguments[1]:
// T[99862877] => num[235444537]
// type arguments[2]:
// can be singleton: FALSE
// parent: num []
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: Comparable []
// parameter: T 99862877
// argument: num 235444537
// CONFIG
// config: double 1
// config: num 2
// TYPE PATH:
//  double
//  num
// **************************************************************************
// no interceptor for [bool]
// type arguments[1]:
// type arguments[2]:
// can be singleton: FALSE
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: bool 1
// TYPE PATH:
//  bool
// **************************************************************************
// no interceptor for [F]
// type arguments[1]:
// type arguments[2]:
// **************************************************************************
// no interceptor for [Map<String,F>]
// type arguments[1]:
// K[56096514] => String[55285317]
// V[255678796] => F[190009810]
// type arguments[2]:
// ENCLOSING: XXX
// String[391684894]
// ENCLOSING: NULL
// F[398435508]
// can be singleton: FALSE
// parameter: K 56096514
// parameter: V 255678796
// argument: K 56096514
// argument: V 255678796
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Map 1
// TYPE PATH:
//  Map
// **************************************************************************
// no interceptor for [A]
// type arguments[1]:
// type arguments[2]:
// **************************************************************************
// no interceptor for [Generic<A,module_test.FooChild>]
// type arguments[1]:
// T[47868079] => A[35319755]
// F extends Foo[190009810] => FooChild[267179846]
// type arguments[2]:
// ENCLOSING: NULL
// A[883916521]
// ENCLOSING: XXX
// FooChild[23594312]
// can be singleton: FALSE
// parameter: T 47868079
// parameter: F 190009810
// argument: T 47868079
// argument: F 190009810
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Generic 1
// TYPE PATH:
//  Generic
// **************************************************************************
// no interceptor for [Map<String,module_test.FooChild>]
// type arguments[1]:
// K[56096514] => String[55285317]
// V[255678796] => F[190009810]
// type arguments[2]:
// ENCLOSING: XXX
// String[391684894]
// ENCLOSING: XXX
// FooChild[23594312]
// can be singleton: FALSE
// parameter: K 56096514
// parameter: V 255678796
// argument: K 56096514
// argument: V 255678796
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Map 1
// TYPE PATH:
//  Map
// **************************************************************************
// interceptor for [Generic2<module_test.Foo>]
// type arguments[1]:
// T[47868079] => A[35319755]
// F extends Foo[190009810] => FooChild[267179846]
// A[35319755] => Foo[4632883]
// type arguments[2]:
// ENCLOSING: XXX
// Foo[206615716]
// can be singleton: TRUE
// parameter: A 35319755
// argument: A 35319755
// parent: Generic [@bool get ComposeSubtypes]
// parameter: T 47868079
// parameter: F 190009810
// argument: A 35319755
// argument: FooChild 267179846
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Generic2 1
// config: Generic 2
// TYPE PATH:
//  Generic2
//  Generic
//parametrized type
class $Generic2_module_test_Foo_ extends Generic2<module_test.Foo>
    implements Pluggable {
  $Generic2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// Map<String,module_test.FooChild> instancesOfFoo
// c: Map<String,module_test.FooChild>
  Map<String, module_test.FooChild> get instancesOfFoo =>
      $om.instancesOfmodule_test_FooChild;
//method factoryForFoo override
  module_test.FooChild factoryForFoo(String className) {
    switch (className) {
      case 'module_test.FooChild':
        return new $module_test_FooChild();
    }
    throw new Exception('no type for ' + className);
  }
}

// **************************************************************************
// no interceptor for [Generic<module_test.Foo,module_test.FooChild>]
// type arguments[1]:
// T[47868079] => Foo[4632883]
// F extends Foo[190009810] => FooChild[267179846]
// type arguments[2]:
// ENCLOSING: XXX
// Foo[206615716]
// ENCLOSING: XXX
// FooChild[23594312]
// can be singleton: FALSE
// parameter: T 47868079
// parameter: F 190009810
// argument: T 47868079
// argument: F 190009810
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Generic 1
// TYPE PATH:
//  Generic
// **************************************************************************
// no interceptor for [SubtypesOf<T>]
// type arguments[1]:
// T[473656069] => T[473656069]
// type arguments[2]:
// ENCLOSING: NULL
// T[663018988]
// can be singleton: FALSE
// parameter: T 473656069
// argument: T 473656069
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: SubtypesOf 1
// TYPE PATH:
//  SubtypesOf
// **************************************************************************
// no interceptor for [TypePlugin<T>]
// type arguments[1]:
// T[380287154] => T[380287154]
// type arguments[2]:
// ENCLOSING: NULL
// T[663018988]
// can be singleton: FALSE
// parameter: T 380287154
// argument: T 380287154
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: TypePlugin 1
// TYPE PATH:
//  TypePlugin
// **************************************************************************
// no interceptor for [Generic<T,F>]
// type arguments[1]:
// T[47868079] => T[47868079]
// F extends Foo[190009810] => F[190009810]
// type arguments[2]:
// ENCLOSING: NULL
// T[663018988]
// ENCLOSING: NULL
// F[398435508]
// can be singleton: FALSE
// parameter: T 47868079
// parameter: F 190009810
// argument: T 47868079
// argument: F 190009810
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Generic 1
// TYPE PATH:
//  Generic
// **************************************************************************
// no interceptor for [Generic2<A>]
// type arguments[1]:
// T[47868079] => A[35319755]
// F extends Foo[190009810] => FooChild[267179846]
// A[35319755] => A[35319755]
// type arguments[2]:
// ENCLOSING: NULL
// A[883916521]
// can be singleton: FALSE
// parameter: A 35319755
// argument: A 35319755
// parent: Generic [@bool get ComposeSubtypes]
// parameter: T 47868079
// parameter: F 190009810
// argument: A 35319755
// argument: FooChild 267179846
// parent: Object [@pragma pragma(String name, [Object? options])]
// CONFIG
// config: Generic2 1
// config: Generic 2
// TYPE PATH:
//  Generic2
//  Generic
// **************************************************************************
// no interceptor for [num]
// type arguments[1]:
// T[99862877] => num[235444537]
// type arguments[2]:
// can be singleton: FALSE
// parent: Object [@pragma pragma(String name, [Object? options])]
// parent: Comparable []
// parameter: T 99862877
// argument: num 235444537
// CONFIG
// config: num 1
// TYPE PATH:
//  num
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
      "module_test.FooChild": new $module_test_FooChild(),
    };
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 4ms
