library;

import 'dart:convert';

import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:build/build.dart';

import 'tools.dart';

Future<ResolvedLibraryResult> _getResolvedLibrary(LibraryElement library, Resolver resolver) async {
  final freshLibrary = await resolver.libraryFor(await resolver.assetIdForElement(library));
  final freshSession = freshLibrary.session;
  return await freshSession.getResolvedLibraryByElement(freshLibrary) as ResolvedLibraryResult;
}

Map<int, String> sourcesCache = {};

extension MethodElementSource on MethodElement {
  Future<String> getSourceCode(BuildStep step) async {
    if (sourcesCache.containsKey(hashCode)) {
      return sourcesCache[hashCode]!;
    }
    String part = '';
    try {
      // TODO: https://github.com/dart-lang/build/issues/2634
      // find better way to get method source?
      ParsedLibraryResult result = session!.getParsedLibraryByElement(library) as ParsedLibraryResult;
      part = result.getFragmentDeclaration(firstFragment)!.node.toSource();
    } on InconsistentAnalysisException {
      var resolver = step.resolver;
      ResolvedLibraryResult result = await _getResolvedLibrary(library, resolver);
      part = result.getFragmentDeclaration(firstFragment)!.node.toSource();
    }
    //named parameters can be defined
    if (firstFragment.isAsynchronous) {
      part = part.substring(part.indexOf(') async {') + 9, part.length - 1);
    } else {
      part = part.substring(part.indexOf(') {') + 3, part.length - 1);
    }
    sourcesCache[hashCode] = part;
    //part = '//method_hash:' + this.hashCode.toString() + "\n" + part;
    return part;
  }
}

abstract class TemplateLoader {
  String? load(String path);
}

class TypeInfo {
  TypeMap typeMap;
  late DartType type;

  List<TypeInfo>? _plugins;
  List<TypeInfo> get plugins {
    _plugins ??= typeMap.getPluginsForType(this);
    return _plugins!;
  }

  List<TypeInfo> typeArguments;
  DiConfig config;

  TypeInfo(this.typeMap, this.type, this.config, {this.typeArguments = const []});

  ClassElement? get element {
    if ((type.element != null) && (type.element is ClassElement)) {
      return type.element as ClassElement;
    }
    return null;
  }

  bool get isNullable => (type.nullabilitySuffix == NullabilitySuffix.question);

  // name accessible in local context
  String get classCodeAsReference {
    if (!typeMap.allSymbols.contains(fullName)) {
      typeMap.allSymbols.add(fullName);
    }
    return "\$om.s[${typeMap.allSymbols.indexOf(fullName)}]";
  }

  // name accessible in local context
  String get fullName {
    if ((type.element != null) && (typeMap.classNames.containsKey(type.element))) {
      return typeMap.classNames[type.element]!;
    } else {
      //TODO: validate if core?
      var name = type.getDisplayString();
      if (name.contains('<')) {
        return name.substring(0, name.indexOf('<'));
      }
      if (name.contains('?')) {
        return name.substring(0, name.indexOf('?'));
      }
      return name;
    }
  }

  String get uniqueName {
    return fullName + (typeArguments.isNotEmpty ? '<${typeArguments.map((e) => e.uniqueName).join(',')}>' : '') + (isNullable ? '?' : '');
    //':' + type.getDisplayString()
    //':' + ((type is ParameterizedType) ? (type as ParameterizedType).typeArguments.map((e) => e.getDisplayString()).join(',') : 'NP') +
  }

  String get debugInfo {
    return '$uniqueName ${hasInterceptor() ? 'INTERCEPTED' : ''} ${isGeneric() ? 'GENERIC' : ''} [${typeArgumentsMap().map((key, value) => MapEntry(key.name, '${key.name!} = ${value.getDisplayString()}')).values.join(',')}   ${typeArgumentsMap().map((key, value) => MapEntry(key.name, '${key.hashCode} = ${value.hashCode}')).values.join(',')}   ${typeArgumentsMap().map((key, value) => MapEntry(key.name, '${key.hashCode} = ${value.runtimeType}')).values.join(',')}]';
  }

  String get varName {
    return '${flatName[0].toLowerCase()}${flatName.substring(1)}';
  }

  String get flatName {
    return '${fullName.replaceAll('.', '_')}${typeArguments.isNotEmpty ? '_${typeArguments.map((e) => e.flatName).join('_')}_' : ''}';
  }

  bool isGeneric() {
    return element != null && (typeArguments.isEmpty) && (element!.typeParameters.isNotEmpty);
  }

  Map get typeConfig {
    Map<dynamic, dynamic> classConfig = {};
    int test = 1;
    //List<TypeInfo> path = allTypeInfoPath().toList();
    for (var type in allTypeInfoPath()) {
      classConfig[type.fullName] = test++;
      if (config.config.containsKey(type.fullName)) {
        for (var k in config.config[type.fullName].keys) {
          if (!classConfig.containsKey(k)) {
            classConfig[k] = config.config[type.fullName][k];
          }
        }
      }
    }
    return classConfig;
  }

  String get creatorName => hasInterceptor() ? '\$$flatName' : fullName;

  String generateCompiledConstructorDefinition() {
    return '\$$flatName(${allRequiredFields().map((f) => f.name).join(',')}) {\n';
  }

  Iterable<FieldElement> allRequiredFields() {
    return allFields().where((f) => elementInjectionType(f) == '@Require');
  }

  String generateCreator() {
    String constructor = creatorName;
    if (fullName == 'List') {
      constructor += '.empty';
    }
    return 'new $constructor(${allRequiredFields().map((f) => f.name).join(',')})';
    //TODO use ".."
    /*allFields().forEach((fieldElement){
      if (fieldElement.setter != null) {
        lines.add("//${fieldElement.type.name}[${fieldElement.type.hashCode.toString()}]");
        //typeArgumentsMap());

        String value = getFieldAssignmentValue(fieldElement);
        if (value != null) {
          lines.add(
            '${varName}.${fieldElement.name} = ' + value + ';'
          );
        }
      }
    });*/
  }

