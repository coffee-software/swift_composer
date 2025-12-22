import 'package:swift_composer/swift_composer.dart';
// ignore: avoid_relative_lib_imports
import '../lib/foo.dart' as module_test;

part 'mixins.c.dart';

// ignore: constant_identifier_names
const FieldAnnotation = true;

@ComposeSubtypes
mixin TestMixin1 {
  @FieldAnnotation
  String mixin1Field = '';
}

@ComposeSubtypes
mixin TestMixin2 {
  @FieldAnnotation
  String mixin2Field = '';

  @Factory
  module_test.Foo createFoo();
}

@Compose
abstract class MixinUser1 with TestMixin1 {
  @FieldAnnotation
  String ownField1 = '';

  @Compile
  void fieldsToJson(Map target);

  @CompileFieldsOfType
  @AnnotatedWith(FieldAnnotation)
  // ignore: unused_element
  void _fieldsToJsonString(Map target, String name, String field) {
    target[name] = field;
  }
}

@Compose
abstract class MixinUser2 extends MixinUser1 with TestMixin2 {
  @FieldAnnotation
  String ownField2 = '';
}

@ComposeSubtypes
mixin TestMixin3 {
  // override field test
  // ignore: non_constant_identifier_names
  String get override_mixin1Field => 'overriden';
}

@Compose
abstract class MixinUser3 extends MixinUser1 with TestMixin2, TestMixin3 {}

@Compose
abstract class Container {
  @InjectInstances
  Map<String, MixinUser1> get instancesOfMixinUser1;

  @InjectInstances
  Map<String, TestMixin1> get instancesOfTestMixin1;

  @InjectInstances
  Map<String, TestMixin2> get instancesOfTestMixin2;
}
