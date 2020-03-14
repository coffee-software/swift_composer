import 'package:swift_composer/swift_composer.dart';
import 'module_fruits.dart';


@Compose
abstract class FruitPlugin extends TypePlugin<Fruit> {

  @JsonEncode
  double get price => parent.weight * parent.width * parent.height * parent.length;

}
