// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compose.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2025-04-27 17:50:12.315277
// ignore common warnings in generated code, you can also exclude this file in analysis_options.yaml
// ignore_for_file: unnecessary_non_null_assertion
// ignore_for_file: dead_null_aware_expression
// **************************************************************************
// CONFIG
// config file for foo: test/lib/foo.di.yaml
// no config file for generics: test/lib/generics.di.yaml
// no config file for root: lib/swift_composer.di.yaml
// no config file for root: test/compose/compose.di.yaml
// **************************************************************************
// MERGED CONFIG
// foo.Foo: {stringField: FooField, integerField: 124}
// foo.FooChild: {stringField: FooChildField, doubleField: 0.55, booleanField: true}
// foo.FooChild2: {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
// **************************************************************************
//register: SubtypeInfo
//register: SubtypesOf
//register: UnknownTypeException
//register: AnnotatedWith
//register: Pluggable
//register: TypePlugin
//register: foo.Foo
//register: foo.FooChild
//register: foo.FooChild2
//register: generics.SimpleGeneric
//register: generics.Param
//register: generics.SimpleSpecific
//register: generics.ComplexGeneric
//register: generics.SuperComplexGeneric
//register: Container
// **************************************************************************
class $foo_Foo extends foo.Foo implements Pluggable {
  $foo_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => $om.s[0];
  String get stringField => "FooField";
  int get integerField => 124;
}

// **************************************************************************
class $foo_FooChild extends foo.FooChild implements Pluggable {
  $foo_FooChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  double get doubleField => 0.55;
  bool get booleanField => true;
  String get className => $om.s[1];
  String get stringField => "FooChildField";
  int get integerField => 124;
}

