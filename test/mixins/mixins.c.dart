// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixins.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2025-04-27 17:50:12.273860
// ignore common warnings in generated code, you can also exclude this file in analysis_options.yaml
// ignore_for_file: unnecessary_non_null_assertion
// ignore_for_file: dead_null_aware_expression
// **************************************************************************
// CONFIG
// config file for module_test: test/lib/foo.di.yaml
// no config file for root: lib/swift_composer.di.yaml
// no config file for root: test/mixins/mixins.di.yaml
// **************************************************************************
// MERGED CONFIG
// module_test.Foo: {stringField: FooField, integerField: 124}
// module_test.FooChild: {stringField: FooChildField, doubleField: 0.55, booleanField: true}
// module_test.FooChild2: {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
// **************************************************************************
//register: SubtypeInfo
//register: SubtypesOf
//register: UnknownTypeException
//register: AnnotatedWith
//register: Pluggable
//register: TypePlugin
//register: module_test.Foo
//register: module_test.FooChild
//register: module_test.FooChild2
//register: TestMixin1
//register: MixinUser1
//register: MixinUser2
//register: MixinUser3
//register: Container
//register: TestMixin2
//register: TestMixin3
// **************************************************************************
class $module_test_Foo extends module_test.Foo implements Pluggable {
  $module_test_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  String get className => $om.s[0];
  String get stringField => "FooField";
  int get integerField => 124;
}

// **************************************************************************
class $module_test_FooChild extends module_test.FooChild implements Pluggable {
  $module_test_FooChild() {}
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
class $module_test_FooChild2 extends module_test.FooChild2
    implements Pluggable {
  $module_test_FooChild2(requiredString) {
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
class $MixinUser1 extends MixinUser1 implements Pluggable {
  $MixinUser1() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

//method fieldsToJson override
  void fieldsToJson(Map<dynamic, dynamic> target) {
//compiled method
//dbg: fieldsToJson
    cfs_fieldsToJsonMixinUser1(this, target);
    cfs_fieldsToJsonTestMixin1(this, target);
  }
}

// **************************************************************************
class $MixinUser2 extends MixinUser2 implements Pluggable {
  $MixinUser2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

//method createFoo override
  module_test.Foo createFoo() {
//module_test.Foo
    return new $module_test_Foo();
  }

//method fieldsToJson override
  void fieldsToJson(Map<dynamic, dynamic> target) {
//compiled method
    cfs_fieldsToJsonMixinUser1(this, target);
    cfs_fieldsToJsonTestMixin1(this, target);
    cfs_fieldsToJsonMixinUser2(this, target);
    cfs_fieldsToJsonTestMixin2(this, target);
  }
}

// **************************************************************************
class $MixinUser3 extends MixinUser3 implements Pluggable {
  $MixinUser3() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

//method createFoo override
  module_test.Foo createFoo() {
//module_test.Foo
    return new $module_test_Foo();
  }

//method fieldsToJson override
  void fieldsToJson(Map<dynamic, dynamic> target) {
//compiled method
    cfs_fieldsToJsonMixinUser1(this, target);
    cfs_fieldsToJsonTestMixin1(this, target);
    cfs_fieldsToJsonTestMixin2(this, target);
  }

  @override
  String get mixin1Field => override_mixin1Field;
}

// **************************************************************************
class $Container extends Container implements Pluggable {
  $Container() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  Map<String, MixinUser1> get instancesOfMixinUser1 =>
      $om.instancesOfMixinUser1;
  Map<String, TestMixin1> get instancesOfTestMixin1 =>
      $om.instancesOfTestMixin1;
  Map<String, TestMixin2> get instancesOfTestMixin2 =>
      $om.instancesOfTestMixin2;
}

// **************************************************************************
// **************************************************************************
void cfs_fieldsToJsonMixinUser1(MixinUser1 dis, Map<dynamic, dynamic> target) {
  {
    const name = "ownField1";
    target[name] = dis.ownField1;
  }
}

void cfs_fieldsToJsonTestMixin1(TestMixin1 dis, Map<dynamic, dynamic> target) {
  {
    const name = "mixin1Field";
    target[name] = dis.mixin1Field;
  }
}

void cfs_fieldsToJsonMixinUser2(MixinUser2 dis, Map<dynamic, dynamic> target) {
  {
    const name = "ownField2";
    target[name] = dis.ownField2;
  }
}

void cfs_fieldsToJsonTestMixin2(TestMixin2 dis, Map<dynamic, dynamic> target) {
  {
    const name = "mixin2Field";
    target[name] = dis.mixin2Field;
  }
}

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

  $MixinUser1? _mixinUser1;
  $MixinUser1 get mixinUser1 {
    if (_mixinUser1 == null) {
      _mixinUser1 = new $MixinUser1();
    }
    return _mixinUser1 as $MixinUser1;
  }

  $MixinUser2? _mixinUser2;
  $MixinUser2 get mixinUser2 {
    if (_mixinUser2 == null) {
      _mixinUser2 = new $MixinUser2();
    }
    return _mixinUser2 as $MixinUser2;
  }

  $MixinUser3? _mixinUser3;
  $MixinUser3 get mixinUser3 {
    if (_mixinUser3 == null) {
      _mixinUser3 = new $MixinUser3();
    }
    return _mixinUser3 as $MixinUser3;
  }

  $Container? _container;
  $Container get container {
    if (_container == null) {
      _container = new $Container();
    }
    return _container as $Container;
  }

  Map<String, MixinUser1>? _instancesOfMixinUser1;
  Map<String, MixinUser1> get instancesOfMixinUser1 {
    if (_instancesOfMixinUser1 != null) return _instancesOfMixinUser1!;
    return _instancesOfMixinUser1 = {
      $om.s[3]: mixinUser1,
      $om.s[4]: mixinUser2,
      $om.s[5]: mixinUser3,
    };
  }

  Map<String, TestMixin1>? _instancesOfTestMixin1;
  Map<String, TestMixin1> get instancesOfTestMixin1 {
    if (_instancesOfTestMixin1 != null) return _instancesOfTestMixin1!;
    return _instancesOfTestMixin1 = {
      $om.s[3]: mixinUser1,
      $om.s[4]: mixinUser2,
      $om.s[5]: mixinUser3,
    };
  }

  Map<String, TestMixin2>? _instancesOfTestMixin2;
  Map<String, TestMixin2> get instancesOfTestMixin2 {
    if (_instancesOfTestMixin2 != null) return _instancesOfTestMixin2!;
    return _instancesOfTestMixin2 = {
      $om.s[4]: mixinUser2,
      $om.s[5]: mixinUser3,
    };
  }

  final List<String> s = const [
    "module_test.Foo",
    "module_test.FooChild",
    "module_test.FooChild2",
    "MixinUser1",
    "MixinUser2",
    "MixinUser3"
  ];
}

$ObjectManager $om = new $ObjectManager();
// generated in 5ms
