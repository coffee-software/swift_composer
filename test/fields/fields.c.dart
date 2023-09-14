// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fields.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2023-09-13 20:40:46.905292
// **************************************************************************
// CONFIG
// no config file for root: lib/swift_composer.di.yaml
// config file for foo: test/lib/foo.di.yaml
// config file for bar: test/lib/bar.di.yaml
// no config file for root: test/fields/fields.di.yaml
// **************************************************************************
// MERGED CONFIG
// foo.Foo: {stringField: FooField, integerField: 124}
// foo.FooChild: {stringField: FooChildField, doubleField: 0.55, booleanField: true}
// foo.FooChild2: {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
// bar.Bar: {stringField: BarStringField}
// bar.BarChild: {stringField: BarChildStringField}
// **************************************************************************
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
class $bar_Bar extends bar.Bar implements Pluggable {
  $bar_Bar() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  List<String> get classNames => [];
  String get stringField => "BarStringField";
}

// **************************************************************************
class $bar_BarChild extends bar.BarChild implements Pluggable {
  $bar_BarChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  List<String> get classNames => [$om.s[3]];
  String get stringField => "BarChildStringField";
}

// **************************************************************************
class $Container extends Container implements Pluggable {
  $Container() {
    this.fifth = new $foo_Foo();
    this.one = new $foo_Foo();
    this.two = new $foo_Foo();
    this.three = new $foo_FooChild();
    this.four = new $bar_BarChild();
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

//method fieldsToJson override
  void fieldsToJson(Map<dynamic, dynamic> target) {
//compiled method
//dbg: fieldsToJson
    cfs_fieldsToJsonContainer(this, target);
    cfs_fieldsToJsonBase(this, target);
  }

//method createContainer override
  Container createContainer() {
//Container
    return new $Container();
  }

//method copyFieldsFromJson override
  void copyFieldsFromJson(Map<dynamic, dynamic> source) {
//compiled method
//dbg: copyFieldsFromJson
    cfs_copyFieldsFromJsonContainer(this, source);
    cfs_copyFieldsFromJsonBase(this, source);
  }

//method createFooChild override
  foo.FooChild createFooChild(String requiredString) {
//foo.FooChild
    return new $foo_FooChild();
  }
}

// **************************************************************************
class $ChildContainer extends ChildContainer implements Pluggable {
  $ChildContainer() {
    this.six = new $foo_Foo();
    this.fifth = new $foo_Foo();
    this.one = new $foo_Foo();
    this.two = new $foo_Foo();
    this.three = new $foo_FooChild();
    this.four = new $bar_BarChild();
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

//method fieldsToJson override
  void fieldsToJson(Map<dynamic, dynamic> target) {
//compiled method
    cfs_fieldsToJsonChildContainer(this, target);
    cfs_fieldsToJsonContainer(this, target);
    cfs_fieldsToJsonBase(this, target);
  }

//method createContainer override
  Container createContainer() {
//Container
    return new $Container();
  }

//method copyFieldsFromJson override
  void copyFieldsFromJson(Map<dynamic, dynamic> source) {
//compiled method
    cfs_copyFieldsFromJsonChildContainer(this, source);
    cfs_copyFieldsFromJsonContainer(this, source);
    cfs_copyFieldsFromJsonBase(this, source);
  }

//method createFooChild override
  foo.FooChild createFooChild(String requiredString) {
//foo.FooChild
    return new $foo_FooChild();
  }
}

// **************************************************************************
// **************************************************************************
void cfs_fieldsToJsonContainer(Container dis, Map<dynamic, dynamic> target) {
  {
    const name = "fifth";
    const className = "foo.Foo";
    const boolParam = false;
    const intParam_value = 1;
    const stringParam_value = 'test1';
    const complexParam_value1 = 2;
    const complexParam_value2 = 'test2';
    target[name] = {
      'name': name,
      'className': className,
      'boolParam': boolParam,
      'intParam_value': intParam_value,
      'stringParam_value': stringParam_value,
      'complexParam_value1': complexParam_value1,
      'complexParam_value2': complexParam_value2,
      'value.stringField': dis.fifth.stringField
    };
  }
}

void cfs_fieldsToJsonBase(Base dis, Map<dynamic, dynamic> target) {
  {
    const name = "one";
    const className = "foo.Foo";
    const boolParam = false;
    const intParam_value = 1;
    const stringParam_value = 'test1';
    const complexParam_value1 = 2;
    const complexParam_value2 = 'test2';
    target[name] = {
      'name': name,
      'className': className,
      'boolParam': boolParam,
      'intParam_value': intParam_value,
      'stringParam_value': stringParam_value,
      'complexParam_value1': complexParam_value1,
      'complexParam_value2': complexParam_value2,
      'value.stringField': dis.one.stringField
    };
  }
  {
    const name = "two";
    const className = "foo.Foo";
    const boolParam = false;
    const intParam_value = 1;
    const stringParam_value = 'test1';
    const complexParam_value1 = 2;
    const complexParam_value2 = 'test2';
    target[name] = {
      'name': name,
      'className': className,
      'boolParam': boolParam,
      'intParam_value': intParam_value,
      'stringParam_value': stringParam_value,
      'complexParam_value1': complexParam_value1,
      'complexParam_value2': complexParam_value2,
      'value.stringField': dis.two.stringField
    };
  }
  {
    const name = "three";
    const className = "foo.FooChild";
    const boolParam = false;
    const intParam_value = 1;
    const stringParam_value = 'test1';
    const complexParam_value1 = 2;
    const complexParam_value2 = 'test2';
    target[name] = {
      'name': name,
      'className': className,
      'boolParam': boolParam,
      'intParam_value': intParam_value,
      'stringParam_value': stringParam_value,
      'complexParam_value1': complexParam_value1,
      'complexParam_value2': complexParam_value2,
      'value.stringField': dis.three.stringField
    };
  }
  {
    const name = "four";
    target[name] = dis.four.classNames.join('');
  }
}

void cfs_fieldsToJsonChildContainer(
    ChildContainer dis, Map<dynamic, dynamic> target) {
  {
    const name = "six";
    const className = "foo.Foo";
    const boolParam = true;
    const intParam_value = 3;
    const stringParam_value = "test";
    const complexParam_value1 = 5;
    const complexParam_value2 = "something";
    target[name] = {
      'name': name,
      'className': className,
      'boolParam': boolParam,
      'intParam_value': intParam_value,
      'stringParam_value': stringParam_value,
      'complexParam_value1': complexParam_value1,
      'complexParam_value2': complexParam_value2,
      'value.stringField': dis.six.stringField
    };
  }
}

void cfs_copyFieldsFromJsonContainer(
    Container dis, Map<dynamic, dynamic> source) {
  {
    const name = "fifth";
    dis.fifth = dis.createFooChild(source[name]);
  }
}

void cfs_copyFieldsFromJsonBase(Base dis, Map<dynamic, dynamic> source) {
  {
    const name = "one";
    dis.one = dis.createFooChild(source[name]);
  }
  {
    const name = "two";
    dis.two = dis.createFooChild(source[name]);
  }
  {
    const name = "three";
    dis.three = dis.createFooChild(source[name]);
  }
  {
    const name = "four";
    dis.four = $om.bar_BarChild;
  }
}

void cfs_copyFieldsFromJsonChildContainer(
    ChildContainer dis, Map<dynamic, dynamic> source) {
  {
    const name = "six";
    dis.six = dis.createFooChild(source[name]);
  }
}

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

  $bar_Bar? _bar_Bar;
  $bar_Bar get bar_Bar {
    if (_bar_Bar == null) {
      _bar_Bar = new $bar_Bar();
    }
    return _bar_Bar as $bar_Bar;
  }

  $bar_BarChild? _bar_BarChild;
  $bar_BarChild get bar_BarChild {
    if (_bar_BarChild == null) {
      _bar_BarChild = new $bar_BarChild();
    }
    return _bar_BarChild as $bar_BarChild;
  }

  $Container? _container;
  $Container get container {
    if (_container == null) {
      _container = new $Container();
    }
    return _container as $Container;
  }

  $ChildContainer? _childContainer;
  $ChildContainer get childContainer {
    if (_childContainer == null) {
      _childContainer = new $ChildContainer();
    }
    return _childContainer as $ChildContainer;
  }

  final List<String> s = const [
    "foo.Foo",
    "foo.FooChild",
    "foo.FooChild2",
    "bar.BarChild"
  ];
}

$ObjectManager $om = new $ObjectManager();
// generated in 276ms