  List<String> decorators = [
    '@Create',
    '@Require',
    '@Inject',
    '@InjectClassName',
    '@InjectClassNames',
    '@InjectInstances',
    '@InjectConfig',
    '@Compile',
    '@CompilePart',
    '@CompileFieldsOfType',

    '@Factory',
    '@SubtypeFactory',
    '@Template',
    '@MethodPlugin',
  ];

  String? elementInjectionType(Element element) {
    for (var metadataElement in element.metadata.annotations) {
      if (decorators.contains(metadataElement.toSource())) {
        return metadataElement.toSource();
      }
    }
    return null;
  }

  String? getFieldInitializationValue(TypeInfo fieldType, FieldElement field) {
    if (field.getter == null) {
      return null;
    }
    switch (elementInjectionType(field.getter!)) {
      case '@Inject':
        if (fieldType.fullName == 'SubtypesOf') {
          TypeInfo type = fieldType.typeArguments[0];
          typeMap.subtypesOf[type.uniqueName] = type;
          return '\$om.subtypesOf${type.flatName}';
        } else {
          return typeMap.generateTypeGetter(fieldType);
        }
      case '@InjectConfig':
        if (!typeConfig.containsKey(field.name)) {
          if (field.getter!.isAbstract) {
            if (!fieldType.isNullable) {
              throw Exception("missing config value for non nullable field ${fieldType.fullName} ${field.name}");
            }
            return 'null';
          } else {
            return null;
          }
        }
        switch (fieldType.uniqueName) {
          case "String":
          case "String?":
            return '"${typeConfig[field.name].replaceAll('"', '\\"').replaceAll('\n', '\\n')}"';
          case "int":
          case "double":
          case "bool":
          case "int?":
          case "double?":
          case "bool?":
            return typeConfig[field.name].toString();
          case "List<String>":
            return '[${typeConfig[field.name].map((e) => '"${e.replaceAll('"', '\\"').replaceAll('\n', '\\n')}"').join(',')}]';
          case "Map<dynamic,dynamic>?":
            return jsonEncode(typeConfig[field.name]);
          case "Map<dynamic,dynamic>":
            return jsonEncode(typeConfig[field.name]);
          default:
            //TODO: check why fieldType.type.isDartCoreEnum does not return true for enums here
            var value = typeConfig[field.name];
            //element is null for such types so this is a workaround
            if (fieldType.element == null /*fieldType.type.isDartCoreEnum*/ ) {
              if (value is int) {
                return '${fieldType.uniqueName}.values.length > ${value.toString()} ? ${fieldType.uniqueName}.values[${value.toString()}] : ${fieldType.uniqueName}.values[0]';
              } else {
                return '${fieldType.uniqueName}.$value';
              }
            }
            if (value is String) {
              return 'new ${fieldType.fullName}.fromString("$value")';
            } else {
              return null;
            }
        }
      case '@InjectInstances':
        TypeInfo type = fieldType.typeArguments[1];
        typeMap.subtypeInstanes[type.uniqueName] = type;
        return '\$om.instancesOf${type.flatName}';
      case '@InjectClassName':
        return classCodeAsReference;
      case '@InjectClassNames':
        List<String> path = [];
        for (var type in allTypeInfoPath()) {
          if (field.enclosingElement == type.element) break;
          path.add(type.classCodeAsReference);
        }
        return '[${path.reversed.join(',')}]';
      default:
        return null;
    }
  }

  String? getFieldAssignmentValue(FieldElement field) {
    TypeInfo fieldType = typeMap.fromDartType(field.type, context: typeArgumentsMap());

    switch (elementInjectionType(field)) {
      case '@Require':
        return field.name;
      case '@InjectFields':
        String args = allFields().where((f) => f.type.getDisplayString() != 'dynamic').map((e) => '\'${e.name}\':this.${e.name}').join(',');
        return 'new ${fieldType.type.getDisplayString()}({$args});\n';
    }
    return null;
  }

  Iterable<TypeInfo> allTypeInfoPath() sync* {
    for (var element in allClassElementsPath()) {
      yield typeMap.fromDartType(element.thisType, context: typeArgumentsMap());
    }
  }

  // yields class element and all its supertypes
  Iterable<ClassElement> allClassElementsPath() sync* {
    if (element != null) {
      yield element!;
    }
    yield* parentClassElementsPath();
  }

  Iterable<ClassElement> parentClassElementsPath() sync* {
    if (element != null) {
      for (var st in element!.allSupertypes) {
        if (st.element.name == 'Object') {
          break;
        }
        yield st.element as ClassElement;
      }
    }
  }

  bool canBeSingleton() {
    if (element == null) {
      return false;
    }
    /*if (element!.typeParameters.length > 0) {
      return false;
    }*/
    if (allRequiredFields().isNotEmpty) {
      return false;
    }
    if (isNullable) {
      return false;
    }
    return hasInterceptor();
  }

  bool hasInterceptor() {
    if (isGeneric()) {
      return false;
    }
    for (var k in typeArguments) {
      if (k.element == null) {
        return false;
      }
    }

    bool? ret;
    if (element != null) {
      for (var c in allClassElementsPath()) {
        for (var metadataElement in c.metadata.annotations) {
          if (metadataElement.toSource() == '@Compose') {
            ret = true;
          }
          if (metadataElement.toSource() == '@ComposeSubtypes') {
            ret = (c != element);
          }
        }
        if (ret != null) break;
      }
      /*if (ret == false ) {
        if (element!.displayName == 'Map' || element!.displayName == 'List') {
          ret = true;
        }
      }*/
    }

    //TODO optimise if does not have plugins?
    //typeMap.getPluginsForType(this).isEmpty

    return ret ?? false;
  }

