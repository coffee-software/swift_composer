// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fields.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

//no interceptor for [AnnotatedWith]
//no interceptor for [Pluggable]
//no interceptor for [TypePlugin]
//interceptor for [module_test.Foo]
//interceptor for module_test.Foo
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
class $module_test_Foo extends module_test.Foo {
  $module_test_Foo() {}
  T plugin<T>() {}
  String get className => "module_test.Foo";
  String get stringField => "FooField";
  int get integerField => 124;
}

//interceptor for [module_test.FooChild]
//interceptor for module_test.FooChild
//can be singleton: TRUE
//parent: FooChild [@bool get Compose]
//parent: Foo [@bool get Compose]
class $module_test_FooChild extends module_test.FooChild {
  $module_test_FooChild() {}
  T plugin<T>() {}
  String get className => "module_test.FooChild";
  String get stringField => "FooChildField";
  int get integerField => 124;
  double get doubleField => 0.55;
  bool get booleanField => true;
}

//interceptor for [module_test.FooChild2]
//interceptor for module_test.FooChild2
//can be singleton: FALSE
//parent: FooChild2 [@bool get Compose]
//parent: Foo [@bool get Compose]
class $module_test_FooChild2 extends module_test.FooChild2 {
  $module_test_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {}
  String get className => "module_test.FooChild2";
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

//interceptor for [module_test.Bar]
//interceptor for module_test.Bar
//can be singleton: TRUE
//parent: Bar [@bool get Compose]
class $module_test_Bar extends module_test.Bar {
  $module_test_Bar() {}
  T plugin<T>() {}
  String get stringField => "BarField";
  List<String> get classNames => [];
}

//interceptor for [module_test.BarChild]
//interceptor for module_test.BarChild
//can be singleton: TRUE
//parent: BarChild [@bool get Compose]
//parent: Bar [@bool get Compose]
class $module_test_BarChild extends module_test.BarChild {
  $module_test_BarChild() {}
  T plugin<T>() {}
  String get stringField => "BarChildField";
  List<String> get classNames => ['module_test.BarChild'];
}

//interceptor for [module_test.SimpleGeneric]
//interceptor for module_test.SimpleGeneric
//can be singleton: FALSE
//parent: SimpleGeneric [@bool get Compose]
class $module_test_SimpleGeneric<T> extends module_test.SimpleGeneric<T> {
  $module_test_SimpleGeneric() {}
  T plugin<T>() {}
}

//no interceptor for [Base]
//interceptor for [Container]
//interceptor for Container
//can be singleton: TRUE
//parent: Container [@bool get Compose]
//parent: Base []
class $Container extends Container {
  $Container() {
//Foo
//create
    this.one = new $module_test_Foo();
//Foo
//create
    this.two = new $module_test_Foo();
//FooChild
//create
    this.three = new $module_test_FooChild();
//BarChild
//create
    this.bar = new $module_test_BarChild();
//Foo
//create
    this.four = new $module_test_Foo();
  }
  T plugin<T>() {}
  void fieldsToJson(Map target) {
    {
      target['one'] = this.one.stringField;
    }
    {
      target['two'] = this.two.stringField;
    }
    {
      target['three'] = this.three.stringField;
    }
    {
      target['four'] = this.four.stringField;
    }
    {
      target['bar'] = this.bar.classNames.join('');
    }
  }

  Container createContainer() {
//Container
    return new $Container();
  }

  void copyFieldsFromJson(Map source) {
    {
      this.one = createFooChild(source['one']);
    }
    {
      this.two = createFooChild(source['two']);
    }
    {
      this.three = createFooChild(source['three']);
    }
    {
      this.four = createFooChild(source['four']);
    }
    {
      this.bar = $om.module_test_BarChild;
    }
  }

  module_test.FooChild createFooChild(String requiredString) {
//module_test.FooChild
    return new $module_test_FooChild();
  }
}

//interceptor for [ChildContainer]
//interceptor for ChildContainer
//can be singleton: TRUE
//parent: ChildContainer [@bool get Compose]
//parent: Base []
class $ChildContainer extends ChildContainer {
  $ChildContainer() {
//Foo
//create
    this.one = new $module_test_Foo();
//Foo
//create
    this.two = new $module_test_Foo();
//FooChild
//create
    this.three = new $module_test_FooChild();
//BarChild
//create
    this.bar = new $module_test_BarChild();
//Foo
//create
    this.five = new $module_test_Foo();
  }
  T plugin<T>() {}
}

class $ObjectManager {
  $module_test_Foo _module_test_Foo;
  $module_test_Foo get module_test_Foo {
    if (_module_test_Foo == null) {
      _module_test_Foo = new $module_test_Foo();
    }
    return _module_test_Foo;
  }

  $module_test_FooChild _module_test_FooChild;
  $module_test_FooChild get module_test_FooChild {
    if (_module_test_FooChild == null) {
      _module_test_FooChild = new $module_test_FooChild();
    }
    return _module_test_FooChild;
  }

  $module_test_Bar _module_test_Bar;
  $module_test_Bar get module_test_Bar {
    if (_module_test_Bar == null) {
      _module_test_Bar = new $module_test_Bar();
    }
    return _module_test_Bar;
  }

  $module_test_BarChild _module_test_BarChild;
  $module_test_BarChild get module_test_BarChild {
    if (_module_test_BarChild == null) {
      _module_test_BarChild = new $module_test_BarChild();
    }
    return _module_test_BarChild;
  }

  $Container _container;
  $Container get container {
    if (_container == null) {
      _container = new $Container();
    }
    return _container;
  }

  $ChildContainer _childContainer;
  $ChildContainer get childContainer {
    if (_childContainer == null) {
      _childContainer = new $ChildContainer();
    }
    return _childContainer;
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 21ms
