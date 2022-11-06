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
  void _fieldsToJsonFoo(Map target, String name, foo.Foo field) {
    target[name] = field.stringField;
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
  @Compile
  void copyFieldsFromJson(Map source);

  @Factory
  foo.FooChild createFooChild(String requiredString);

  @CompileFieldsOfType
  void _copyFieldsFromJsonFoo(Map source, String name, foo.Foo field) {
    field = createFooChild(source[name]);
  }

  @CompileFieldsOfType
  void _copyFieldsFromJsonBar(Map source, String name, bar.Bar field) {
    field = $om.bar_BarChild;
  }

}

@Compose
abstract class ChildContainer extends Base {

  @Create
  late foo.Foo five;

}
