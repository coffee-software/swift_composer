import 'package:swift_composer/swift_composer.dart';

const JsonEncode = true;


@Compose
abstract class AllAvailableFruits {
  @SubtypeFactory
  Fruit createFruit(String className, String name);
}

@Compose
abstract class Fruit implements Pluggable {

  @InjectClassName
  String get className;

  @Require
  @JsonEncode
  String name = "";

  @JsonEncode
  double weight = 1.0;

  @JsonEncode
  double length = 1.0;

  @JsonEncode
  double height = 1.0;

  @JsonEncode
  double width = 1.0;


  String getFullName(String prefix, String suffix) {
    return prefix + name + suffix;
  }

  Map toJson() {
      Map ret = new Map();
      ret['className'] = className;
      ret['fullName'] = getFullName("this fruit is called '", "'");
      this.fieldsToJson(ret);
      return ret;
  }

  @Compile
  void fieldsToJson(Map target);

  @CompileFieldsOfType
  @AnnotatedWith(JsonEncode)
  // ignore: unused_element
  void _fieldsToJson1(Map target, String name, String field) {
    target[name] = field;
  }

  @CompileFieldsOfType
  @AnnotatedWith(JsonEncode)
  // ignore: unused_element
  void _fieldsToJson2(Map target, String name, double field) {
    target[name] = field;
  }

}
