import 'package:swift_composer/swift_composer.dart';
import '../lib/foo.dart' as foo;
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
  void _copyFieldsFromJsonFoo(Map source, String name, foo.Foo field) {
    field = this.createFooChild(source[name]);
  }

  @CompileFieldsOfType
  void _copyFieldsFromJsonBar(Map source, String name, bar.Bar field) {
    field = $om.bar_BarChild;
  }
}

@Compose
abstract class Container extends Base {

  @Create
  late foo.Foo fifth;

  Map toJson() {
      Map ret = new Map();
      this.fieldsToJson(ret);
      return ret;
  }

  @Compile
  void fieldsToJson(Map target);


  @CompileFieldsOfType
  void _fieldsToJsonFoo(
      Map target,
      String name,
      String className,
      foo.Foo field,
      {
        bool boolParam = false,
        int intParam_value = 1,
        String stringParam_value = 'test1',
        int complexParam_value1 = 2,
        String complexParam_value2 = 'test2',
      }
  ) {
    target[name] = {
      'name' : name,
      'className' : className,
      'boolParam' : boolParam,
      'intParam_value' : intParam_value,
      'stringParam_value' : stringParam_value,
      'complexParam_value1' : complexParam_value1,
      'complexParam_value2' : complexParam_value2,
      'value.stringField' : field.stringField
    };
  }

  @CompileFieldsOfType
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
