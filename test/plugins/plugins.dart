import 'package:swift_composer/swift_composer.dart';
import '../lib/foo.dart' as foo;
import '../lib/bar.dart' as bar;
import '../lib/generics.dart' as generics;

part 'plugins.c.dart';

@Compose
abstract class SimplePlugin extends TypePlugin<foo.Foo> {
  @MethodPlugin
  List beforeFormat(String prefix) {
    return [prefix + ":BEFORE"];
  }

  @MethodPlugin
  String afterFormat(String ret) => "AFTER:" + ret;
}

@Compose
abstract class MoreComplexPlugin extends TypePlugin<foo.Foo> {
  @Inject
  bar.Bar get barField;
}

@Compose
abstract class PluginOnGeneric extends TypePlugin<generics.SimpleGeneric> {
  @Inject
  bar.Bar get barField;
}

@Compose
abstract class AbstractGeneric<T> {
  @Inject
  T get element;

  @Inject
  generics.SimpleGeneric<T> get generic;
}

@Compose
abstract class GenericTypedWithFoo extends AbstractGeneric<foo.Foo> {
  String getDescription(foo.Foo x) {
    return "stringField=${x.stringField}";
  }
}

abstract class GenericContainer<T> {
  @Create
  late AbstractGeneric<T> genericFoo;
  @Create
  late T child;
}

@Compose
class ContainerFoo extends GenericContainer<foo.Foo> {}
