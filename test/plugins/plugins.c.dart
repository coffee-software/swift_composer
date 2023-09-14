// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugins.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2023-09-13 20:40:47.315884
// **************************************************************************
// CONFIG
// no config file for root: lib/swift_composer.di.yaml
// config file for foo: test/lib/foo.di.yaml
// config file for bar: test/lib/bar.di.yaml
// no config file for generics: test/lib/generics.di.yaml
// no config file for root: test/plugins/plugins.di.yaml
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
  late SimplePlugin simplePlugin;
  late MoreComplexPlugin moreComplexPlugin;
  $foo_Foo() {
    simplePlugin = new $SimplePlugin(this);
    moreComplexPlugin = new $MoreComplexPlugin(this);
  }
  T plugin<T>() {
    if (T == SimplePlugin) {
      return simplePlugin as T;
    }
    if (T == MoreComplexPlugin) {
      return moreComplexPlugin as T;
    }
    throw new Exception('no plugin for this type');
  }

  String get className => $om.s[0];
  String get stringField => "FooField";
  int get integerField => 124;
//method format override
  String format(String prefix) {
    List<dynamic> args = [prefix];
    args = simplePlugin.beforeFormat(args[0]);
    prefix = args[0];
    var ret = super.format(prefix);
    ret = simplePlugin.afterFormat(ret);
    return ret;
  }
}

// **************************************************************************
class $foo_FooChild extends foo.FooChild implements Pluggable {
  late SimplePlugin simplePlugin;
  late MoreComplexPlugin moreComplexPlugin;
  $foo_FooChild() {
    simplePlugin = new $SimplePlugin(this);
    moreComplexPlugin = new $MoreComplexPlugin(this);
  }
  T plugin<T>() {
    if (T == SimplePlugin) {
      return simplePlugin as T;
    }
    if (T == MoreComplexPlugin) {
      return moreComplexPlugin as T;
    }
    throw new Exception('no plugin for this type');
  }

  double get doubleField => 0.55;
  bool get booleanField => true;
  String get className => $om.s[1];
  String get stringField => "FooChildField";
  int get integerField => 124;
//method format override
  String format(String prefix) {
    List<dynamic> args = [prefix];
    args = simplePlugin.beforeFormat(args[0]);
    prefix = args[0];
    var ret = super.format(prefix);
    ret = simplePlugin.afterFormat(ret);
    return ret;
  }
}

// **************************************************************************
class $foo_FooChild2 extends foo.FooChild2 implements Pluggable {
  late SimplePlugin simplePlugin;
  late MoreComplexPlugin moreComplexPlugin;
  $foo_FooChild2(requiredString) {
    this.requiredString = requiredString;
    simplePlugin = new $SimplePlugin(this);
    moreComplexPlugin = new $MoreComplexPlugin(this);
  }
  T plugin<T>() {
    if (T == SimplePlugin) {
      return simplePlugin as T;
    }
    if (T == MoreComplexPlugin) {
      return moreComplexPlugin as T;
    }
    throw new Exception('no plugin for this type');
  }

