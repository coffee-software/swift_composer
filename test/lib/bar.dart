library bar;

import 'package:swift_composer/swift_composer.dart';

@Compose
abstract class Bar {
  @InjectClassNames
  List<String> get classNames;

  @InjectConfig
  String get stringField;

  String format(String prefix) => "Bar: $prefix ${classNames.join(',')} $stringField";
}

@Compose
abstract class BarChild extends Bar {}
