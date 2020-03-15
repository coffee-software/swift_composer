import 'package:swift_composer/swift_composer.dart';
import 'module_fruits.dart';


@Compose
abstract class PricePlugin extends TypePlugin<Fruit> {

  @JsonEncode
  double get price => parent.weight * parent.width * parent.height * parent.length;

  @MethodPlugin
  List<dynamic> beforeGetFullName(String arg1, String arg2)
  {
    arg1 = "[" + arg1;
    arg2 = arg2 + "]";
    return [arg1, arg2];
  }

  @MethodPlugin
  String afterGetFullName(String ret)
  {
    return ret + " $price\$";
  }
}
