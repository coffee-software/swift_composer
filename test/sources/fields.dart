import 'package:swift_composer/swift_composer.dart';
import 'module1.dart' as module_test;

part 'fields.c.dart';

class Base {
  @Create
  module_test.Foo one;
  @Create
  module_test.Foo two;
  @Create
  module_test.FooChild three;
  @Create
  module_test.BarChild bar;
}

@Compose
abstract class Container extends Base {

  @Create
  module_test.Foo four;

  Map toJson() {
      Map ret = new Map();
      this.fieldsToJson(ret);
      return ret;
  }

  @Compile
  void fieldsToJson(Map target);


  @CompileFieldsOfType
  void _fieldsToJsonFoo(Map target, String name, module_test.Foo field) {
    target[name] = field.stringField;
  }

  @CompileFieldsOfType
  void _fieldsToJsonBar(Map target, String name, module_test.Bar field) {
    target[name] = field.classNames.join('');
  }


  @Factory
  Container createContainer();

  Container fromJson(Map source) {
    var ret = createContainer();
    ret.copyFieldsFromJson(source);
    return ret;
  }
  @Compile
  void copyFieldsFromJson(Map source);

  @Factory
  module_test.FooChild createFooChild(String requiredString);

  @CompileFieldsOfType
  void _copyFieldsFromJsonFoo(Map source, String name, module_test.Foo field) {
    field = createFooChild(source[name]);
  }

  @CompileFieldsOfType
  void _copyFieldsFromJsonBar(Map source, String name, module_test.Bar field) {
    field = $om.module_test_BarChild;
  }

}

@Compose
abstract class ChildContainer extends Base {

  @Create
  module_test.Foo five;

}
