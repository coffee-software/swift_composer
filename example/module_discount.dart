import 'package:swift_composer/swift_composer.dart';
import 'module_fruits.dart';
import 'module_price.dart';

@Compose
abstract class DiscountPlugin extends TypePlugin<Fruit> {

  double get discountedPrice => decorated.plugin<PricePlugin>().price * 0.5;

  @MethodPlugin
  String afterGetFullName(String ret)
  {
    return ret + " discounted to $discountedPrice";
  }
}
