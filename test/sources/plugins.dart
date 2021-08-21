import 'package:swift_composer/swift_composer.dart';
import '../lib/module1.dart' as module_test1;

part 'plugins.c.dart';

@Compose
abstract class SimplePlugin extends TypePlugin<module_test1.Foo> {

  //@Plugin
  void beforeFormat(String prefix) {
    prefix = prefix + ":BEFORE";
  }

  //@Plugin
  String afterFormat(String ret) => "AFTER:" + ret;

}

@Compose
abstract class MoreComplexPlugin extends TypePlugin<module_test1.Foo> {

  @Inject
  module_test1.Bar get bar;

}

@Compose
abstract class PluginOnGeneric extends TypePlugin<module_test1.SimpleGeneric> {

  @Inject
  module_test1.Bar get bar;

}
