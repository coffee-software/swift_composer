library;

import 'package:swift_composer/swift_composer.dart';

import 'foo.dart';
export 'foo.dart';

@Compose
abstract class CombinedFoo {
  @InjectClassName
  String get className;

  @Inject
  Foo get inner_module_Foo1;
}
