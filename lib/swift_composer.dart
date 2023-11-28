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

class SubtypeInfo {
  //first non-abstract type of all subtypes
  String baseClassName;
  Map<String, dynamic> annotations;
  Map<String, dynamic> inheritedAnnotations;
  SubtypeInfo(this.baseClassName, this.annotations, this.inheritedAnnotations);
}

abstract class SubtypesOf<T> {

  Map<String, SubtypeInfo> get allSubtypes;
  Iterable<String> get allClassNames => allSubtypes.keys;

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

  //TODO refactor
  T get decorated => parent;

  ST sibling<ST>() {
    return (parent as Pluggable).plugin<ST>();
  }
}
