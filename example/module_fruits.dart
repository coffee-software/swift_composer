import 'package:swift_composer/swift_composer.dart';

const JsonEncode = true;


@Compose
abstract class AllAvailableFruits {
  @InjectInstances
  Map<String, Fruit> get allFruits;

}

@Compose
abstract class Fruit implements Pluggable {

  @InjectClassName
  String get className;

  @JsonEncode
  String name;

  @JsonEncode
  double weight = 1.0;

  @JsonEncode
  double length = 1.0;

  @JsonEncode
  double height = 1.0;

  @JsonEncode
  double width = 1.0;

  Map toJson() {
      Map ret = new Map();
      ret['className'] = className;
      this.fieldsToJson(ret);
      return ret;
  }

  @Compile
  void fieldsToJson(Map target);

  @CompileFieldsOfType
  @AnnotatedWith(JsonEncode)
  void _fieldsToJson1(Map target, String name, String field) {
    target[name] = field;
  }

  @CompileFieldsOfType
  @AnnotatedWith(JsonEncode)
  void _fieldsToJson2(Map target, String name, double field) {
    target[name] = field;
  }

}
