import 'package:swift_composer/swift_composer.dart';
import '../lib/module1.dart' as m1;
import '../lib/module2.dart';

part 'compose.c.dart';

@Compose
abstract class Container {

  @Inject
  m1.Foo get fooInjected;

  @Inject
  m1.SimpleGeneric<m1.Foo> get genericInjected;

  @Create
  late m1.Foo fooCreated;

  @Create
  late m1.SimpleGeneric<m1.Foo> genericCreated;

  @Require
  late m1.Foo fooRequired;

  @Require
  late m1.SimpleGeneric<Foo> genericRequired;
}

abstract class AbstractGeneric<T> {
  @Inject
  T get element;

  @Inject
  m1.SimpleGeneric<T> get generic;
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
  late AbstractGeneric<T> genericFoo;
  @Create
  late GenericInterface<T> genericInterface;
  @Create
  late T child;
}

@Compose
class ContainerFoo extends GenericContainer<m1.Foo> {


}
