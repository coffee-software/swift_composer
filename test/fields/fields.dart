import 'package:swift_composer/swift_composer.dart';
// ignore: avoid_relative_lib_imports
import '../lib/foo.dart' as foo;
// ignore: avoid_relative_lib_imports
import '../lib/bar.dart' as bar;

part 'fields.c.dart';

abstract class Base {
  @Create
  late foo.Foo one;
  @Create
  late foo.Foo two;
  @Create
  late foo.FooChild three;
  @Create
  late bar.BarChild four;

  @Compile
  void copyFieldsFromJson(Map source);

  @Factory
  foo.FooChild createFooChild(String requiredString);

  @CompileFieldsOfType
  // ignore: unused_element
  void _copyFieldsFromJsonFoo(Map source, String name, foo.Foo field) {
    // ignore: unnecessary_this
    field = this.createFooChild(source[name]);
  }

  @CompileFieldsOfType
  // ignore: unused_element
  void _copyFieldsFromJsonBar(Map source, String name, bar.Bar field) {
    field = $om.bar_BarChild;
  }
}

@Compose
abstract class Container extends Base {
  @Create
  late foo.Foo fifth;

  Map toJson() {
    Map ret = {};
    fieldsToJson(ret);
    return ret;
  }

  @Compile
  void fieldsToJson(Map target);

  @CompileFieldsOfType
  // ignore: unused_element
  void _fieldsToJsonFoo(
    Map target,
    String name,
    String className,
    foo.Foo field, {
    bool boolParam = false,
    // ignore: non_constant_identifier_names
    int intParam_value = 1,
    // ignore: non_constant_identifier_names
    String stringParam_value = 'test1',
    // ignore: non_constant_identifier_names
    int complexParam_value1 = 2,
    // ignore: non_constant_identifier_names
    String complexParam_value2 = 'test2',
  }) {
    target[name] = {
      'name': name,
      'className': className,
      'boolParam': boolParam,
      'intParam_value': intParam_value,
      'stringParam_value': stringParam_value,
      'complexParam_value1': complexParam_value1,
      'complexParam_value2': complexParam_value2,
      'value.stringField': field.stringField,
    };
  }

  @CompileFieldsOfType
  // ignore: unused_element
  void _fieldsToJsonBar(Map target, String name, bar.Bar field) {
    target[name] = field.classNames.join('');
  }

  @Factory
  Container createContainer();

  Container fromJson(Map source) {
    var ret = createContainer();
    ret.copyFieldsFromJson(source);
    return ret;
  }
}

// ignore: constant_identifier_names
const BoolParam = true;

class IntParam {
  final int value;
  const IntParam(this.value);
}

class StringParam {
  final String value;
  const StringParam(this.value);
}

class ComplexParam {
  final int value1;
  final String value2;
  const ComplexParam(this.value1, this.value2);
}

@Compose
abstract class ChildContainer extends Container {
  @Create
  @BoolParam
  @IntParam(3)
  @StringParam('test')
  @ComplexParam(5, 'something')
  late foo.Foo six;
}
