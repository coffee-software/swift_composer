import 'package:swift_composer/swift_composer.dart';
import '../lib/foo.dart' as module_test;

part 'factory.c.dart';

@Compose
abstract class Complex {
  @Require
  late String requiredString;
  @Require
  late module_test.Foo requiredFoo;
}

@Compose
abstract class Container {

    @Factory
    module_test.Foo createFoo();

    @Factory
    Complex createComplex(String requiredString, module_test.Foo requiredFoo);

    @SubtypeFactory
    module_test.Foo createSubFoo(String className);

    void test(){
      module_test.Foo x1 = createFoo();
      module_test.Foo x2 = createSubFoo('module_test.Foo');
      Complex complex = createComplex('text', x1);
    }

}