  List<FieldElement> allFields({bool parentFirst = false}) {
    List<FieldElement> allFields = [];

    for (var element in (parentFirst ? allClassElementsPath().toList().reversed : allClassElementsPath())) {
      for (var f in element.fields) {
        if (!f.name!.startsWith('_')) {
          allFields.add(f);
        }
      }
      for (var m in element.mixins) {
        for (var f in m.element.fields) {
          if (!f.name!.startsWith('_')) {
            allFields.add(f);
          }
        }
      }
    }
    return allFields;
  }

  List<PropertyAccessorElement> allGetters() {
    List<PropertyAccessorElement> allGetters = [];
    List<String> overrides = [];
    for (var element in allClassElementsPath()) {
      for (var method in element.getters) {
        if (!overrides.contains(method.name)) {
          allGetters.add(method);
          overrides.add(method.name ?? 'error');
        }
      }
      for (var mixin in element.mixins) {
        for (var method in mixin.getters) {
          if (!overrides.contains(method.name)) {
            allGetters.add(method);
            overrides.add(method.name ?? 'error');
          }
        }
      }
    }
    return allGetters;
  }

  List<MethodElement> allMethods() {
    List<MethodElement> allMethods = [];
    List<String> overrides = [];
    for (var element in allClassElementsPath()) {
      for (var method in element.methods) {
        //if (!m.name.startsWith('_'))
        if (!overrides.contains(method.name)) {
          allMethods.add(method);
          overrides.add(method.name!);
        }
      }
      for (var mixin in element.mixins) {
        for (var method in mixin.methods) {
          if (!overrides.contains(method.name)) {
            allMethods.add(method);
            overrides.add(method.name!);
          }
        }
      }
    }
    return allMethods;
  }

  Map<TypeParameterElement, DartType> typeArgumentsMap() {
    Map<TypeParameterElement, DartType> ret = {};
    if (element == null) return ret;
    /*for (var element in allClassElementsPath()) {
      var j = 0;
      element.typeParameters.forEach((typeParam) {
        ret[typeParam] = element.thisType.typeArguments[j++];
      });
    }*/
    for (var s in element!.allSupertypes) {
      var j = 0;

      for (var tp in s.element.typeParameters) {
        ret[tp] = s.typeArguments[j++];
      }
    }
    var j = 0;
    for (var tp in element!.typeParameters) {
      ret[tp] = (type as ParameterizedType).typeArguments[j++];
    }
    return ret;
  }

  Future<void> preAnaliseAllUsedTypes() async {
    element?.interfaces.forEach((interface) {
      typeMap.fromDartType(interface, context: typeArgumentsMap());
    });
    element?.allSupertypes.forEach((superType) {
      typeMap.fromDartType(superType, context: typeArgumentsMap());
    });
    allFields().forEach((fieldElement) {
      typeMap.fromDartType(fieldElement.type, context: typeArgumentsMap());
    });
    allMethods().forEach((methodElement) {
      for (var typeParameterElement in methodElement.typeParameters) {
        if (typeParameterElement.bound != null) {
          typeMap.fromDartType(typeParameterElement.bound!, context: typeArgumentsMap());
        }
      }
      methodElement.formalParameters.map((parameterElement) {
        typeMap.fromDartType(parameterElement.type, context: typeArgumentsMap());
      });
      typeMap.fromDartType(methodElement.returnType, context: typeArgumentsMap());
    });
  }

  Future<void> writeDebugInfo(OutputWriter output) async {
    output.writeLn("// type arguments[1]:");
    for (var k in typeArgumentsMap().keys) {
      output.writeLn("// ${k.name}[${k.hashCode.toString()}] => ${typeArgumentsMap()[k]!.getDisplayString()}[${typeArgumentsMap()[k].hashCode.toString()}]");
    }

    output.writeLn("// type arguments[2]:");
    for (var k in typeArguments) {
      output.writeLn("// ENCLOSING: ${k.element != null ? (k.element!.enclosingElement.name ?? "XXX") : "NULL"}");
      output.writeLn("// ${k.type.getDisplayString()}[${k.hashCode.toString()}]");
    }

    if (element != null) {
      output.writeLn("// can be singleton: ${canBeSingleton() ? 'TRUE' : 'FALSE'}");
      for (var element in element!.typeParameters) {
        output.writeLn("// parameter: ${element.name} ${element.hashCode.toString()}");
        //lines.add("//parameter: ${element.bound == null ? "NULL" : element.bound.name}");
        //lines.add("//parameter: ${element.instantiate(nullabilitySuffix: NullabilitySuffix.none).element.name}");
      }
      for (var element in element!.thisType.typeArguments) {
        output.writeLn("// argument: ${element.getDisplayString()} ${element.hashCode.toString()}");
      }

      for (var s in element!.allSupertypes) {
        output.writeLn("// parent: ${s.element.displayName} ${s.element.metadata.toString()}");
        for (var element in s.element.typeParameters) {
          output.writeLn("// parameter: ${element.name} ${element.hashCode.toString()}");
          //lines.add("//parameter: ${element.bound == null ? "NULL" : element.bound.name}");
          //lines.add("//parameter: ${element.instantiate(nullabilitySuffix: NullabilitySuffix.none).element.name}");
        }
        for (var element in s.typeArguments) {
          output.writeLn("// argument: ${element.getDisplayString()} ${element.hashCode.toString()}");
        }
      }
      //lines.add("//config: ${json.encode(typeConfig)}");

      for (var p in plugins) {
        output.writeLn("// plugin: ${p.fullName}");
      }

      output.writeLn("// CONFIG");
      typeConfig.forEach((key, value) {
        output.writeLn("// config: $key $value");
      });
      output.writeLn("// TYPE PATH:");
      for (var type in allTypeInfoPath()) {
        output.writeLn("//  ${type.fullName}");
      }
    }
  }

