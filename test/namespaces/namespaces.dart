import 'package:swift_composer/swift_composer.dart';

import '../lib/nested.dart' as nested_module;
import '../lib/foo2.dart' as foo2_module;
import '../lib/bar.dart' as bar_module;
import '../lib/generics.dart' as generics_module;

part 'namespaces.c.dart';

class Foo {}

class RootClass {
  late generics_module.SimpleGeneric<Foo> specificField;
}

class GenericRootClass<T> {
  late generics_module.SimpleGeneric<T> genericField;
}

class SpecificRootClass extends GenericRootClass<Foo> {}
