import 'package:swift_composer/swift_composer.dart';
import 'module1.dart' as module_test;

import 'package:source_gen/builder.dart' as jajaja;

part 'factory.c.dart';

@Compose
abstract class Complex {
  @Require
  String requiredString;
  @Require
  module_test.Foo requiredFoo;
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
      module_test.Foo x2 = createSubFoo('FooChild');
      Complex complex = createComplex('text', x1);
    }

}
