// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2023-04-15 22:05:03.018191
// **************************************************************************
// CONFIG
// no config file for root: lib/swift_composer.di.yaml
// config file for m1: test/lib/foo.di.yaml
// config file for m2: test/lib/foo2.di.yaml
// no config file for generics: test/lib/generics.di.yaml
// config file for root: test/config/config.di.yaml
// **************************************************************************
// MERGED CONFIG
// m1.Foo: {stringField: FooField, integerField: 124}
// m1.FooChild: {stringField: FooChildField, doubleField: 0.55, booleanField: true}
// m1.FooChild2: {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
// m2.Foo: {stringField2: Foo2Field}
// VirtualTypeX: {extends: m1.SimpleGeneric<m1.Foo>, stringField: FooStringField2}
// **************************************************************************
// **************************************************************************
class $m1_Foo extends m1.Foo implements Pluggable {
  $m1_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => "m1.Foo";
  String get stringField => "FooField";
  int get integerField => 124;
}

// **************************************************************************
class $m1_FooChild extends m1.FooChild implements Pluggable {
  $m1_FooChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  double get doubleField => 0.55;
  bool get booleanField => true;
  String get className => "m1.FooChild";
  String get stringField => "FooChildField";
  int get integerField => 124;
}

// **************************************************************************
class $m1_FooChild2 extends m1.FooChild2 implements Pluggable {
  $m1_FooChild2(requiredString) {
    this.requiredString = requiredString;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => "m1.FooChild2";
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

// **************************************************************************
class $m2_Foo extends m2.Foo implements Pluggable {
  $m2_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => "m2.Foo";
  String? get stringField2 => "Foo2Field";
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
  $Container(fooRequired, genericRequired) {
    this.fooCreated = new $m1_Foo();
    this.genericCreated = new $generics_SimpleGeneric_m1_Foo_();
    this.fooRequired = fooRequired;
    this.genericRequired = genericRequired;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  m1.Foo get fooInjected => $om.m1_Foo;
  generics.SimpleGeneric<m1.Foo> get genericInjected =>
      $om.generics_SimpleGeneric_m1_Foo_;
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
class $generics_SimpleGeneric_m1_Foo_ extends generics.SimpleGeneric<m1.Foo>
    implements Pluggable {
  $generics_SimpleGeneric_m1_Foo_() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
//parametrized type
class $generics_SimpleGeneric_m2_Foo_ extends generics.SimpleGeneric<m2.Foo>
    implements Pluggable {
  $generics_SimpleGeneric_m2_Foo_() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
// **************************************************************************
class $ObjectManager {
  $m1_Foo? _m1_Foo;
  $m1_Foo get m1_Foo {
    if (_m1_Foo == null) {
      _m1_Foo = new $m1_Foo();
    }
    return _m1_Foo as $m1_Foo;
  }

  $m1_FooChild? _m1_FooChild;
  $m1_FooChild get m1_FooChild {
    if (_m1_FooChild == null) {
      _m1_FooChild = new $m1_FooChild();
    }
    return _m1_FooChild as $m1_FooChild;
  }

  $m2_Foo? _m2_Foo;
  $m2_Foo get m2_Foo {
    if (_m2_Foo == null) {
      _m2_Foo = new $m2_Foo();
    }
    return _m2_Foo as $m2_Foo;
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

  $generics_SimpleGeneric_m1_Foo_? _generics_SimpleGeneric_m1_Foo_;
  $generics_SimpleGeneric_m1_Foo_ get generics_SimpleGeneric_m1_Foo_ {
    if (_generics_SimpleGeneric_m1_Foo_ == null) {
      _generics_SimpleGeneric_m1_Foo_ = new $generics_SimpleGeneric_m1_Foo_();
    }
    return _generics_SimpleGeneric_m1_Foo_ as $generics_SimpleGeneric_m1_Foo_;
  }

  $generics_SimpleGeneric_m2_Foo_? _generics_SimpleGeneric_m2_Foo_;
  $generics_SimpleGeneric_m2_Foo_ get generics_SimpleGeneric_m2_Foo_ {
    if (_generics_SimpleGeneric_m2_Foo_ == null) {
      _generics_SimpleGeneric_m2_Foo_ = new $generics_SimpleGeneric_m2_Foo_();
    }
    return _generics_SimpleGeneric_m2_Foo_ as $generics_SimpleGeneric_m2_Foo_;
  }
}

$ObjectManager $om = new $ObjectManager();
// generated in 9ms
