// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtypes.dart';

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
  $module_test1_Foo() {}
  T plugin<T>() {}
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
  $module_test1_FooChild() {}
  T plugin<T>() {}
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
  $module_test1_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {}
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

//interceptor for [Container]
//interceptor for Container
//can be singleton: TRUE
//parent: Container [@bool get Compose]
class $Container extends Container {
  $Container() {}
  T plugin<T>() {}
  Map<String, module_test1.Foo> get instances =>
      $om.instancesOfmodule_test1_Foo;
  module_test1.Foo factory(String classCode) {
    switch (classCode) {
      case 'module_test1.Foo':
        return new $module_test1_Foo();
      case 'module_test1.FooChild':
        return new $module_test1_FooChild();
    }
  }
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

  $Container _container;
  $Container get container {
    if (_container == null) {
      _container = new $Container();
    }
    return _container;
  }

  Map<String, module_test1.Foo> get instancesOfmodule_test1_Foo {
    return {
      "module_test1.Foo": new $module_test1_Foo(),
      "module_test1.FooChild": new $module_test1_FooChild(),
    };
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 3ms