  Future<void> generateInterceptor(OutputWriter output, TemplateLoader templateLoader) async {
    if (typeArguments.isNotEmpty) {
      String parent =
          '\$${fullName.replaceAll('.', '_')}'
          '<${typeArguments.map((e) => e.creatorName).join(',')}>';
      parent = uniqueName;
      output.writeLn('//parametrized type');
      output.writeLn('class \$$flatName extends $parent implements Pluggable {');
    } else {
      var typeArgsList = element!.typeParameters
          .map((e) {
            return e.name! + (e.bound != null ? " extends ${(typeMap.fromDartType(e.bound!, context: typeArgumentsMap())).fullName}" : '');
          })
          .join(',');
      var typeArgs = element!.typeParameters.isNotEmpty ? "<$typeArgsList>" : '';

      var shortArgs = element!.typeParameters.isNotEmpty ? "<${element!.typeParameters.map((e) => e.name).join(',')}>" : '';

      var abstract = element!.typeParameters.isNotEmpty ? 'abstract ' : '';
      output.writeLn('${abstract}class \$$flatName$typeArgs extends $fullName$shortArgs implements Pluggable {');
      if (element!.typeParameters.isNotEmpty) {
        output.writeLn('}');
        return;
      }
    }

    for (var p in plugins) {
      output.writeLn('late ${p.fullName} ${p.varName};');
    }

    output.writeLn(generateCompiledConstructorDefinition());

    allFields().forEach((fieldElement) {
      if (fieldElement.setter != null) {
        //output.writeLn("//${fieldElement.type.getDisplayString()}");

        if (elementInjectionType(fieldElement) == '@Create') {
          //TMP
          TypeInfo ti = typeMap.fromDartType(fieldElement.type, context: typeArgumentsMap());
          output.writeLn("//${ti.uniqueName}", debug: true);
          typeMap.getNonAbstractSubtypes(ti).forEach((element) {
            output.writeLn("// c: ${element.uniqueName}", debug: true);
          });

          TypeInfo candidate = typeMap.getBestCandidate(ti);
          output.writeLn('this.${fieldElement.name} = ${candidate.generateCreator()};');
        } else {
          String? value = getFieldAssignmentValue(fieldElement);
          if (value != null) {
            output.writeLn('this.${fieldElement.name} = $value;');
          }
        }
      }
    });

    for (var p in plugins) {
      output.writeLn("${p.varName} = new ${p.creatorName}(this);");
    }
    output.writeLn('}');

    //TODO if pluggable
    output.writeLn("T plugin<T>() {");
    for (var p in plugins) {
      output.writeLn("if (T == ${p.fullName}) {");
      output.writeLn("return ${p.varName} as T;");
      output.writeLn("}");
    }
    output.writeLn("throw new Exception('no plugin for this type');");
    output.writeLn("}");

    allFields().forEach((fieldElement) {
      //fieldElement.type
      //ClassElement

      /*lines.add('//ELEMENT:' + fieldElement.getDisplayString());
        var t = fieldElement.type;
        if (this.type is ParameterizedType) {
          lines.add('//TYPE is ParameterizedType');
          (this.type as ParameterizedType).typeArguments.forEach((element) {
            lines.add('//typeArguments[]:' + element.getDisplayString());
          });
        }

        if (t is TypeParameterType) {
          lines.add('//FIELD TYPE is TypeParameterType');
          lines.add('//h:' + t.hashCode.toString());
          lines.add('//b:' + t.bound.toString());
          lines.add('//e:' + t.element.instantiate(nullabilitySuffix: t.nullabilitySuffix).toString());
        }
        if (t is ParameterizedType) {
          lines.add('//FIELD TYPE is ParameterizedType');
          t.typeArguments.forEach((element) {
            lines.add('//typeArguments[]:' + element.getDisplayString());
          });
        }
        var x = typeArgumentsMap().containsKey(t) ? typeArgumentsMap()[t] : t;
        lines.add('//TEST7:' + x.name);

        var x2 = t;
        for (var value1 in typeArgumentsMap().keys) {
          lines.add('//xxx:' + value1.hashCode.toString() + "  " + t.hashCode.toString());
          if (value1.hashCode == t.hashCode) {
            lines.add('//yyy:' + value1.hashCode.toString() + "  " + t.hashCode.toString());
            x2 = typeArgumentsMap()[value1];
          }
        }
        lines.add('//TEST8:' + x2.name);
      */
      TypeInfo fieldType = typeMap.fromDartType(fieldElement.type, context: typeArgumentsMap());

      //fieldElement.type.isDartAsyncFutureOr
      //output.writeLn("// ${fieldType.uniqueName} ${fieldElement.name}");
      String? value = getFieldInitializationValue(fieldType, fieldElement);
      if (value != null) {
        output.writeLn("${fieldType.uniqueName} get ${fieldElement.name} => $value;");
      }
    });

    for (var methodElement in allMethods()) {
      List<String> methodLines = await generateMethodOverride(methodElement);
      if (methodLines.isNotEmpty) {
        output.writeLn('//method ${methodElement.name} override');
        TypeInfo returnType = typeMap.fromDartType(methodElement.returnType, context: typeArgumentsMap());
        var typeArgsList = methodElement.typeParameters
            .map((e) {
              return e.name! + (e.bound != null ? " extends ${(typeMap.fromDartType(e.bound!, context: typeArgumentsMap())).fullName}" : '');
            })
            .join(',');
        var typeArgs = typeArgsList.isNotEmpty ? "<$typeArgsList>" : '';
        output.writeLn("${returnType.uniqueName} ${methodElement.name}$typeArgs(");
        output.writeLn(
          methodElement.formalParameters
              .map((mp) {
                TypeInfo parameterType = typeMap.fromDartType(mp.type, context: typeArgumentsMap());
                return "${parameterType.uniqueName} ${mp.name}";
              })
              .join(","),
        );

        output.writeLn(") ${methodElement.returnType.isDartAsyncFuture ? 'async' : ''} {");
        output.writeMany(methodLines);
        output.writeLn("}");
      }
    }
    for (var accessorElement in allGetters()) {
      if (accessorElement.name!.startsWith('override_')) {
        String originalAccessorName = accessorElement.name!.replaceFirst('override_', '');
        output.writeLn('@override');
        output.writeLn('${accessorElement.returnType} get $originalAccessorName => override_$originalAccessorName;');
      }
    }
    //generted template methods
    for (var fieldElement in allFields()) {
      for (var metadataElement in fieldElement.getter?.metadata.annotations ?? []) {
        if (metadataElement.toSource() == '@Template') {
          String? templateBody = templateLoader.load('$flatName.${fieldElement.name!}');
          if (templateBody != null) {
            output.writeLn("${fieldElement.type.toString()} get ${fieldElement.name} => '''");
            output.writeLn(templateBody);
            output.writeLn("''';");
          }
        }
      }
    }

    output.writeLn('}');
  }

