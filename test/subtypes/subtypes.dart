import 'package:swift_composer/swift_composer.dart';
import '../lib/module1.dart' as module_test1;

part 'subtypes.c.dart';

@Compose
abstract class Container {

  @InjectInstances
  Map<String, module_test1.Foo> get instances;

  @SubtypeFactory
  module_test1.Foo factory(String className);

}
