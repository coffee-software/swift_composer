library swift_composer;

const Compose = true;
const ComposeSubtypes = true;

const Create = true;
const Require = true;
const Inject = true;
const InjectClassName = true;
const InjectClassNames = true;
const InjectConfig = true;

//TODO:
const InjectInstances = true;

abstract class SubtypesOf<T> {
  List<String> get allClassNames;
  //first non-abstract type of all subtypes
  Map<String, String> get baseClassNamesMap;
  String getCode<X extends T>();
  //TODO:
  //Map<String, T> get allInstances;
  //T getInstance<X extends T>();
}


const Compile = true;
const CompilePart = true;
const CompileFieldsOfType = true;

class AnnotatedWith {
  final annotation;
  const AnnotatedWith(this.annotation);
}

const Factory = true;
const SubtypeFactory = true;

const Template = true;

const MethodPlugin = true;

abstract class Pluggable {
  T plugin<T>();
}

@ComposeSubtypes
abstract class TypePlugin<T> {
  @Require
  late T parent;

  ST sibling<ST>() {
    return (parent as Pluggable).plugin<ST>();
  }
}
