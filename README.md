# swift_composer

```diff
- warning: this module is experimental and under development. It's API is subjected to change
```

Swift Composer aims to turn dart modules into plugable application parts.

It uses source_gen to generate final application logic depending on imported
modules and configuration hence no boilerplate code is created.

This module powers 'swift.shop' app engine.
It is used to generate plugable client and server side routing, auto-serializable data models,
configurable layouts and widgets system and more.

## Installation

1) add `swift_composer` to your dependencies in `pubspec.yaml`:
```
dependencies:
  swift_composer: any
```

2) declare a compiled part in your final application code:
```
import 'package:swift_composer/swift_composer.dart';

import 'package:some_plugin';

part 'main.c.dart';

void main() {
  $om.some_compiled_entrypoint.run();
}
```

3) build `.c.dart` part
```
pub run build_runner build
```

If you are creating a web package the build will be executed automatically with
`webdev serve/build`.

## Features

### Requirements

For any class to use swift composer features it needs to be declared as abstract
and decorated with `@Compose` annotation. This allows code generator to generate
a final class with compiled methods, plugins and dependency injections.

```
@Compose
abstract class Foo {

}
```

### Class Names

```
@Compose
abstract class Foo {

  @InjectClassName
  String get className;

  @InjectClassNames
  List<String> get classNames;

}
```
All instances of `Test` and its subtypes will have `className` field populated
with this class full name and `classNames` populated with full class hierarchy
path.

Above is useful for serialization as this field will contain source class name
even after compilation to `*.js` etc.

### Dependency Injection

```
@Compose
abstract class Bar {

  @Require
  String barRequiredField;

}

@Compose
abstract class Test {

  @Inject
  Foo get injectedFoo;

  @Factory
  Foo createFoo();

  @Factory
  Bar createBar(String barRequiredField);

}
```

Methods decorated with `Factory` will create a compiled subtype of return type.
Exact type returned will defined by imported modules and DI configuration.
For classes without any dependencies required for creation you can use `Inject`
annotation to generate shared instance.

#### Finding Class Subtypes

```
@Compose
abstract class Test {

@InjectInstances
Map<String, Foo> get instances;

@SubtypeFactory
Foo createFoo(String className);

}
```
Method decorated with `SubtypeFactory` will return a subtype of `Foo` depending
on passed `className` parameter.
A getter decorated with `InjectInstances` will contain a map indexed with class
names of all requirements free subtypes of `Foo`.

### Class Fields info and Compiled methods.

Swift Composer adds tools to generate info of final class fields that can be
used for example to generate JSON serialization.

```
const JsonField = true;

@Compose
abstract class TestSerializable {

  @InjectClassName
  String get className;

  @JsonField
  String foo;

  @JsonField
  String bar;

  Map toJson() {
      Map ret = new Map();
      ret['className'] = className;
      this.fieldsToJson(ret);
      return ret;
  }

  @Compile
  void fieldsToJson(Map target);

  @CompileFieldsOfType
  @AnnotatedWith(JsonField)
  void _fieldsToJsonString(Map target, String name, String field) {
    target[name] = field;
  }

  @CompileFieldsOfType
  @AnnotatedWith(JsonField)
  void _fieldsToJsonInt(Map target, String name, int field) {
    target[name] = field;
  }

}
```

In above example, all subtypes of `TestSerializable` will have `toJson` that
will return all fields decorated with `@JsonField` serialized.
Dart tree shaking algorithms will clear compiled code out of unused stubs.

### Type Plugins

Type plugins can modify objects data and behavior.
Fields compilation method works with plugins and will also compile plugin fields
so we can add a plugin for `TestSerializable` from previous example.
```
abstract class TestPlugin extends TypePlugin<TestSerializable> {

  @Field
  String extraField = 'test';

}
```

Now, calling `toJson` should return something like:
```
{
  'className' : 'TestSerializable',
  'foo' : 'something',
  'bar' : 10,
  'testPlugin.extraField': 'test'
}
```

We can also extend / change decorated classes behaviors using `MethodPlugin` annotations.

Every public method in parent class:
```
  bool validate(int foo, int bar) {
    return foo > bar;
  }
```

Plugin class can customize behavior of such methods:
```
  @MethodPlugin
  List<dynamic> beforeValidate(int foo, int bar) {
    bar = bar + 1;
    return [foo, bar];
  }

  @MethodPlugin
  bool afterValidate(bool ret) {
    return !ret;
  }
```

## Development Info

Running tests:

```
pub run build_runner build && dart test/swift_composer_test.dart
```