  Future<List<String>> generateMethodOverride(MethodElement methodElement) async {
    TypeInfo returnType = typeMap.fromDartType(methodElement.returnType, context: typeArgumentsMap());
    List<String> lines = [];

    if (elementInjectionType(methodElement) == '@SubtypeFactory') {
      if ((methodElement.firstFragment.formalParameters[0].name != 'className') ||
          (methodElement.firstFragment.formalParameters[0].element.type.getDisplayString() != 'String')) {
        throw Exception('SubtypeFactory first argument needs to be named className and be of type String');
      }
      List<String> argsDef = [];
      List<String> argsInv = [];
      Map<String, TypeInfo> arguments = {};
      for (var p in methodElement.firstFragment.formalParameters) {
        TypeInfo argType = typeMap.fromDartType(p.element.type, context: typeArgumentsMap());
        argsDef.add('${argType.uniqueName} ${p.name!}');
        argsInv.add(p.name!);
        arguments[p.name!] = argType;
      }
      String factoryInv = 'createSubtypeOf${returnType.flatName}${argsInv.length}(${argsInv.join(',')})';
      String factoryDef = 'createSubtypeOf${returnType.flatName}${argsInv.length}(${argsDef.join(',')})';

      if (!typeMap.subtypeFactories.containsKey(factoryDef)) {
        typeMap.subtypeFactories[factoryDef] = SubtypeFactoryInfo(returnType, arguments);
      }
      lines.add('return \$om.$factoryInv;');
    } else if (elementInjectionType(methodElement) == '@Factory') {
      var best = typeMap.getBestCandidate(returnType);
      lines.add('//${returnType.fullName}');
      lines.add('return ${best.generateCreator()};');
    } else if (elementInjectionType(methodElement) == '@Compile') {
      lines.add('//compiled method');
      //TODO: add original method if not abstract ??
      List<CompiledFieldMethodPart> calledParts = [];
      for (var methodPartElement in allMethods()) {
        if (methodPartElement.name!.startsWith('_${methodElement.name!}')) {
          if (elementInjectionType(methodPartElement) == '@CompilePart') {
            String part = await methodPartElement.getSourceCode(typeMap.step);
            lines.add(part);
          } else if (elementInjectionType(methodPartElement) == '@CompileFieldsOfType') {
            //var fieldType = typeMap.fromDartType(methodPartElement.parameters.last.type, context:typeArgumentsMap());
            if (!typeMap.compiledMethodsByType.containsKey(methodElement)) {
              typeMap.compiledMethodsByType[methodElement] = {};
              lines.add('//dbg: ${methodElement.name!}');
            }

            //iterated trough fields with parent first to generate parent bits first and then subclasses bits.
            for (var field in allFields(parentFirst: true)) {
              var compiledPart = await CompiledFieldMethodPart.addFieldMethodPart(this, methodElement, methodPartElement, field, 'dis');
              if (compiledPart != null && !calledParts.contains(compiledPart)) {
                lines.add(compiledPart.getCallExpression('this'));
                calledParts.add(compiledPart);
              }
            }
            for (var plugin in plugins) {
              for (var field in plugin.allFields()) {
                var compiledPart = await CompiledFieldMethodPart.addFieldMethodPart(this, methodElement, methodPartElement, field, 'dis.decorated');
                if (compiledPart != null && !calledParts.contains(compiledPart)) {
                  lines.add(compiledPart.getCallExpression('this.${plugin.varName}'));
                  calledParts.add(compiledPart);
                }
              }
            }
          }
        }
      }
      //lines.add(methodElement.computeNode().body.toSource());
    } else {
      //check if method has any plugins
      Map<MethodElement, TypeInfo> beforePlugins = {};
      Map<MethodElement, TypeInfo> afterPlugins = {};
      for (var p in plugins) {
        p.allMethods().forEach((pluginMethodElement) {
          if (elementInjectionType(pluginMethodElement) == '@MethodPlugin') {
            if (pluginMethodElement.name == "before${methodElement.name!.substring(0, 1).toUpperCase()}${methodElement.name!.substring(1)}") {
              beforePlugins[pluginMethodElement] = p;
            } else if (pluginMethodElement.name == "after${methodElement.name!.substring(0, 1).toUpperCase()}${methodElement.name!.substring(1)}") {
              afterPlugins[pluginMethodElement] = p;
            }
          }
        });
      }

      String paramsStr = methodElement.firstFragment.formalParameters.map((mp) => mp.name).join(",");
      String beforeArgsStr = '';
      if (beforePlugins.isNotEmpty) {
        lines.add('List<dynamic> args = [$paramsStr];');
        int i = 0;
        beforeArgsStr = methodElement.firstFragment.formalParameters.map((mp) => "args[${i++}]").join(',');
      }
      for (var pluginMethod in beforePlugins.keys) {
        String pluginName = beforePlugins[pluginMethod]!.varName;
        lines.add('args = ${pluginMethod.firstFragment.isAsynchronous ? 'await' : ''} $pluginName.${pluginMethod.name}($beforeArgsStr);');
      }
      if (beforePlugins.isNotEmpty) {
        int i = 0;
        for (var mp in methodElement.firstFragment.formalParameters) {
          lines.add('${mp.name} = args[$i];');
          i++;
        }
      }
      bool isVoid = (methodElement.returnType is VoidType) || (methodElement.returnType.getDisplayString() == 'Future<void>');
      if (beforePlugins.length + afterPlugins.length > 0) {
        lines.add('${!isVoid ? 'var ret = ' : ''}${methodElement.firstFragment.isAsynchronous ? 'await ' : ''}super.${methodElement.name}($paramsStr);');
      }
      for (var pluginMethod in afterPlugins.keys) {
        String pluginName = afterPlugins[pluginMethod]!.varName;
        //add params to after plugin, TODO: validate if names match original method params
        List<String> params = pluginMethod.firstFragment.formalParameters.map((mp) => mp.name!).toList();
        if (!isVoid) {
          params.first = 'ret';
        }
        lines.add(
          '${!isVoid ? 'ret = ' : ''}${pluginMethod.firstFragment.isAsynchronous ? 'await ' : ''}$pluginName.${pluginMethod.name}(${params.join(',')});',
        );
      }
      if (!isVoid && (beforePlugins.length + afterPlugins.length > 0)) {
        lines.add('return ret;');
      }
    }
    return lines;
  }
}

