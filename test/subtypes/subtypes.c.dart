// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtypes.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2023-02-18 08:36:53.636610
// **************************************************************************
// CONFIG
// no config file for root: /home/fsw/workspace/swift_shop/packages/swift_composer/.dart_tool/..//lib/swift_composer.di.yaml
// config file for module_test1: /home/fsw/workspace/swift_shop/packages/swift_composer/test/subtypes/../lib/foo.di.yaml
// no config file for root: /home/fsw/workspace/swift_shop/packages/swift_composer/test/subtypes/subtypes.di.yaml
// **************************************************************************
// MERGED CONFIG
// module_test1.Foo: {stringField: FooField, integerField: 124}
// module_test1.FooChild: {stringField: FooChildField, doubleField: 0.55, booleanField: true}
// module_test1.FooChild2: {stringField: FooChild2Field, doubleField: 0.55, booleanField: true}
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
// interceptor for [module_test1.Foo]
class $module_test1_Foo extends module_test1.Foo implements Pluggable {
  $module_test1_Foo() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// String className
  String get className => "module_test1.Foo";
// String stringField
  String get stringField => "FooField";
// int integerField
  int get integerField => 124;
}

// **************************************************************************
// interceptor for [module_test1.FooChild]
class $module_test1_FooChild extends module_test1.FooChild
    implements Pluggable {
  $module_test1_FooChild() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// double doubleField
  double get doubleField => 0.55;
// bool booleanField
  bool get booleanField => true;
// String className
  String get className => "module_test1.FooChild";
// String stringField
  String get stringField => "FooChildField";
// int integerField
  int get integerField => 124;
}