  String get className => $om.s[2];
  String get stringField => "FooChild2Field";
  int get integerField => 124;
//method format override
  String format(String prefix) {
    List<dynamic> args = [prefix];
    args = simplePlugin.beforeFormat(args[0]);
    prefix = args[0];
    var ret = super.format(prefix);
    ret = simplePlugin.afterFormat(ret);
    return ret;
  }
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
class $generics_Param extends generics.Param implements Pluggable {
  $generics_Param() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
class $generics_SimpleSpecific extends generics.SimpleSpecific
    implements Pluggable {
  late PluginOnGeneric pluginOnGeneric;
  $generics_SimpleSpecific() {
    pluginOnGeneric = new $PluginOnGeneric(this);
  }
  T plugin<T>() {
    if (T == PluginOnGeneric) {
      return pluginOnGeneric as T;
    }
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
class $SimplePlugin extends SimplePlugin implements Pluggable {
  $SimplePlugin(parent) {
    this.parent = parent;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
class $MoreComplexPlugin extends MoreComplexPlugin implements Pluggable {
  $MoreComplexPlugin(parent) {
    this.parent = parent;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  bar.Bar get barField => $om.bar_Bar;
}

// **************************************************************************
class $PluginOnGeneric extends PluginOnGeneric implements Pluggable {
  $PluginOnGeneric(parent) {
    this.parent = parent;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  bar.Bar get barField => $om.bar_Bar;
}

// **************************************************************************
class $GenericTypedWithFoo extends GenericTypedWithFoo implements Pluggable {
  $GenericTypedWithFoo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  foo.Foo get element => $om.foo_Foo;
  generics.SimpleGeneric<foo.Foo> get generic =>
      $om.generics_SimpleGeneric_foo_Foo_;
}

// **************************************************************************
class $ContainerFoo extends ContainerFoo implements Pluggable {
  $ContainerFoo() {
    this.genericFoo = new $AbstractGeneric_foo_Foo_();
    this.child = new $foo_Foo();
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
//parametrized type
class $generics_SimpleGeneric_generics_Param_
    extends generics.SimpleGeneric<generics.Param> implements Pluggable {
  late PluginOnGeneric pluginOnGeneric;
  $generics_SimpleGeneric_generics_Param_() {
    pluginOnGeneric = new $PluginOnGeneric(this);
  }
  T plugin<T>() {
    if (T == PluginOnGeneric) {
      return pluginOnGeneric as T;
    }
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
//parametrized type
class $AbstractGeneric_foo_Foo_ extends AbstractGeneric<foo.Foo>
    implements Pluggable {
  $AbstractGeneric_foo_Foo_() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

  foo.Foo get element => $om.foo_Foo;
  generics.SimpleGeneric<foo.Foo> get generic =>
      $om.generics_SimpleGeneric_foo_Foo_;
}

// **************************************************************************
//parametrized type
class $generics_SimpleGeneric_foo_Foo_ extends generics.SimpleGeneric<foo.Foo>
    implements Pluggable {
  late PluginOnGeneric pluginOnGeneric;
  $generics_SimpleGeneric_foo_Foo_() {
    pluginOnGeneric = new $PluginOnGeneric(this);
  }
  T plugin<T>() {
    if (T == PluginOnGeneric) {
      return pluginOnGeneric as T;
    }
    throw new Exception('no plugin for this type');
  }
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

  $GenericTypedWithFoo? _genericTypedWithFoo;
  $GenericTypedWithFoo get genericTypedWithFoo {
    if (_genericTypedWithFoo == null) {
      _genericTypedWithFoo = new $GenericTypedWithFoo();
    }
    return _genericTypedWithFoo as $GenericTypedWithFoo;
  }

  $ContainerFoo? _containerFoo;
  $ContainerFoo get containerFoo {
    if (_containerFoo == null) {
      _containerFoo = new $ContainerFoo();
    }
    return _containerFoo as $ContainerFoo;
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

  $AbstractGeneric_foo_Foo_? _abstractGeneric_foo_Foo_;
  $AbstractGeneric_foo_Foo_ get abstractGeneric_foo_Foo_ {
    if (_abstractGeneric_foo_Foo_ == null) {
      _abstractGeneric_foo_Foo_ = new $AbstractGeneric_foo_Foo_();
    }
    return _abstractGeneric_foo_Foo_ as $AbstractGeneric_foo_Foo_;
  }

  $generics_SimpleGeneric_foo_Foo_? _generics_SimpleGeneric_foo_Foo_;
  $generics_SimpleGeneric_foo_Foo_ get generics_SimpleGeneric_foo_Foo_ {
    if (_generics_SimpleGeneric_foo_Foo_ == null) {
      _generics_SimpleGeneric_foo_Foo_ = new $generics_SimpleGeneric_foo_Foo_();
    }
    return _generics_SimpleGeneric_foo_Foo_ as $generics_SimpleGeneric_foo_Foo_;
  }

  final List<String> s = const [
    "foo.Foo",
    "foo.FooChild",
    "foo.FooChild2",
    "bar.BarChild"
  ];
}

$ObjectManager $om = new $ObjectManager();
// generated in 6ms