class SubtypeFactoryInfo {
  TypeInfo returnType;
  Map<String, TypeInfo> arguments;
  SubtypeFactoryInfo(this.returnType, this.arguments);
}

/// used to generate static method cfs_ with field logic per class
class CompiledFieldMethodPart {
  MethodElement methodElement;
  TypeInfo type;
  TypeMap typeMap;
  Map<FieldElement, Map<MethodElement, List<String>>> stubs = {};
  CompiledFieldMethodPart(this.typeMap, this.methodElement, this.type);

  String get methodName => 'cfs_${methodElement.name!}${type.flatName}';

  String getPartDeclaration() {
    List<String> params = [];
    params.add("${type.fullName} dis");
    params.addAll(
      methodElement.firstFragment.formalParameters.map((mp) {
        TypeInfo parameterType = typeMap.fromDartType(mp.element.type);
        return "${parameterType.uniqueName} ${mp.name}";
      }),
    );
    if (methodElement.returnType.isDartAsyncFuture) {
      return 'Future<void> $methodName(${params.join(",")}) async';
    }
    return 'void $methodName(${params.join(",")})';
  }

  String getCallExpression(String thisName) {
    List<String> params = [thisName];
    params.addAll(methodElement.firstFragment.formalParameters.map((mp) => mp.name!));
    if (methodElement.returnType.isDartAsyncFuture) {
      return 'await $methodName(${params.join(",")});';
    }
    return '$methodName(${params.join(",")});';
  }

  /// analyse fieldMethodPart if fits compiledMethod
  static Future<CompiledFieldMethodPart?> addFieldMethodPart(
    TypeInfo type,
    MethodElement compiledMethod,
    MethodElement fieldMethodPart,
    FieldElement field,
    String thisReplace,
  ) async {
    FormalParameterFragment fieldParameter = fieldMethodPart.firstFragment.formalParameters.where((element) => element.name == 'field').first;

    if (!type.typeMap.typeSystem.isSubtypeOf(field.type, fieldParameter.element.type) ||
        //dynamic is nullable but returns empty suffix
        !(fieldParameter.element.type is DynamicType || field.type.nullabilitySuffix == fieldParameter.element.type.nullabilitySuffix)) {
      return null;
    }

    String? requireAnnotation;
    for (var m in fieldMethodPart.metadata.annotations) {
      if (m.toSource().startsWith('@AnnotatedWith(')) {
        requireAnnotation = '@${m.toSource().substring(15, m.toSource().length - 1)}';
      }
    }

    if (requireAnnotation != null) {
      bool pass = false;
      for (var m in field.metadata.annotations) {
        //support for parametrised required annotations
        if (m.toSource() == requireAnnotation || m.toSource().startsWith('$requireAnnotation(')) pass = true;
      }
      if (!pass) return null;
    }

    var enclosingType = (field.enclosingElement is ClassElement)
        ? type.typeMap.fromDartType((field.enclosingElement as ClassElement).thisType, context: type.typeArgumentsMap())
        : (field.enclosingElement is MixinElement)
        ? type.typeMap.fromDartType((field.enclosingElement as MixinElement).thisType, context: type.typeArgumentsMap())
        : null;

    if (enclosingType == null) {
      return null;
    }
    CompiledFieldMethodPart compiledPart;
    if (!type.typeMap.compiledMethodsByType[compiledMethod]!.containsKey(enclosingType.uniqueName)) {
      type.typeMap.compiledMethodsByType[compiledMethod]![enclosingType.uniqueName] = compiledPart = CompiledFieldMethodPart(
        type.typeMap,
        compiledMethod,
        enclosingType,
      );
    } else {
      compiledPart = type.typeMap.compiledMethodsByType[compiledMethod]![enclosingType.uniqueName]!;
    }

    if (!compiledPart.stubs.containsKey(field) || !compiledPart.stubs[field]!.containsKey(fieldMethodPart)) {
      //generate stub;
      if (!compiledPart.stubs.containsKey(field)) {
        compiledPart.stubs[field] = {};
      }
      List<String> stubLines = compiledPart.stubs[field]![fieldMethodPart] = [];

      var compiledFieldType = type.typeMap.fromDartType(field.type, context: type.typeArgumentsMap());

      stubLines.add('{');
      //magic parameter match
      for (var methodParameter in fieldMethodPart.firstFragment.formalParameters) {
        if (compiledMethod.firstFragment.formalParameters.where((element) => element.name == methodParameter.name).isNotEmpty) {
          //this parameter comes from compiled method
          continue;
        }
        if (methodParameter.name == fieldParameter.name) {
          //this is a special param
          continue;
        }
        var methodParameterValue = 'null';
        //var methodParameterType = methodParameter.type.toString();
        if (methodParameter.name == 'name') {
          methodParameterValue = '"${field.name}"';
        } else if (methodParameter.name == 'className') {
          methodParameterValue = '"${compiledFieldType.uniqueName}"';
        } else if (fieldParameter.element.type.isDartCoreEnum && methodParameter.name == 'values') {
          methodParameterValue = '${compiledFieldType.uniqueName}.values';
        } else if (methodParameter.element.isOptional) {
          methodParameterValue = methodParameter.element.defaultValueCode ?? 'null';
          var nameParts = methodParameter.name!.split('_');
          String annotationName = '@${nameParts[0][0].toUpperCase()}${nameParts[0].substring(1)}';
          if (nameParts.length == 1) {
            methodParameterValue = 'false';
            for (var fieldMeta in field.metadata.annotations) {
              if (fieldMeta.toSource() == annotationName) {
                methodParameterValue = 'true';
              }
            }
          } else {
            for (var fieldMeta in field.metadata.annotations) {
              if (fieldMeta.toSource().startsWith('$annotationName(') || fieldMeta.toSource().startsWith('$annotationName.t(')) {
                var constantValue = fieldMeta.computeConstantValue();
                if (constantValue == null) {
                  methodParameterValue = '"COMPUTATION ERROR"';
                  break;
                }
                DartObject annotationField = constantValue.getField(nameParts[1])!;
                var annotationValue = annotationField.type!.getDisplayString();
                switch (annotationValue) {
                  case 'Type':
                    //allow passing type as annotation
                    String typeName = fieldMeta.toSource();
                    typeName = typeName.substring(typeName.indexOf('(') + 1, typeName.indexOf(')'));
                    if (compiledPart.typeMap.allTypes.containsKey(typeName)) {
                      methodParameterValue = compiledPart.typeMap.generateTypeGetter(compiledPart.typeMap.allTypes[typeName]!);
                    } else {
                      methodParameterValue = "null";
                    }
                    break;
                  case 'String':
                    //todo toDartVariable?
                    methodParameterValue = '"${annotationField.toStringValue()!.replaceAll('\$', '\\\$').replaceAll('"', '\\"')}"';
                    break;
                  case 'int':
                    methodParameterValue = annotationField.toIntValue().toString();
                    break;
                  default:
                    methodParameterValue = annotationField.toString();
                }
              }
            }
          }
        }
        if (methodParameterValue.startsWith('\$')) {
          stubLines.add('var ${methodParameter.name} = $methodParameterValue;');
        } else {
          stubLines.add('const ${methodParameter.name} = $methodParameterValue;');
        }
      }
      String part = await fieldMethodPart.getSourceCode(type.typeMap.step);

      if (fieldMethodPart.firstFragment.formalParameters.indexWhere((element) => element.name == 'field') > -1) {
        part = part.replaceAll(fieldParameter.name!, 'dis.${field.name}');
      }
      //TODO
      part = part.replaceAll('this', thisReplace);

      String paramClass = fieldParameter.element.type.getDisplayString();
      String fieldClass = compiledFieldType.uniqueName;
      part = part.replaceAll('as $paramClass', 'as $fieldClass');
      if (paramClass.contains('<') && fieldClass.contains('<')) {
        //TODO support many parameters?
        String paramGenericParam = paramClass.substring(paramClass.indexOf('<') + 1, paramClass.length - 1);
        String fieldGenericParam = fieldClass.substring(fieldClass.indexOf('<') + 1, fieldClass.length - 1);
        part = part.replaceAll('as $paramGenericParam', 'as $fieldGenericParam');
      }
      //part = "// ${paramClass} \n" + part;
      //part = "// ${fieldClass} \n" + part;
      stubLines.add(part);
      stubLines.add('}');
    }
    return compiledPart;
  }
}

