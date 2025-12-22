import 'package:swift_composer/swift_composer.dart';
import 'module_fruits.dart' as module_fruit;
import 'module_banana.dart' as module_banana;
import 'module_price.dart' as module_price;
import 'module_discount.dart' as module_discount;

part 'main.c.dart';

void main() {
  List<module_fruit.Fruit> fruits = [];

  fruits.addAll([
    $om.module_fruit_AllAvailableFruits.createFruit('module_fruit.Fruit', "Fruit 1"),
    $om.module_fruit_AllAvailableFruits.createFruit('module_fruit.Fruit', "Fruit 2")
      ..width = 50
      ..height = 10,
    $om.module_fruit_AllAvailableFruits.createFruit('module_banana.Banana', "Banana 1"),
    $om.module_fruit_AllAvailableFruits.createFruit('module_banana.Banana', "Banana 2")..weight = 100,
  ]);

  for (var fruit in fruits) {
    print(fruit.toJson());
  }
}
