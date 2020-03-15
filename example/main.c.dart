// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

//no interceptor for [AnnotatedWith]
//no interceptor for [Pluggable]
//no interceptor for [TypePlugin]
//interceptor for [module_fruit.AllAvailableFruits]
//interceptor for module_fruit.AllAvailableFruits
//can be singleton: TRUE
//parent: AllAvailableFruits [@bool get Compose]
class $module_fruit_AllAvailableFruits extends module_fruit.AllAvailableFruits
    implements Pluggable {
  $module_fruit_AllAvailableFruits() {}
  T plugin<T>() {
    return null;
  }

  module_fruit.Fruit createFruit(String className, String name) {
    switch (className) {
      case 'module_fruit.Fruit':
        return new $module_fruit_Fruit(name);
      case 'module_banana.Banana':
        return new $module_banana_Banana(name);
    }
  }
}

//interceptor for [module_fruit.Fruit]
//interceptor for module_fruit.Fruit
//can be singleton: FALSE
//parent: Fruit [@bool get Compose]
class $module_fruit_Fruit extends module_fruit.Fruit implements Pluggable {
  module_price.PricePlugin module_price_PricePlugin;
  module_discount.DiscountPlugin module_discount_DiscountPlugin;
  $module_fruit_Fruit(name) {
//String
    this.name = name;
//double
//double
//double
//double
    module_price_PricePlugin = new $module_price_PricePlugin(this);
    module_discount_DiscountPlugin = new $module_discount_DiscountPlugin(this);
  }
  T plugin<T>() {
    if (T == module_price.PricePlugin) {
      return module_price_PricePlugin as T;
    }
    if (T == module_discount.DiscountPlugin) {
      return module_discount_DiscountPlugin as T;
    }
    return null;
  }

  String get className => "module_fruit.Fruit";
  String getFullName(String prefix, String suffix) {
    List<dynamic> args = [prefix, suffix];
    args = module_price_PricePlugin.beforeGetFullName(args[0], args[1]);
    prefix = args[0];
    suffix = args[1];
    var ret = super.getFullName(prefix, suffix);
    ret = module_price_PricePlugin.afterGetFullName(ret);
    ret = module_discount_DiscountPlugin.afterGetFullName(ret);
    return ret;
  }

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
//can be singleton: FALSE
//parent: Banana [@bool get Compose]
//parent: Fruit [@bool get Compose]
class $module_banana_Banana extends module_banana.Banana implements Pluggable {
  module_price.PricePlugin module_price_PricePlugin;
  module_discount.DiscountPlugin module_discount_DiscountPlugin;
  $module_banana_Banana(name) {
//String
    this.name = name;
//double
//double
//double
//double
//double
    module_price_PricePlugin = new $module_price_PricePlugin(this);
    module_discount_DiscountPlugin = new $module_discount_DiscountPlugin(this);
  }
  T plugin<T>() {
    if (T == module_price.PricePlugin) {
      return module_price_PricePlugin as T;
    }
    if (T == module_discount.DiscountPlugin) {
      return module_discount_DiscountPlugin as T;
    }
    return null;
  }

  String get className => "module_banana.Banana";
  String getFullName(String prefix, String suffix) {
    List<dynamic> args = [prefix, suffix];
    args = module_price_PricePlugin.beforeGetFullName(args[0], args[1]);
    prefix = args[0];
    suffix = args[1];
    var ret = super.getFullName(prefix, suffix);
    ret = module_price_PricePlugin.afterGetFullName(ret);
    ret = module_discount_DiscountPlugin.afterGetFullName(ret);
    return ret;
  }

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

//interceptor for [module_price.PricePlugin]
//interceptor for module_price.PricePlugin
//T[362979300] => Fruit[280451674]
//can be singleton: FALSE
//parent: PricePlugin [@bool get Compose]
//parent: TypePlugin [@bool get ComposeSubtypes]
class $module_price_PricePlugin extends module_price.PricePlugin
    implements Pluggable {
  $module_price_PricePlugin(parent) {
//T
    this.parent = parent;
  }
  T plugin<T>() {
    return null;
  }
}

//interceptor for [module_discount.DiscountPlugin]
//interceptor for module_discount.DiscountPlugin
//T[362979300] => Fruit[280451674]
//can be singleton: FALSE
//parent: DiscountPlugin [@bool get Compose]
//parent: TypePlugin [@bool get ComposeSubtypes]
class $module_discount_DiscountPlugin extends module_discount.DiscountPlugin
    implements Pluggable {
  $module_discount_DiscountPlugin(parent) {
//T
    this.parent = parent;
  }
  T plugin<T>() {
    return null;
  }
}

class $ObjectManager {
  $module_fruit_AllAvailableFruits _module_fruit_AllAvailableFruits;
  $module_fruit_AllAvailableFruits get module_fruit_AllAvailableFruits {
    if (_module_fruit_AllAvailableFruits == null) {
      _module_fruit_AllAvailableFruits = new $module_fruit_AllAvailableFruits();
    }
    return _module_fruit_AllAvailableFruits;
  }
}

$ObjectManager $om = new $ObjectManager();
//generated in 51ms
