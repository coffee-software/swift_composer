import 'package:swift_composer/swift_composer.dart';
import '../lib/module1.dart' as m1;
import '../lib/module2.dart' as m2;

part 'config.c.dart';

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
  late m1.SimpleGeneric<m2.Foo> genericRequired;
}
