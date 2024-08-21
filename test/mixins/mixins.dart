import 'package:swift_composer/swift_composer.dart';

part 'mixins.c.dart';

const FieldAnnotation = true;

@ComposeSubtypes
abstract class TestMixin1 {

  @FieldAnnotation
  String mixin1Field = '';

}

@ComposeSubtypes
mixin TestMixin2 {

  @FieldAnnotation
  String mixin2Field = '';

}

@Compose
abstract class MixinUser1 with TestMixin1 {


  @FieldAnnotation
  String ownField1 = '';

  @Compile
  void fieldsToJson(Map target);
  
  @CompileFieldsOfType
  @AnnotatedWith(FieldAnnotation)
  void _fieldsToJsonString(
      Map target,
      String name,
      String field
      ) {

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


  //override field test
  String get override_mixin1Field => 'overriden';

}

@Compose
abstract class MixinUser3 extends MixinUser1 with TestMixin2, TestMixin3 {
}

@Compose
abstract class Container {

  @InjectInstances
  Map<String, MixinUser1> get instancesOfMixinUser1;

  @InjectInstances
  Map<String, TestMixin1> get instancesOfTestMixin1;

  @InjectInstances
  Map<String, TestMixin2> get instancesOfTestMixin2;

}