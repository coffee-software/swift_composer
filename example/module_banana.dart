import 'package:swift_composer/swift_composer.dart';
import 'module_fruits.dart';

@Compose
abstract class Banana extends Fruit {
  @JsonEncode
  double curvative = 1.0;
}
