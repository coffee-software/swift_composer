// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugins.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

//no interceptor for [AnnotatedWith]
//no interceptor for [TypePlugin]
//interceptor for [module_test1.Foo]
//interceptor for module_test1.Foo
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
class $module_test1_Foo extends module_test1.Foo {
  SimplePlugin simplePlugin;
  MoreComplexPlugin moreComplexPlugin;
  $module_test1_Foo() {
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
  }

  String get className => "module_test1.Foo";
  String get stringField => "FooField";
  int get integerField => 124;
}

//interceptor for [module_test1.FooChild]
//interceptor for module_test1.FooChild
//can be singleton: TRUE
//parent: FooChild [@bool get Compose]
//parent: Foo [@bool get Compose]
class $module_test1_FooChild extends module_test1.FooChild {
  SimplePlugin simplePlugin;
  MoreComplexPlugin moreComplexPlugin;
  $module_test1_FooChild() {
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
  }

  String get className => "module_test1.FooChild";
  String get stringField => "FooChildField";
  int get integerField => 124;
  double get doubleField => 0.55;
  bool get booleanField => true;
}

//interceptor for [module_test1.FooChild2]
//interceptor for module_test1.FooChild2
//can be singleton: FALSE
//parent: FooChild2 [@bool get Compose]
//parent: Foo [@bool get Compose]
class $module_test1_FooChild2 extends module_test1.FooChild2 {
  SimplePlugin simplePlugin;
  MoreComplexPlugin moreComplexPlugin;
  $module_test1_FooChild2(requiredString) {
//String
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
  }

  String get className => "module_test1.FooChild2";
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

//interceptor for [module_test1.Bar]
//interceptor for module_test1.Bar
//can be singleton: TRUE
//parent: Bar [@bool get Compose]
class $module_test1_Bar extends module_test1.Bar {
  $module_test1_Bar() {}
  T plugin<T>() {}
  String get stringField => "BarField";
  List<String> get classNames => [];
}

//interceptor for [module_test1.BarChild]
//interceptor for module_test1.BarChild
//can be singleton: TRUE
//parent: BarChild [@bool get Compose]
//parent: Bar [@bool get Compose]
class $module_test1_BarChild extends module_test1.BarChild {
  $module_test1_BarChild() {}
  T plugin<T>() {}
  String get stringField => "BarChildField";
  List<String> get classNames => ['module_test1.BarChild'];
}

//interceptor for [module_test1.SimpleGeneric]
//interceptor for module_test1.SimpleGeneric
//can be singleton: FALSE
//parent: SimpleGeneric [@bool get Compose]
class $module_test1_SimpleGeneric<T> extends module_test1.SimpleGeneric<T> {
  $module_test1_SimpleGeneric() {}
  T plugin<T>() {}
}

//interceptor for [SimplePlugin]
//interceptor for SimplePlugin
//T[362979300] => Foo[180531561]
//can be singleton: FALSE
//parent: SimplePlugin [@bool get Compose]
//parent: TypePlugin [@bool get ComposeSubtypes]
class $SimplePlugin extends SimplePlugin {
  $SimplePlugin(parent) {
//T
    this.parent = parent;
  }
  T plugin<T>() {}
}

//interceptor for [MoreComplexPlugin]
//interceptor for MoreComplexPlugin
//T[362979300] => Foo[180531561]
//can be singleton: FALSE
//parent: MoreComplexPlugin [@bool get Compose]
//parent: TypePlugin [@bool get ComposeSubtypes]
class $MoreComplexPlugin extends MoreComplexPlugin {
  $MoreComplexPlugin(parent) {
//T
    this.parent = parent;
  }
  T plugin<T>() {}
  module_test1.Bar get bar => $om.module_test1_Bar;
}

class $ObjectManager {
  $module_test1_Foo _module_test1_Foo;
  $module_test1_Foo get module_test1_Foo {
    if (_module_test1_Foo == null) {
      _module_test1_Foo = new $module_test1_Foo();
    }
    return _module_test1_Foo;
  }

  $module_test1_FooChild _module_test1_FooChild;
  $module_test1_FooChild get module_test1_FooChild {
    if (_module_test1_FooChild == null) {
      _module_test1_FooChild = new $module_test1_FooChild();
    }
    return _module_test1_FooChild;
  }

  $module_test1_Bar _module_test1_Bar;
  $module_test1_Bar get module_test1_Bar {
    if (_module_test1_Bar == null) {
      _module_test1_Bar = new $module_test1_Bar();
    }
    return _module_test1_Bar;
  }

  $module_test1_BarChild _module_test1_BarChild;
  $module_test1_BarChild get module_test1_BarChild {
    if (_module_test1_BarChild == null) {
      _module_test1_BarChild = new $module_test1_BarChild();
    }
    return _module_test1_BarChild;
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 2ms
