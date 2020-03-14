import 'package:swift_composer/swift_composer.dart';
import 'module1.dart' as module_test;

part 'generics.c.dart';

@Compose
abstract class Generic<T, F extends module_test.Foo> {

}

@Compose
abstract class Generic2<A> extends Generic<A, module_test.FooChild> {

}


@Compose
abstract class TypedGeneric2 extends Generic2<module_test.Foo> {

}
