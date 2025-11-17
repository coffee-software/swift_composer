import 'package:swift_composer/swift_composer.dart';
import '../lib/foo.dart' as module_test;

part 'generics.c.dart';

@ComposeSubtypes
abstract class Generic<T, F extends module_test.Foo> {
  @InjectInstances
  Map<String, F> get instancesOfFoo;

  @SubtypeFactory
  F factoryForFoo(String className);
}

@Compose
abstract class Generic2<A> extends Generic<A, module_test.FooChild> {}

@Compose
abstract class TypedGeneric2 extends Generic2<module_test.Foo> {}
