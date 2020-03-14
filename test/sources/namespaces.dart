import 'package:swift_composer/swift_composer.dart';
import 'module1.dart' as test_module1;
import 'module2.dart' as test_module2;

part 'namespaces.c.dart';


@Compose
abstract class Container {
  @Create
  test_module2.ComplexGeneric<test_module1.Foo, test_module1.Bar> foo1;
  @Create
  List<test_module2.ComplexGeneric<test_module1.Foo, test_module1.Bar>> foo2;
  @Create
  List<test_module2.ComplexGeneric<test_module1.Foo, List<test_module1.Bar>>> foo3;
  @Create
  test_module2.SuperComplexGeneric<List<test_module1.Bar>, test_module1.SimpleGeneric<String>> foo4;
}

@Compose
abstract class GenericContainer<T> {
  @Create
  test_module2.ComplexGeneric<T, test_module1.Bar> foo1;
  @Create
  List<test_module2.ComplexGeneric<T, String>> foo2;
  @Create
  List<test_module2.ComplexGeneric<T,  test_module1.SimpleGeneric<List<test_module1.Bar>>>> foo3;
  @Create
  test_module2.SuperComplexGeneric<T, test_module1.SimpleGeneric<String>> foo4;
}


@Compose
abstract class FooContainer extends GenericContainer<test_module1.Foo> {

}
