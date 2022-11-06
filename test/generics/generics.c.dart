// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generics.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2022-11-06 14:28:47.432484
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
// **************************************************************************
// no interceptor for [SubtypesOf]
// **************************************************************************
// no interceptor for [AnnotatedWith]
// **************************************************************************
// no interceptor for [Pluggable]
// **************************************************************************
// no interceptor for [TypePlugin]
// **************************************************************************
// interceptor for [module_test.Foo]
class $module_test_Foo extends module_test.Foo implements Pluggable {
  $module_test_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// String className
  String get className => "module_test.Foo";
// String stringField
  String get stringField => "FooField";
// int integerField
  int get integerField => 124;
}

// **************************************************************************
// interceptor for [module_test.FooChild]
class $module_test_FooChild extends module_test.FooChild implements Pluggable {
  $module_test_FooChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// double doubleField
  double get doubleField => 0.55;
// bool booleanField
  bool get booleanField => true;
// String className
  String get className => "module_test.FooChild";
// String stringField
  String get stringField => "FooChildField";
// int integerField
  int get integerField => 124;
}

// **************************************************************************
// interceptor for [module_test.FooChild2]
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
// String className
  String get className => "module_test.FooChild2";
// String stringField
  String get stringField => "FooChild2Field";
// int integerField
  int get integerField => 124;
}

// **************************************************************************
// no interceptor for [Generic]
// **************************************************************************
// no interceptor for [Generic2]
// **************************************************************************
// interceptor for [TypedGeneric2]
class $TypedGeneric2 extends TypedGeneric2 implements Pluggable {
  $TypedGeneric2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// Map<String,module_test.FooChild> instancesOfFoo
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
// **************************************************************************
// no interceptor for [String]
// **************************************************************************
// no interceptor for [List<String>]
// **************************************************************************
// no interceptor for [T]
// **************************************************************************
// no interceptor for [List<T>]
// **************************************************************************
// no interceptor for [dynamic]
// **************************************************************************
// no interceptor for [ST]
// **************************************************************************
// no interceptor for [int]
// **************************************************************************
// no interceptor for [double]
// **************************************************************************
// no interceptor for [bool]
// **************************************************************************
// no interceptor for [F]
// **************************************************************************
// no interceptor for [Map<String,F>]
// **************************************************************************
// no interceptor for [A]
// **************************************************************************
// no interceptor for [Generic<A,module_test.FooChild>]
// **************************************************************************
// no interceptor for [Map<String,module_test.FooChild>]
// **************************************************************************
// interceptor for [Generic2<module_test.Foo>]
//parametrized type
class $Generic2_module_test_Foo_ extends Generic2<module_test.Foo>
    implements Pluggable {
  $Generic2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// Map<String,module_test.FooChild> instancesOfFoo
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

  Map<String, module_test.FooChild>? _instancesOfmodule_test_FooChild;
  Map<String, module_test.FooChild> get instancesOfmodule_test_FooChild {
    if (_instancesOfmodule_test_FooChild != null)
      return _instancesOfmodule_test_FooChild!;
    return _instancesOfmodule_test_FooChild = {
      "module_test.FooChild": module_test_FooChild,
    };
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 192ms
