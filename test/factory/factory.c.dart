// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2023-02-18 08:36:53.640573
// **************************************************************************
// CONFIG
// no config file for root: /home/fsw/workspace/swift_shop/packages/swift_composer/.dart_tool/..//lib/swift_composer.di.yaml
// config file for module_test: /home/fsw/workspace/swift_shop/packages/swift_composer/test/factory/../lib/foo.di.yaml
// no config file for root: /home/fsw/workspace/swift_shop/packages/swift_composer/test/factory/factory.di.yaml
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
// interceptor for [Complex]
class $Complex extends Complex implements Pluggable {
  $Complex(requiredString, requiredFoo) {
//String
    this.requiredString = requiredString;
//Foo
    this.requiredFoo = requiredFoo;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
// String requiredString
// module_test.Foo requiredFoo
}

// **************************************************************************
// interceptor for [Container]
class $Container extends Container implements Pluggable {
  $Container() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

//method createFoo override
  module_test.Foo createFoo() {
//module_test.Foo
    return new $module_test_Foo();
  }

//method createComplex override
  Complex createComplex(String requiredString, module_test.Foo requiredFoo) {
//Complex
    return new $Complex(requiredString, requiredFoo);
  }

//method createSubFoo override
  module_test.Foo createSubFoo(String className) {
    switch (className) {
      case 'module_test.Foo':
        return new $module_test_Foo();
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
// no interceptor for [Map<String,String>]
// **************************************************************************
// no interceptor for [T]
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
// no interceptor for [void]
// **************************************************************************
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

  $Container? _container;
  $Container get container {
    if (_container == null) {
      _container = new $Container();
    }
    return _container as $Container;
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 11ms