class TypeMap {
  TypeSystem typeSystem;
  OutputWriter output;
  DiConfig config;
  BuildStep step;
  //Map<LibraryElement, String?> importedLibrariesMap = {};
  TypeMap(this.output, this.typeSystem, this.step, this.config);

  List<String> allSymbols = [];

  Map<String, TypeInfo> allTypes = {};
  Map<String, TypeInfo> subtypeInstanes = {};
  Map<String, TypeInfo> subtypesOf = {};
  Map<String, SubtypeFactoryInfo> subtypeFactories = {};

  Map<InterfaceElement, String> classNames = {};

  //indexed by compiled method and part declaring class name
  Map<MethodElement, Map<String, CompiledFieldMethodPart>> compiledMethodsByType = {};

  ///
  void registerClassElement(String fullName, Element element) async {
    if (element is InterfaceElement) {
      if (!classNames.containsKey(element)) {
        classNames[element] = fullName;
        TypeInfo elementType = TypeInfo(this, element.thisType, config);
        output.writeLn('//register: ${elementType.uniqueName}');

        allTypes[fullName] = elementType;
      } else if (fullName != classNames[element]) {
        // with new coding standard, module name is not always available (and cen differ from import prefix anyway)
        // var path = element.firstFragment.libraryFragment.element.name; // element.declaration.librarySource!.fullName.split('/');
        // in case of modules using (but not requiring) other modules, please use ComposeIfModule
        //output.writeLn('//$fullName');
        //output.writeLn('//${classNames[element]}');
        /*
        String? realModuleName = path.length > 1 ? path.elementAt(1) : null;
        String importModuleName = fullName.split('.').first;
        if (realModuleName == importModuleName) {
          // replace class info with proper namespace
          allTypes[fullName] = allTypes[classNames[element]!]!;
          allTypes.remove(classNames[element]!);
          classNames[element] = fullName;
        }*/
      }
    }
  }

