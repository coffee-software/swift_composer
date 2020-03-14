library swift_composer;

const Compose = true;
const ComposeSubtypes = true;

const Create = true;
const Require = true;
const Inject = true;
const InjectClassName = true;
const InjectClassNames = true;
const InjectInstances = true;
const InjectSubtypesNames = true;
const InjectConfig = true;

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

const Plugable = true;
const Plugin = true;

//typedef S TypeCreator<S>();
/*
class SubtypeOf<T> {
  TypeCreator<T> _creator;
  List<dynamic> metadata;
  SubtypeOf(this._creator, this.metadata);

  T _instance;
  T get instance => _instance == null ? _instance = _creator() : _instance;
  T createNew() => _creator();
}*/

/*
abstract class Factory<T> {
  T faktorius;
  T createNew(List<dynamic> args);
}

abstract class SubtypesOf<T> extends DelegatingMap<String, SubtypeOf<T>> {
  final Map<String, SubtypeOf<T>> delegate = {};
}

class FieldsOfType<T> extends DelegatingMap<String, T> {
  Map<String, T> delegate = {};
  FieldsOfType(this.delegate);
} */

@ComposeSubtypes
abstract class TypePlugin<T> {
  @Require
  T parent;

  ST sibling<ST extends TypePlugin>() {
    //TODO
    print(ST.hashCode);
    return null;
  }
}
