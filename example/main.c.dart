// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

//interceptor for [module_fruit.AllAvailableFruits]
//interceptor for module_fruit.AllAvailableFruits
//can be singleton: TRUE
//parent: AllAvailableFruits [@bool get Compose]
class $module_fruit_AllAvailableFruits extends module_fruit.AllAvailableFruits {
  $module_fruit_AllAvailableFruits() {}
  T plugin<T>() {}
  Map<String, module_fruit.Fruit> get allFruits =>
      $om.instancesOfmodule_fruit_Fruit;
}

//interceptor for [module_fruit.Fruit]
//interceptor for module_fruit.Fruit
//can be singleton: TRUE
//parent: Fruit [@bool get Compose]
class $module_fruit_Fruit extends module_fruit.Fruit {
  module_price.FruitPlugin module_price_FruitPlugin;
  $module_fruit_Fruit() {
//String
//double
//double
//double
//double
    module_price_FruitPlugin = new $module_price_FruitPlugin(this);
  }
  T plugin<T>() {
    if (T == module_price.FruitPlugin) {
      return module_price_FruitPlugin as T;
    }
  }

  String get className => "module_fruit.Fruit";
  void fieldsToJson(Map target) {
//@JsonEncode
    {
      target['name'] = this.name;
    }
//@JsonEncode
    {
      target['weight'] = this.weight;
    }
    {
      target['length'] = this.length;
    }
    {
      target['height'] = this.height;
    }
    {
      target['width'] = this.width;
    }
  }
}

//interceptor for [module_banana.Banana]
//interceptor for module_banana.Banana
//can be singleton: TRUE
//parent: Banana [@bool get Compose]
//parent: Fruit [@bool get Compose]
class $module_banana_Banana extends module_banana.Banana {
  module_price.FruitPlugin module_price_FruitPlugin;
  $module_banana_Banana() {
//String
//double
//double
//double
//double
//double
    module_price_FruitPlugin = new $module_price_FruitPlugin(this);
  }
  T plugin<T>() {
    if (T == module_price.FruitPlugin) {
      return module_price_FruitPlugin as T;
    }
  }

  String get className => "module_banana.Banana";
  void fieldsToJson(Map target) {
//@JsonEncode
    {
      target['name'] = this.name;
    }
//@JsonEncode
    {
      target['weight'] = this.weight;
    }
    {
      target['length'] = this.length;
    }
    {
      target['height'] = this.height;
    }
    {
      target['width'] = this.width;
    }
    {
      target['curvative'] = this.curvative;
    }
  }
}

//interceptor for [module_price.FruitPlugin]
//interceptor for module_price.FruitPlugin
//T[362979300] => Fruit[280451674]
//can be singleton: FALSE
//parent: FruitPlugin [@bool get Compose]
//parent: TypePlugin [@bool get ComposeSubtypes]
class $module_price_FruitPlugin extends module_price.FruitPlugin {
  $module_price_FruitPlugin(parent) {
//T
    this.parent = parent;
  }
  T plugin<T>() {}
}

class $ObjectManager {
  $module_fruit_AllAvailableFruits _module_fruit_AllAvailableFruits;
  $module_fruit_AllAvailableFruits get module_fruit_AllAvailableFruits {
    if (_module_fruit_AllAvailableFruits == null) {
      _module_fruit_AllAvailableFruits = new $module_fruit_AllAvailableFruits();
    }
    return _module_fruit_AllAvailableFruits;
  }

  $module_fruit_Fruit _module_fruit_Fruit;
  $module_fruit_Fruit get module_fruit_Fruit {
    if (_module_fruit_Fruit == null) {
      _module_fruit_Fruit = new $module_fruit_Fruit();
    }
    return _module_fruit_Fruit;
  }

  $module_banana_Banana _module_banana_Banana;
  $module_banana_Banana get module_banana_Banana {
    if (_module_banana_Banana == null) {
      _module_banana_Banana = new $module_banana_Banana();
    }
    return _module_banana_Banana;
  }

  Map<String, module_fruit.Fruit> get instancesOfmodule_fruit_Fruit {
    return {
      "module_fruit.Fruit": new $module_fruit_Fruit(),
      "module_banana.Banana": new $module_banana_Banana(),
    };
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 35ms
