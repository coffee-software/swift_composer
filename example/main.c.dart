// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SwiftGenerator
// **************************************************************************

// **************************************************************************
// generated by swift_composer at 2023-09-04 22:43:28.656474
// **************************************************************************
// CONFIG
// no config file for root: lib/swift_composer.di.yaml
// no config file for module_fruit: example/module_fruits.di.yaml
// no config file for module_banana: example/module_banana.di.yaml
// no config file for module_price: example/module_price.di.yaml
// no config file for module_discount: example/module_discount.di.yaml
// no config file for root: example/main.di.yaml
// **************************************************************************
// MERGED CONFIG
// **************************************************************************
// **************************************************************************
class $module_fruit_AllAvailableFruits extends module_fruit.AllAvailableFruits
    implements Pluggable {
  $module_fruit_AllAvailableFruits() {}
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }

//method createFruit override
  module_fruit.Fruit createFruit(String className, String name) {
    return $om.createSubtypeOfmodule_fruit_Fruit2(className, name);
  }
}

// **************************************************************************
class $module_fruit_Fruit extends module_fruit.Fruit implements Pluggable {
  late module_price.PricePlugin module_price_PricePlugin;
  late module_discount.DiscountPlugin module_discount_DiscountPlugin;
  $module_fruit_Fruit(name) {
    this.name = name;
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
    throw new Exception('no plugin for this type');
  }

  String get className => $om.s[0];
//method getFullName override
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

//method fieldsToJson override
  void fieldsToJson(Map<dynamic, dynamic> target) {
//compiled method
//dbg: fieldsToJson
    cfs_fieldsToJsonmodule_fruit_Fruit(this, target);
  }
}

// **************************************************************************
class $module_banana_Banana extends module_banana.Banana implements Pluggable {
  late module_price.PricePlugin module_price_PricePlugin;
  late module_discount.DiscountPlugin module_discount_DiscountPlugin;
  $module_banana_Banana(name) {
    this.name = name;
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
    throw new Exception('no plugin for this type');
  }

  String get className => $om.s[1];
//method getFullName override
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

//method fieldsToJson override
  void fieldsToJson(Map<dynamic, dynamic> target) {
//compiled method
    cfs_fieldsToJsonmodule_fruit_Fruit(this, target);
    cfs_fieldsToJsonmodule_banana_Banana(this, target);
  }
}

// **************************************************************************
class $module_price_PricePlugin extends module_price.PricePlugin
    implements Pluggable {
  $module_price_PricePlugin(parent) {
    this.parent = parent;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
class $module_discount_DiscountPlugin extends module_discount.DiscountPlugin
    implements Pluggable {
  $module_discount_DiscountPlugin(parent) {
    this.parent = parent;
  }
  T plugin<T>() {
    throw new Exception('no plugin for this type');
  }
}

// **************************************************************************
// **************************************************************************
void cfs_fieldsToJsonmodule_fruit_Fruit(
    module_fruit.Fruit dis, Map<dynamic, dynamic> target) {
  {
    const name = "name";
    target[name] = dis.name;
  }
  {
    const name = "weight";
    target[name] = dis.weight;
  }
  {
    const name = "length";
    target[name] = dis.length;
  }
  {
    const name = "height";
    target[name] = dis.height;
  }
  {
    const name = "width";
    target[name] = dis.width;
  }
}

void cfs_fieldsToJsonmodule_banana_Banana(
    module_banana.Banana dis, Map<dynamic, dynamic> target) {
  {
    const name = "curvative";
    target[name] = dis.curvative;
  }
}

// **************************************************************************
class $ObjectManager {
  $module_fruit_AllAvailableFruits? _module_fruit_AllAvailableFruits;
  $module_fruit_AllAvailableFruits get module_fruit_AllAvailableFruits {
    if (_module_fruit_AllAvailableFruits == null) {
      _module_fruit_AllAvailableFruits = new $module_fruit_AllAvailableFruits();
    }
    return _module_fruit_AllAvailableFruits as $module_fruit_AllAvailableFruits;
  }

  module_fruit.Fruit createSubtypeOfmodule_fruit_Fruit2(
      String className, String name) {
    if (className == $om.s[0]) return new $module_fruit_Fruit(name);
    if (className == $om.s[1]) return new $module_banana_Banana(name);
    throw new Exception('no type for ' + className);
  }

  final List<String> s = const ["module_fruit.Fruit", "module_banana.Banana"];
}

$ObjectManager $om = new $ObjectManager();
// generated in 24ms
