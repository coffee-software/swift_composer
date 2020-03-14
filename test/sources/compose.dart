import 'package:swift_composer/swift_composer.dart';
import 'module1.dart' as m1;
import 'module2.dart';

part 'compose.c.dart';

@Compose
abstract class Container {

  @Inject
  m1.Foo get fooInjected;

  @Inject
  m1.SimpleGeneric<m1.Foo> genericInjected;

  @Create
  m1.Foo fooCreated;

  @Create
  m1.SimpleGeneric<m1.Foo> genericCreated;

  @Require
  m1.Foo fooRequired;

  @Require
  m1.SimpleGeneric<Foo> genericRequired;
}

abstract class AbstractGeneric<T> {
  @Inject
  T get element;

  @Inject
  m1.SimpleGeneric<T> generic;
}

abstract class GenericInterface<K> {
  String getDescription(K x);
}

@Compose
abstract class GenericTypedWithFoo extends AbstractGeneric<m1.Foo> implements GenericInterface<m1.Foo> {
  String getDescription(m1.Foo x) {
    return "stringField=${x.stringField}";
  }
}

abstract class GenericContainer<T> {
  @Create
  AbstractGeneric<T> genericfoo;
  @Create
  GenericInterface<T> genericinterface;
  @Create
  T child;
}

@Compose
class ContainerFoo extends GenericContainer<m1.Foo> {


}
