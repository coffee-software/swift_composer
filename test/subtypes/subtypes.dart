import 'package:swift_composer/swift_composer.dart';
import '../lib/foo.dart' as module_test1;
export '../lib/foo.dart';

part 'subtypes.c.dart';


//subtype annotations
const TestAnnotation = true;
class TestAnnotationWithValue {
  final String value;
  const TestAnnotationWithValue(this.value);
}

@ComposeSubtypes
abstract class AbstractBase {

}

abstract class SubtypeOfAbstract1 extends AbstractBase {

}

@TestAnnotation
@TestAnnotationWithValue('testValue')
abstract class SubtypeOfAbstract2 extends AbstractBase {

}

@TestAnnotationWithValue('overridenValue')
abstract class SubtypeOfAbstract3 extends SubtypeOfAbstract2 {

}

@Compose
abstract class Container {

  @InjectInstances
  Map<String, module_test1.Foo> get instances;

  @SubtypeFactory
  module_test1.Foo factory(String className);

  @Inject
  SubtypesOf<module_test1.Foo> get subtypes;

  @Inject
  SubtypesOf<AbstractBase> get subtypesWithAbstractBase;
}
