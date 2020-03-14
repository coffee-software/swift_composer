import 'module_fruits.dart' as module_fruit;
import 'module_banana.dart' as module_banana;
import 'module_price.dart' as module_price;

part 'main.c.dart';

void main() {
  $om.module_fruit_AllAvailableFruits.allFruits.forEach((name,fruit){
    print(name);
    print(fruit.toJson());
  });
}
