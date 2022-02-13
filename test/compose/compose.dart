import 'package:swift_composer/swift_composer.dart';
import '../lib/foo.dart' as foo;
import '../lib/generics.dart' as generics;

part 'compose.c.dart';

@Compose
abstract class Container {

  @Inject
  foo.Foo get fooInjected;

  @Inject
  generics.SimpleGeneric<foo.Foo> get genericOfFooInjected;

  @Inject
  generics.SimpleGeneric<String> get genericOfStringInjected;

  @Inject
  generics.ComplexGeneric<foo.Foo, foo.Foo> get complexGenericInjected;

  @Create
  late foo.Foo fooCreated;

  @Create
  late generics.SimpleGeneric<foo.Foo> genericOfFooCreated;

  @Create
  late generics.SimpleGeneric<String> genericOfStringCreated;

  @Create
  late generics.ComplexGeneric<foo.Foo, foo.Foo> complexGenericCreated;

  @Require
  late foo.Foo fooRequired;

  @Require
  late generics.SimpleGeneric<foo.Foo> genericOfFooRequired;

  @Require
  late generics.SimpleGeneric<String> genericOfStringRequired;

  @Require
  late generics.ComplexGeneric<foo.Foo, foo.Foo> complexGenericRequired;
}