  TypeInfo fromDartType(DartType type, {Map<TypeParameterElement, DartType> context = const {}}) {
    List<TypeInfo> typeArguments = [];
    if (type is ParameterizedType) {
      for (var arg in type.typeArguments) {
        typeArguments.add(fromDartType(arg, context: context));
      }
    }

    context.forEach((key, value) {
      //key.instantiate(nullabilitySuffix: NullabilitySuffix.none).bound.name!;
      /*output.writeLn(
        "//BOUND OF " + key.name + " " + key.instantiate(nullabilitySuffix: NullabilitySuffix.none).bound.name!
      );*/
      if (key.hashCode == type.hashCode) {
        type = value;
      }
    });

    /*String name = type.getDisplayString(withNullability: false);
    if (type.element != null) {
      if (classNames.containsKey(type.element)) {
        name = classNames[type.element]!;
      }
    }*/
    //output.writeLn('//!!!!' + type.getDisplayString() + ' <=> ' + (type.element == null ? 'NULL' : type.element!.name!));

    TypeInfo ret = TypeInfo(this, type, config, typeArguments: typeArguments);

    if (!allTypes.containsKey(ret.uniqueName)) {
      allTypes[ret.uniqueName] = ret;
    }
    return allTypes[ret.uniqueName]!;

    /*
    if (type is ParameterizedType) {
      for (DartType def in typeMap.allTypesByType.keys) {
        if (def is ParameterizedType) {
          if (def.typeArguments.length == type.typeArguments.length) {

            //DartType instantiated = def.instantiate(type.typeArguments);
            DartType instantiated = (def.element as ClassElement).instantiate(typeArguments: type.typeArguments, nullabilitySuffix: NullabilitySuffix.none);
            if (instantiated == type) {
              fullName = typeMap.allTypesByType[def].fullName;
            }
          }
        }
      }
    }

    //resolveToBound <<
    if (type.getDisplayString(withNullability: false).endsWith('>')) {
      for (var arg in (type as ParameterizedType).typeArguments) {
        typeArguments.add(this.fromDartType(arg, context));
      }
    }
    //}
  */
    /*TypeInfo.fromType(this.omGenerator, this.typeMap, DartType type, ) {

      fullName = type.name!;
     if (typeArgumentsMap.containsKey(type)) {
      this.type = type = typeArgumentsMap[type];
    } else {
      this.type = type;
    }
      if (typeMap.allTypesByType.containsKey(type)) {
        fullName = typeMap.allTypesByType[type]!.fullName;
        element = typeMap.allTypesByType[type]!.element;
      }
      if (type is TypeParameterType) {
      for (DartType def in typeMap.allTypesByType.keys) {
        if (def is TypeParameterType) {
          //DartType instantiated = def.instantiate(type.typeArguments);
          DartType instantiated = def.element.instantiate(nullabilitySuffix: type.nullabilitySuffix);
          if (instantiated == type) {
            fullName = typeMap.allTypesByType[def].fullName;
          }
        }
      }
    }
    */
    //return ret;
  }

  TypeInfo getBestCandidate(TypeInfo type) {
    List<TypeInfo> candidates = getNonAbstractSubtypes(type);

    candidates.sort((t1, t2) => typeSystem.isSubtypeOf(t1.type, t2.type) ? 1 : 0);

    if (candidates.length > 1) {
      //throw new Exception('too many ${type.displayName}');
    }
    if (candidates.isEmpty) {
      throw Exception('no initialisation candidate for ${type.fullName}');
    }
    return candidates[0];
  }

  String generateTypeGetter(TypeInfo type) {
    TypeInfo candidate = getBestCandidate(type);
    String getterName = candidate.varName;
    return '\$om.$getterName';
  }

  List<TypeInfo> getPluginsForType(TypeInfo type) {
    List<TypeInfo> plugins = [];

    allTypes.forEach((name, ce) {
      if (ce.element != null) {
        for (var st in ce.element!.allSupertypes) {
          if (st.getDisplayString().startsWith('TypePlugin<') && st.typeArguments.length == 1) {
            if (st.typeArguments[0] is! InvalidType && typeSystem.isAssignableTo(type.type, st.typeArguments[0])) {
              plugins.add(ce);
            }
          }
        }
      }
    });
    return plugins;
  }

  List<TypeInfo> getSubtypes(TypeInfo parentType, bool includeAbstract) {
    return allTypes.values.where((type) {
      //output.writeLn("//candidate: " + type.displayName);
      if (type.element == null) return false;
      //output.writeLn("//element ok");

      if (!includeAbstract) {
        for (var metadataElement in (type.element as ClassElement).metadata.annotations) {
          if (metadataElement.toSource() == '@ComposeSubtypes') {
            return false;
          }
        }
      }

      if (type.uniqueName == parentType.uniqueName) {
        return true;
      }
      //output.writeLn("//name not fit");
      if (!includeAbstract && (!type.hasInterceptor() && type.element!.isAbstract)) return false;
      //output.writeLn("//interceptor ok");
      bool fits = false;

      for (var st in type.element!.allSupertypes) {
        bool parentFits = true;
        //isSubtype = isSubtype || i.displayName == parentType.displayName;
        //TODO: add results to debug info, fix in tests
        String stName = st.getDisplayString();
        if (stName.contains('<')) stName = stName.substring(0, stName.indexOf('<'));
        String parentTypeName = parentType.type.getDisplayString();
        if (parentTypeName.contains('<')) parentTypeName = parentTypeName.substring(0, parentTypeName.indexOf('<'));
        parentFits = parentFits & (stName == parentTypeName);
        if (parentType.typeArguments.length == st.typeArguments.length) {
          for (var i = 0; i < parentType.typeArguments.length; i++) {
            parentFits =
                parentFits &&
                ((parentType.typeArguments[i].type.getDisplayString() == st.typeArguments[i].getDisplayString())
                    //|| typeSystem.isSubtypeOf(parentType.typeArguments[i].type, st.typeArguments[i])  //TODO ????? maybe both? or maybe for separate usage case? (ImplementationsOf)
                    ||
                    typeSystem.isSubtypeOf(st.typeArguments[i], parentType.typeArguments[i].type)); //
            //parentFits = parentFits & st.typeArguments[i].isAssignableTo(parentType.arguments[i].type);
          }
        } else {
          parentFits = false;
        }
        fits = fits | parentFits;
      }
      return fits;
    }).toList();
  }

  List<TypeInfo> getAllSubtypes(TypeInfo parentType) {
    return getSubtypes(parentType, true);
  }

  List<TypeInfo> getNonAbstractSubtypes(TypeInfo parentType) {
    return getSubtypes(parentType, false);
  }
}