// **************************************************************************
class $foo_FooChild2 extends foo.FooChild2 implements Pluggable {
  $foo_FooChild2(requiredString) {
    this.requiredString = requiredString;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => $om.s[2];
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

// **************************************************************************
class $generics_Param extends generics.Param implements Pluggable {
  $generics_Param() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
class $generics_SimpleSpecific extends generics.SimpleSpecific
    implements Pluggable {
  $generics_SimpleSpecific() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
class $Container extends Container implements Pluggable {
  $Container(fooRequired, genericOfFooRequired, genericOfStringRequired,
      complexGenericRequired) {
    this.fooCreated = new $foo_Foo();
    this.genericOfFooCreated = new $generics_SimpleGeneric_foo_Foo_();
    this.genericOfStringCreated = new $generics_SimpleGeneric_String_();
    this.complexGenericCreated =
        new $generics_ComplexGeneric_foo_Foo_foo_Foo_();
    this.fooRequired = fooRequired;
    this.genericOfFooRequired = genericOfFooRequired;
    this.genericOfStringRequired = genericOfStringRequired;
    this.complexGenericRequired = complexGenericRequired;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  foo.Foo get fooInjected => $om.foo_Foo;
  generics.SimpleGeneric<foo.Foo> get genericOfFooInjected =>
      $om.generics_SimpleGeneric_foo_Foo_;
  generics.SimpleGeneric<String> get genericOfStringInjected =>
      $om.generics_SimpleGeneric_String_;
  generics.ComplexGeneric<foo.Foo, foo.Foo> get complexGenericInjected =>
      $om.generics_ComplexGeneric_foo_Foo_foo_Foo_;
}

// **************************************************************************
//parametrized type
class $generics_SimpleGeneric_generics_Param_
    extends generics.SimpleGeneric<generics.Param> implements Pluggable {
  $generics_SimpleGeneric_generics_Param_() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
//parametrized type
class $generics_SimpleGeneric_foo_Foo_ extends generics.SimpleGeneric<foo.Foo>
    implements Pluggable {
  $generics_SimpleGeneric_foo_Foo_() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
//parametrized type
class $generics_SimpleGeneric_String_ extends generics.SimpleGeneric<String>
    implements Pluggable {
  $generics_SimpleGeneric_String_() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
//parametrized type
class $generics_ComplexGeneric_foo_Foo_foo_Foo_
    extends generics.ComplexGeneric<foo.Foo, foo.Foo> implements Pluggable {
  $generics_ComplexGeneric_foo_Foo_foo_Foo_() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  foo.Foo get injectedA => $om.foo_Foo;
  foo.Foo get injectedB => $om.foo_Foo;
}

// **************************************************************************
// **************************************************************************
// **************************************************************************
class $ObjectManager {
  $foo_Foo? _foo_Foo;
  $foo_Foo get foo_Foo {
    if (_foo_Foo == null) {
      _foo_Foo = new $foo_Foo();
    }
    return _foo_Foo as $foo_Foo;
  }

  $foo_FooChild? _foo_FooChild;
  $foo_FooChild get foo_FooChild {
    if (_foo_FooChild == null) {
      _foo_FooChild = new $foo_FooChild();
    }
    return _foo_FooChild as $foo_FooChild;
  }

  $generics_Param? _generics_Param;
  $generics_Param get generics_Param {
    if (_generics_Param == null) {
      _generics_Param = new $generics_Param();
    }
    return _generics_Param as $generics_Param;
  }

  $generics_SimpleSpecific? _generics_SimpleSpecific;
  $generics_SimpleSpecific get generics_SimpleSpecific {
    if (_generics_SimpleSpecific == null) {
      _generics_SimpleSpecific = new $generics_SimpleSpecific();
    }
    return _generics_SimpleSpecific as $generics_SimpleSpecific;
  }

  $generics_SimpleGeneric_generics_Param_?
      _generics_SimpleGeneric_generics_Param_;
  $generics_SimpleGeneric_generics_Param_
      get generics_SimpleGeneric_generics_Param_ {
    if (_generics_SimpleGeneric_generics_Param_ == null) {
      _generics_SimpleGeneric_generics_Param_ =
          new $generics_SimpleGeneric_generics_Param_();
    }
    return _generics_SimpleGeneric_generics_Param_
        as $generics_SimpleGeneric_generics_Param_;
  }

  $generics_SimpleGeneric_foo_Foo_? _generics_SimpleGeneric_foo_Foo_;
  $generics_SimpleGeneric_foo_Foo_ get generics_SimpleGeneric_foo_Foo_ {
    if (_generics_SimpleGeneric_foo_Foo_ == null) {
      _generics_SimpleGeneric_foo_Foo_ = new $generics_SimpleGeneric_foo_Foo_();
    }
    return _generics_SimpleGeneric_foo_Foo_ as $generics_SimpleGeneric_foo_Foo_;
  }

  $generics_SimpleGeneric_String_? _generics_SimpleGeneric_String_;
  $generics_SimpleGeneric_String_ get generics_SimpleGeneric_String_ {
    if (_generics_SimpleGeneric_String_ == null) {
      _generics_SimpleGeneric_String_ = new $generics_SimpleGeneric_String_();
    }
    return _generics_SimpleGeneric_String_ as $generics_SimpleGeneric_String_;
  }

  $generics_ComplexGeneric_foo_Foo_foo_Foo_?
      _generics_ComplexGeneric_foo_Foo_foo_Foo_;
  $generics_ComplexGeneric_foo_Foo_foo_Foo_
      get generics_ComplexGeneric_foo_Foo_foo_Foo_ {
    if (_generics_ComplexGeneric_foo_Foo_foo_Foo_ == null) {
      _generics_ComplexGeneric_foo_Foo_foo_Foo_ =
          new $generics_ComplexGeneric_foo_Foo_foo_Foo_();
    }
    return _generics_ComplexGeneric_foo_Foo_foo_Foo_
        as $generics_ComplexGeneric_foo_Foo_foo_Foo_;
  }

  final List<String> s = const ["foo.Foo", "foo.FooChild", "foo.FooChild2"];
}

$ObjectManager $om = new $ObjectManager();
// generated in 7ms
