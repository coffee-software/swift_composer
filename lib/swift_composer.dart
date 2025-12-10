library;

// ignore: constant_identifier_names
const Compose = true;
// ignore: constant_identifier_names
const ComposeSubtypes = true;

//if module does not require other, but add optional subtypes or plugins, use this annotation
class ComposeIfModule {
  final String moduleCode;
  const ComposeIfModule(this.moduleCode);
}

// ignore: constant_identifier_names
const Create = true;
// ignore: constant_identifier_names
const Require = true;
// ignore: constant_identifier_names
const Inject = true;
// ignore: constant_identifier_names
const InjectClassName = true;
// ignore: constant_identifier_names
const InjectClassNames = true;
// ignore: constant_identifier_names
const InjectConfig = true;

//TODO: allow lists?
// ignore: constant_identifier_names
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

class UnknownTypeException implements Exception {
  final String typeCode;
  const UnknownTypeException(this.typeCode);
  @override
  String toString() => 'no type for $typeCode';
}

// ignore: constant_identifier_names
const Compile = true;
// ignore: constant_identifier_names
const CompilePart = true;
// ignore: constant_identifier_names
const CompileFieldsOfType = true;

class AnnotatedWith {
  final dynamic annotation;
  const AnnotatedWith(this.annotation);
}

// ignore: constant_identifier_names
const Factory = true;
// ignore: constant_identifier_names
const SubtypeFactory = true;

// ignore: constant_identifier_names
const Template = true;
// ignore: constant_identifier_names
const MethodPlugin = true;

abstract class Pluggable {
  T plugin<T>();
}

@ComposeSubtypes
abstract class TypePlugin<T> {
  @Require
  late T decorated;

  ST sibling<ST>() {
    return (decorated as Pluggable).plugin<ST>();
  }
}
