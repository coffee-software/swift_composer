// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compose.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

//no interceptor for [AnnotatedWith]
//no interceptor for [Pluggable]
//no interceptor for [TypePlugin]
//interceptor for [m1.Foo]
//interceptor for m1.Foo
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
class $m1_Foo extends m1.Foo {
  $m1_Foo() {}
  T plugin<T>() {}
  String get className => "m1.Foo";
  String get stringField => "FooField";
  int get integerField => 124;
}

//interceptor for [m1.FooChild]
//interceptor for m1.FooChild
//can be singleton: TRUE
//parent: FooChild [@bool get Compose]
//parent: Foo [@bool get Compose]
class $m1_FooChild extends m1.FooChild {
  $m1_FooChild() {}
  T plugin<T>() {}
  String get className => "m1.FooChild";
  String get stringField => "FooChildField";
  int get integerField => 124;
  double get doubleField => 0.55;
  bool get booleanField => true;
}

//interceptor for [m1.FooChild2]
//interceptor for m1.FooChild2
//can be singleton: FALSE
//parent: FooChild2 [@bool get Compose]
//parent: Foo [@bool get Compose]
class $m1_FooChild2 extends m1.FooChild2 {
  $m1_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {}
  String get className => "m1.FooChild2";
  String get stringField => "FooChild2Field";
  int get integerField => 124;
}

//interceptor for [m1.Bar]
//interceptor for m1.Bar
//can be singleton: TRUE
//parent: Bar [@bool get Compose]
class $m1_Bar extends m1.Bar {
  $m1_Bar() {}
  T plugin<T>() {}
  String get stringField => "BarField";
  List<String> get classNames => [];
}

//interceptor for [m1.BarChild]
//interceptor for m1.BarChild
//can be singleton: TRUE
//parent: BarChild [@bool get Compose]
//parent: Bar [@bool get Compose]
class $m1_BarChild extends m1.BarChild {
  $m1_BarChild() {}
  T plugin<T>() {}
  String get stringField => "BarChildField";
  List<String> get classNames => ['m1.BarChild'];
}

//interceptor for [m1.SimpleGeneric]
//interceptor for m1.SimpleGeneric
//can be singleton: FALSE
//parent: SimpleGeneric [@bool get Compose]
class $m1_SimpleGeneric<T> extends m1.SimpleGeneric<T> {
  $m1_SimpleGeneric() {}
  T plugin<T>() {}
}

//interceptor for [Foo]
//interceptor for Foo
//can be singleton: TRUE
//parent: Foo [@bool get Compose]
class $Foo extends Foo {
  $Foo() {}
  T plugin<T>() {}
  String get className => "Foo";
  String get stringField2 => null;
}

//interceptor for [ComplexGeneric]
//interceptor for ComplexGeneric
//can be singleton: FALSE
//parent: ComplexGeneric [@bool get Compose]
class $ComplexGeneric<A, B> extends ComplexGeneric<A, B> {
  $ComplexGeneric() {}
  T plugin<T>() {}
}

//interceptor for [SuperComplexGeneric]
//interceptor for SuperComplexGeneric
//A[427294693] => Foo[385541647]
//B[463434057] => A[148323164]
//can be singleton: FALSE
//parent: SuperComplexGeneric [@bool get Compose]
//parent: ComplexGeneric [@bool get Compose]
class $SuperComplexGeneric<A, B> extends SuperComplexGeneric<A, B> {
  $SuperComplexGeneric() {}
  T plugin<T>() {}
}

//interceptor for [Container]
//interceptor for Container
//can be singleton: FALSE
//parent: Container [@bool get Compose]
class $Container extends Container {
  $Container(fooRequired, genericRequired) {
//SimpleGeneric<Foo>
//Foo
//create
    this.fooCreated = new $m1_Foo();
//SimpleGeneric<Foo>
//create
//Foo
    this.fooRequired = fooRequired;
//SimpleGeneric<Foo>
    this.genericRequired = genericRequired;
  }
  T plugin<T>() {}
  m1.Foo get fooInjected => $om.m1_Foo;
}

//no interceptor for [AbstractGeneric]
//no interceptor for [GenericInterface]
//interceptor for [GenericTypedWithFoo]
//interceptor for GenericTypedWithFoo
//T[120721399] => Foo[180531561]
//K[180407364] => Foo[180531561]
//can be singleton: TRUE
//parent: GenericTypedWithFoo [@bool get Compose]
//parent: AbstractGeneric []
//parent: GenericInterface []
class $GenericTypedWithFoo extends GenericTypedWithFoo {
  $GenericTypedWithFoo() {
//SimpleGeneric<T>
  }
  T plugin<T>() {}
  m1.Foo get element => $om.m1_Foo;
}

//no interceptor for [GenericContainer]
//interceptor for [ContainerFoo]
//interceptor for ContainerFoo
//T[380102938] => Foo[180531561]
//can be singleton: TRUE
//parent: ContainerFoo [@bool get Compose]
//parent: GenericContainer []
class $ContainerFoo extends ContainerFoo {
  $ContainerFoo() {
//AbstractGeneric<T>
//create
    this.genericfoo = new $GenericTypedWithFoo();
//GenericInterface<T>
//create
    this.genericinterface = new $GenericTypedWithFoo();
//T
//create
    this.child = new $m1_Foo();
  }
  T plugin<T>() {}
}

class $ObjectManager {
  $m1_Foo _m1_Foo;
  $m1_Foo get m1_Foo {
    if (_m1_Foo == null) {
      _m1_Foo = new $m1_Foo();
    }
    return _m1_Foo;
  }

  $m1_FooChild _m1_FooChild;
  $m1_FooChild get m1_FooChild {
    if (_m1_FooChild == null) {
      _m1_FooChild = new $m1_FooChild();
    }
    return _m1_FooChild;
  }

  $m1_Bar _m1_Bar;
  $m1_Bar get m1_Bar {
    if (_m1_Bar == null) {
      _m1_Bar = new $m1_Bar();
    }
    return _m1_Bar;
  }

  $m1_BarChild _m1_BarChild;
  $m1_BarChild get m1_BarChild {
    if (_m1_BarChild == null) {
      _m1_BarChild = new $m1_BarChild();
    }
    return _m1_BarChild;
  }

  $Foo _foo;
  $Foo get foo {
    if (_foo == null) {
      _foo = new $Foo();
    }
    return _foo;
  }

  $GenericTypedWithFoo _genericTypedWithFoo;
  $GenericTypedWithFoo get genericTypedWithFoo {
    if (_genericTypedWithFoo == null) {
      _genericTypedWithFoo = new $GenericTypedWithFoo();
    }
    return _genericTypedWithFoo;
  }

  $ContainerFoo _containerFoo;
  $ContainerFoo get containerFoo {
    if (_containerFoo == null) {
      _containerFoo = new $ContainerFoo();
    }
    return _containerFoo;
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 10ms
