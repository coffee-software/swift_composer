import 'package:swift_composer/swift_composer.dart';
import '../lib/foo.dart' as m1;
import '../lib/foo2.dart' as m2;
import '../lib/generics.dart' as generics;

part 'config.c.dart';

enum TestEnum {
  value1,
  value2,
  value3,
  value4
}

class TestFromString {
  String value;
  TestFromString.fromString(this.value);
}


@Compose
abstract class ConfigInjectTypes {

  @InjectConfig
  int get injectInt;

  @InjectConfig
  String get injectString;

  @InjectConfig
  List<String> get injectListString;

  @InjectConfig
  TestEnum get injectEnum;

  @InjectConfig
  TestFromString get injectFromString;
}

@Compose
abstract class Container {

  @Inject
  m1.Foo get fooInjected;

  @Inject
  generics.SimpleGeneric<m1.Foo> get genericInjected;

  @Create
  late m1.Foo fooCreated;

  @Create
  late generics.SimpleGeneric<m1.Foo> genericCreated;

  @Require
  late m1.Foo fooRequired;

  @Require
  late generics.SimpleGeneric<m2.Foo> genericRequired;
}