// **************************************************************************
// interceptor for [module_test1.FooChild2]
class $module_test1_FooChild2 extends module_test1.FooChild2
    implements Pluggable {
  $module_test1_FooChild2(requiredString) {
//String
    this.requiredString = requiredString;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// String requiredString
// String className
  String get className => "module_test1.FooChild2";
// String stringField
  String get stringField => "FooChild2Field";
// int integerField
  int get integerField => 124;
}

// **************************************************************************
// no interceptor for [AbstractBase]
// **************************************************************************
// interceptor for [SubtypeOfAbstract1]
class $SubtypeOfAbstract1 extends SubtypeOfAbstract1 implements Pluggable {
  $SubtypeOfAbstract1() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
// interceptor for [SubtypeOfAbstract2]
class $SubtypeOfAbstract2 extends SubtypeOfAbstract2 implements Pluggable {
  $SubtypeOfAbstract2() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
// interceptor for [SubtypeOfAbstract3]
class $SubtypeOfAbstract3 extends SubtypeOfAbstract3 implements Pluggable {
  $SubtypeOfAbstract3() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
// interceptor for [Container]
class $Container extends Container implements Pluggable {
  $Container() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

// Map<String,module_test1.Foo> instances
  Map<String, module_test1.Foo> get instances =>
      $om.instancesOfmodule_test1_Foo;
// SubtypesOf<module_test1.Foo> subtypes
  SubtypesOf<module_test1.Foo> get subtypes => $om.subtypesOfmodule_test1_Foo;
// SubtypesOf<AbstractBase> subtypesWithAbstractBase
  SubtypesOf<AbstractBase> get subtypesWithAbstractBase =>
      $om.subtypesOfAbstractBase;
//method factory override
  module_test1.Foo factory(String className) {
    switch (className) {
      case 'module_test1.Foo':
        return new $module_test1_Foo();
      case 'module_test1.FooChild':
        return new $module_test1_FooChild();
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
// no interceptor for [Map<String,module_test1.Foo>]
// **************************************************************************
// no interceptor for [SubtypesOf<module_test1.Foo>]
// **************************************************************************
// no interceptor for [SubtypesOf<AbstractBase>]
// **************************************************************************
class $SubtypesOfmodule_test1_Foo extends SubtypesOf<module_test1.Foo> {
  String getCode<X extends module_test1.Foo>() {
    if (X == module_test1.Foo) return 'module_test1.Foo';
    if (X == module_test1.FooChild) return 'module_test1.FooChild';
    if (X == module_test1.FooChild2) return 'module_test1.FooChild2';
    throw new Exception('no code for type');
  }

  List<String> get allClassNames => [
        'module_test1.Foo',
        'module_test1.FooChild',
        'module_test1.FooChild2',
      ];
  Map<String, String> get baseClassNamesMap => {
        'module_test1.Foo': 'module_test1.Foo',
        'module_test1.FooChild': 'module_test1.Foo',
        'module_test1.FooChild2': 'module_test1.Foo',
      };
}

class $SubtypesOfAbstractBase extends SubtypesOf<AbstractBase> {
  String getCode<X extends AbstractBase>() {
    if (X == SubtypeOfAbstract1) return 'SubtypeOfAbstract1';
    if (X == SubtypeOfAbstract2) return 'SubtypeOfAbstract2';
    if (X == SubtypeOfAbstract3) return 'SubtypeOfAbstract3';
    throw new Exception('no code for type');
  }

  List<String> get allClassNames => [
        'SubtypeOfAbstract1',
        'SubtypeOfAbstract2',
        'SubtypeOfAbstract3',
      ];
  Map<String, String> get baseClassNamesMap => {
        'SubtypeOfAbstract1': 'SubtypeOfAbstract1',
        'SubtypeOfAbstract2': 'SubtypeOfAbstract2',
        'SubtypeOfAbstract3': 'SubtypeOfAbstract2',
      };
}

// **************************************************************************
class $ObjectManager {
  $module_test1_Foo? _module_test1_Foo;
  $module_test1_Foo get module_test1_Foo {
    if (_module_test1_Foo == null) {
      _module_test1_Foo = new $module_test1_Foo();
    }
    return _module_test1_Foo as $module_test1_Foo;
  }

  $module_test1_FooChild? _module_test1_FooChild;
  $module_test1_FooChild get module_test1_FooChild {
    if (_module_test1_FooChild == null) {
      _module_test1_FooChild = new $module_test1_FooChild();
    }
    return _module_test1_FooChild as $module_test1_FooChild;
  }

  $SubtypeOfAbstract1? _subtypeOfAbstract1;
  $SubtypeOfAbstract1 get subtypeOfAbstract1 {
    if (_subtypeOfAbstract1 == null) {
      _subtypeOfAbstract1 = new $SubtypeOfAbstract1();
    }
    return _subtypeOfAbstract1 as $SubtypeOfAbstract1;
  }

  $SubtypeOfAbstract2? _subtypeOfAbstract2;
  $SubtypeOfAbstract2 get subtypeOfAbstract2 {
    if (_subtypeOfAbstract2 == null) {
      _subtypeOfAbstract2 = new $SubtypeOfAbstract2();
    }
    return _subtypeOfAbstract2 as $SubtypeOfAbstract2;
  }

  $SubtypeOfAbstract3? _subtypeOfAbstract3;
  $SubtypeOfAbstract3 get subtypeOfAbstract3 {
    if (_subtypeOfAbstract3 == null) {
      _subtypeOfAbstract3 = new $SubtypeOfAbstract3();
    }
    return _subtypeOfAbstract3 as $SubtypeOfAbstract3;
  }

  $Container? _container;
  $Container get container {
    if (_container == null) {
      _container = new $Container();
    }
    return _container as $Container;
  }

  Map<String, module_test1.Foo>? _instancesOfmodule_test1_Foo;
  Map<String, module_test1.Foo> get instancesOfmodule_test1_Foo {
    if (_instancesOfmodule_test1_Foo != null)
      return _instancesOfmodule_test1_Foo!;
    return _instancesOfmodule_test1_Foo = {
      "module_test1.Foo": module_test1_Foo,
      "module_test1.FooChild": module_test1_FooChild,
//module_test1.FooChild2 requires a param
    };
  }

  SubtypesOf<module_test1.Foo> subtypesOfmodule_test1_Foo =
      new $SubtypesOfmodule_test1_Foo();
  SubtypesOf<AbstractBase> subtypesOfAbstractBase =
      new $SubtypesOfAbstractBase();
}

$ObjectManager $om = new $ObjectManager();
//generated in 14ms
