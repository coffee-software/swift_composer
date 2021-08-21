import 'package:swift_composer/swift_composer.dart';
import '../lib/module1.dart' as test_module1;
import '../lib/module2.dart' as test_module2;

part 'namespaces.c.dart';


@Compose
abstract class Container {
  //@Create
  //late test_module2.ComplexGeneric<test_module1.Foo, test_module1.Bar> foo1;
  //@Create
  //late List<test_module2.ComplexGeneric<test_module1.Foo, test_module1.Bar>> foo2;
  //@Create
  //late List<test_module2.ComplexGeneric<test_module1.Foo, List<test_module1.Bar>>> foo3;
  //@Create
  //late test_module2.SuperComplexGeneric<List<test_module1.Bar>, test_module1.SimpleGeneric<String>> foo4;
}

@Compose
abstract class GenericContainer<T> {
  //@Create
  //late test_module2.ComplexGeneric<T, test_module1.Bar> foo1;
  //@Create
  //late List<test_module2.ComplexGeneric<T, String>> foo2;
  //@Create
  //late List<test_module2.ComplexGeneric<T,  test_module1.SimpleGeneric<List<test_module1.Bar>>>> foo3;
  //@Create
  //late test_module2.SuperComplexGeneric<T, test_module1.SimpleGeneric<String>> foo4;
}


@Compose
abstract class FooContainer extends GenericContainer<test_module1.Foo> {

}
