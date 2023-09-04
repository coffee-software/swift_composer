library swift_composer;

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
    if (sourcesCache.containsKey(this.hashCode)) {
      return sourcesCache[this.hashCode]!;
    }
    String part = '';
    try {
      // TODO: https://github.com/dart-lang/build/issues/2634
      // find better way to get method source?
      ParsedLibraryResult result = this.session!.getParsedLibraryByElement(this.library) as ParsedLibraryResult;
      part = result.getElementDeclaration(this)!.node.toSource();
    } on InconsistentAnalysisException {
      var resolver = await step.resolver;
      ResolvedLibraryResult result = await _getResolvedLibrary(this.library, resolver);
      part = result.getElementDeclaration(this)!.node.toSource();
    }
    //named parameters can be defined
    part = part.substring(part.indexOf(') {') + 3, part.length - 1);
    sourcesCache[this.hashCode] = part;
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
    if (_plugins == null) {
      _plugins = typeMap.getPluginsForType(this);
    }
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
    if ((this.type.element != null) && (this.typeMap.classNames.containsKey(this.type.element))) {
      return this.typeMap.classNames[this.type.element]!;
    } else {
      //TODO: validate if core?
      var name = this.type.getDisplayString(withNullability: false);
      if (name.indexOf('<') > -1) {
        return name.substring(0, name.indexOf('<'));
      }
      return name;
    }
  }

  String get uniqueName {
    return fullName + (typeArguments.isNotEmpty ? '<${typeArguments.map((e)=>e.uniqueName).join(',')}>' : '') + (isNullable ? '?' : '');
    //':' + type.getDisplayString(withNullability: true)
    //':' + ((type is ParameterizedType) ? (type as ParameterizedType).typeArguments.map((e) => e.getDisplayString(withNullability: true)).join(',') : 'NP') +
  }

  String get debugInfo {
    return uniqueName + ' ' + (hasInterceptor() ? 'INTERCEPTED' : '') +  ' ' + (isGeneric() ? 'GENERIC' : '') + ' [' +
    typeArgumentsMap().map((key, value) => MapEntry(key.name, key.name + ' = ' + value.getDisplayString(withNullability: true))).values.join(',')
      + '   ' +
    typeArgumentsMap().map((key, value) => MapEntry(key.name, key.hashCode.toString() + ' = ' + value.hashCode.toString())).values.join(',')
        + '   ' +
        typeArgumentsMap().map((key, value) => MapEntry(key.name, key.hashCode.toString() + ' = ' + value.runtimeType.toString())).values.join(',')
        + ']';
  }

  String get varName {
    return '${flatName[0].toLowerCase()}${flatName.substring(1)}';
  }

  String get flatName {
    return '${fullName.replaceAll('.', '_')}' + (typeArguments.isNotEmpty ? '_${typeArguments.map((e)=>e.flatName).join('_')}_' : '');
  }

  bool isGeneric() {
      return element != null && (typeArguments.length == 0) && (element!.typeParameters.length > 0);
  }

  Map get typeConfig {
    Map<dynamic, dynamic> classConfig = {};
    int test = 1;
    //List<TypeInfo> path = allTypeInfoPath().toList();
    for (var type in allTypeInfoPath()){
      classConfig[type.fullName] = test++;
      if (config.config.containsKey(type.fullName)){
        for ( var k in config.config[type.fullName].keys) {
          if (!classConfig.containsKey(k)) {
            classConfig[k] = config.config[type.fullName][k];
          }
        }
      }
    }
    return classConfig;
  }

  String get creatorName => hasInterceptor() ? '\$' + flatName : fullName;

  String generateCompiledConstructorDefinition() {
    return '\$${flatName}' + '(' + allRequiredFields().map((f) => f.name).join(',') + ') {\n';
  }

  Iterable<FieldElement> allRequiredFields() {
    return allFields().where((f) => elementInjectionType(f) == '@Require');
  }

  String generateCreator() {
    String constructor = creatorName;
    if (fullName == 'List') {
      constructor += '.empty';
    }
    return 'new ${constructor}(' + allRequiredFields().map((f) => f.name).join(',') + ')';
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
    for (var metadataElement in element.metadata) {
      if (decorators.contains(metadataElement.toSource())) {
        return metadataElement.toSource();
      }
    }
    return null;
  }

  String? getFieldInitializationValue(TypeInfo fieldType, FieldElement field) {
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
              throw new Exception(
                  "missing config value for non nullable field ${fieldType
                      .fullName} ${field.name}");
            }
            return 'null';
          } else {
            return null;
          }
        }
        switch (fieldType.fullName){
          case "String":
            return '"' + typeConfig[field.name].replaceAll('"', '\\"').replaceAll('\n', '\\n') + '"';
          case "int":
          case "double":
          case "bool":
            return typeConfig[field.name].toString();
          default:
            return 'new ' + fieldType.fullName + '.fromString("' + typeConfig[field.name] + '")';
        }
      case '@InjectInstances':
        TypeInfo type = fieldType.typeArguments[1];
        typeMap.subtypeInstanes[type.uniqueName] = type;
        return '\$om.instancesOf${type.flatName}';
      case '@InjectClassName':
        return classCodeAsReference;
      case '@InjectClassNames':
        List<String> path = [];
        for (var type in allTypeInfoPath()){
          if (field.enclosingElement == type.element) break;
          path.add(type.classCodeAsReference);
        }
        return '[' + path.reversed.join(',') + ']';
      default:
        return null;
    }
  }

  String? getFieldAssignmentValue(FieldElement field) {

    TypeInfo fieldType = typeMap.fromDartType(field.type, context:typeArgumentsMap());

    switch (elementInjectionType(field)) {
      case '@Require':
        return field.name;
      case '@InjectFields':
        String args = allFields().where((f) => f.type.getDisplayString(withNullability: true) != 'dynamic').map((e) => '\'${e.name}\':this.${e.name}').join(',');
        return 'new ${fieldType.type.getDisplayString(withNullability: true)}({${args}});\n';
    }
    return null;
  }

  Iterable<TypeInfo> allTypeInfoPath() sync* {
    for (var element in allClassElementsPath()) {
      yield typeMap.fromDartType(element.thisType, context:typeArgumentsMap());
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
    if (allRequiredFields().length > 0) {
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

    bool? ret = null;
    if (element != null) {
      for (var c in allClassElementsPath()) {
        for (var metadataElement in c.metadata) {
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

  List<FieldElement> allFields() {
    List<FieldElement> allFields = [];
    for (var element in allClassElementsPath()) {
      for (var m in element.mixins) {
        for (var f in m.element.fields) {
          if (!f.name.startsWith('_'))
            allFields.add(f);
        }
      }
      for (var f in element.fields) {
        if (!f.name.startsWith('_'))
          allFields.add(f);
      }
    }
    return allFields;
  }

  List<MethodElement> allMethods() {
    List<MethodElement> allMethods = [];
    List<String> overrides = [];
    for (var element in allClassElementsPath()) {
      for (var method in element.methods) {
        //if (!m.name.startsWith('_'))
        if (!overrides.contains(method.name)) {
          allMethods.add(method);
          overrides.add(method.name);
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

      s.element.typeParameters.forEach((tp) {
        ret[tp] = s.typeArguments[j++];
      });
    }
    var j = 0;
    element!.typeParameters.forEach((tp){
      ret[tp] = (type as ParameterizedType).typeArguments[j++];
    });
    return ret;
  }

  Future<void> preAnaliseAllUsedTypes() async {
    element?.interfaces.forEach((interface) {
      typeMap.fromDartType(interface, context: typeArgumentsMap());
    });
    element?.allSupertypes.forEach((superType) {
      typeMap.fromDartType(superType, context: typeArgumentsMap());
    });
    allFields().forEach((fieldElement){
      typeMap.fromDartType(fieldElement.type, context: typeArgumentsMap());
    });
    allMethods().forEach((methodElement) {
      methodElement.typeParameters.forEach((typeParameterElement) {
        if (typeParameterElement.bound != null) {
          this.typeMap.fromDartType(typeParameterElement.bound!, context:this.typeArgumentsMap());
        }
      });
      methodElement.parameters.map((parameterElement){
        typeMap.fromDartType(parameterElement.type, context:typeArgumentsMap());
      });
      typeMap.fromDartType(methodElement.returnType, context:typeArgumentsMap());
    });
  }

  Future<void> writeDebugInfo(OutputWriter output) async {

    output.writeLn("// type arguments[1]:");
    for (var k in typeArgumentsMap().keys) {
      output.writeLn("// ${k.getDisplayString(withNullability: true)}[${k.hashCode.toString()}] => ${typeArgumentsMap()[k]!.getDisplayString(withNullability: true)}[${typeArgumentsMap()[k].hashCode.toString()}]");
    }

    output.writeLn("// type arguments[2]:");
    for (var k in typeArguments) {
      output.writeLn("// ENCLOSING: " + (k.element != null ? (k.element!.enclosingElement.name ?? "XXX") : "NULL"));
      output.writeLn("// ${k.type.getDisplayString(withNullability: true)}[${k.hashCode.toString()}]");
    }

    if (element != null) {
      output.writeLn(
          "// can be singleton: ${canBeSingleton() ? 'TRUE' : 'FALSE'}");
      element!.typeParameters.forEach((element) {
        output.writeLn(
            "// parameter: ${element.name} ${element.hashCode.toString()}");
        //lines.add("//parameter: ${element.bound == null ? "NULL" : element.bound.name}");
        //lines.add("//parameter: ${element.instantiate(nullabilitySuffix: NullabilitySuffix.none).element.name}");
      });
      element!.thisType.typeArguments.forEach((element) {
        output.writeLn(
            "// argument: ${element.getDisplayString(withNullability: true)} ${element.hashCode.toString()}");
      });

      for (var s in element!.allSupertypes) {
        output.writeLn("// parent: ${s.element.displayName} ${s.element.metadata
            .toString()}");
        s.element.typeParameters.forEach((element) {
          output.writeLn(
              "// parameter: ${element.name} ${element.hashCode.toString()}");
          //lines.add("//parameter: ${element.bound == null ? "NULL" : element.bound.name}");
          //lines.add("//parameter: ${element.instantiate(nullabilitySuffix: NullabilitySuffix.none).element.name}");
        });
        s.typeArguments.forEach((element) {
          output.writeLn(
              "// argument: ${element.getDisplayString(withNullability: true)} ${element.hashCode.toString()}");
        });
      }
      //lines.add("//config: ${json.encode(typeConfig)}");

      for (var p in plugins) {
        output.writeLn("// plugin: ${p.fullName}");
      }


      output.writeLn("// CONFIG");
      typeConfig.forEach((key, value) {
        output.writeLn("// config: ${key} ${value}");
      });
      output.writeLn("// TYPE PATH:");
      for (var type in this.allTypeInfoPath()) {
        output.writeLn("//  " + type.fullName);
      }
    }
  }

  Future<void> generateInterceptor(OutputWriter output, TemplateLoader templateLoader) async {


    if (typeArguments.length > 0) {
      String parent = '\$${fullName.replaceAll('.', '_')}' + '<${typeArguments.map((e)=>e.creatorName).join(',')}>';
      parent = uniqueName;
      output.writeLn('//parametrized type');
      output.writeLn(
          'class \$$flatName extends $parent implements Pluggable {');
    } else {

      var typeArgsList = element!.typeParameters.map((e) {
        return e.name + (e.bound != null ? " extends " + (this.typeMap.fromDartType(e.bound!, context:this.typeArgumentsMap())).fullName : '');
      }).join(',');
      var typeArgs = element!.typeParameters.isNotEmpty ? "<" + typeArgsList + ">" : '';

      var shortArgs = element!.typeParameters.isNotEmpty ? "<${element!.typeParameters.map((e) => e.name).join(',')}>" : '';

      var abstract = element!.typeParameters.isNotEmpty ? 'abstract ' : '';
      output.writeLn(
          '${abstract}class \$$flatName$typeArgs extends $fullName$shortArgs implements Pluggable {');
      if (element!.typeParameters.isNotEmpty) {
        output.writeLn('}');
        return;
      }
    }

    for (var p in plugins) {
      output.writeLn('late ${p.fullName} ${p.varName};');
    }

    output.writeLn(generateCompiledConstructorDefinition());


    allFields().forEach((fieldElement){
      if (fieldElement.setter != null) {
        //output.writeLn("//${fieldElement.type.getDisplayString(withNullability: true)}");

        if (elementInjectionType(fieldElement) == '@Create') {
          //TMP
          TypeInfo ti = typeMap.fromDartType(fieldElement.type, context:typeArgumentsMap());
          output.writeLn("//" + ti.uniqueName, debug:true);
          typeMap.getNonAbstractSubtypes(ti).forEach((element) {
            output.writeLn("// c: ${element.uniqueName}", debug:true);
          });

          TypeInfo candidate = typeMap.getBestCandidate(ti);
          output.writeLn('this.${fieldElement.name} = ' + candidate.generateCreator() + ';');
        } else {
          String? value = getFieldAssignmentValue(fieldElement);
          if (value != null) {
            output.writeLn(
                'this.${fieldElement.name} = ' + value + ';'
            );
          }
        }
      }
    });

    for (var p in plugins) {
      output.writeLn(
          "${p.varName} = new ${p.creatorName}(this);"
      );
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

    allFields().forEach((fieldElement){
      //fieldElement.type
      //ClassElement

      /*lines.add('//ELEMENT:' + fieldElement.getDisplayString(withNullability: true));
        var t = fieldElement.type;
        if (this.type is ParameterizedType) {
          lines.add('//TYPE is ParameterizedType');
          (this.type as ParameterizedType).typeArguments.forEach((element) {
            lines.add('//typeArguments[]:' + element.getDisplayString(withNullability: true));
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
            lines.add('//typeArguments[]:' + element.getDisplayString(withNullability: true));
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
      TypeInfo fieldType = typeMap.fromDartType(fieldElement.type, context:typeArgumentsMap());


      //fieldElement.type.isDartAsyncFutureOr
      //output.writeLn("// ${fieldType.uniqueName} ${fieldElement.name}");
      String? value = getFieldInitializationValue(fieldType, fieldElement);
      if (value != null) {
        output.writeLn(
            "${fieldType.uniqueName} get ${fieldElement.name} => ${value};"
        );
      }
    });

    for (var methodElement in allMethods()) {
      List<String> methodLines = await generateMethodOverride(methodElement);
      if (methodLines.length > 0) {
        output.writeLn('//method ${methodElement.name} override');
        TypeInfo returnType = typeMap.fromDartType(methodElement.returnType, context:typeArgumentsMap());
        var typeArgsList = methodElement.typeParameters.map((e) {
          return e.name + (e.bound != null ? " extends " + (this.typeMap.fromDartType(e.bound!, context:this.typeArgumentsMap())).fullName : '');
        }).join(',');
        var typeArgs = typeArgsList.isNotEmpty ? "<" + typeArgsList + ">" : '';

        output.writeLn("${returnType.uniqueName} ${methodElement.name}${typeArgs}(");
        output.writeLn(methodElement.parameters.map((mp){
          TypeInfo parameterType = typeMap.fromDartType(mp.type, context:typeArgumentsMap());
          return "${parameterType.uniqueName} ${mp.name}";
        }).join(","));

        output.writeLn("){");
        output.writeMany(methodLines);
        output.writeLn("}");
      }
    }

    //generted template methods
    for (var fieldElement in allFields()) {
      for (var metadataElement in fieldElement.getter!.metadata) {
        if (metadataElement.toSource() == '@Template') {
          String? templateBody = templateLoader.load(flatName + '.' + fieldElement.name);
          if (templateBody != null) {
            output.writeLn("${fieldElement.type.toString()} get ${fieldElement.name} => \'\'\'");
            output.writeLn(templateBody);
            output.writeLn("\'\'\';");
          }
        }
      }
    };

    output.writeLn('}');
  }

  Future<List<String>> generateMethodOverride(MethodElement methodElement) async {
    TypeInfo returnType = typeMap.fromDartType(methodElement.returnType, context:typeArgumentsMap());
    List<String> lines = [];

    if (elementInjectionType(methodElement) == '@SubtypeFactory') {
      if ((methodElement.parameters[0].name != 'className') ||
          (methodElement.parameters[0].type.getDisplayString(withNullability: true) != 'String')) {
        throw new Exception('SubtypeFactory first argument needs to be named className and be of type String');
      }
      List<String> argsDef = [];
      List<String> argsInv = [];
      Map<String, TypeInfo> arguments = {};
      for (var p in methodElement.parameters) {
        TypeInfo argType = typeMap.fromDartType(p.type, context:typeArgumentsMap());
        argsDef.add(
            argType.uniqueName
            + ' ' +
          p.name);
        argsInv.add(p.name);
        arguments[p.name] = argType;
      }
      String factoryInv = 'createSubtypeOf' + returnType.flatName + argsInv.length.toString() + '(' + argsInv.join(',') + ')';
      String factoryDef = 'createSubtypeOf' + returnType.flatName + argsInv.length.toString() + '(' + argsDef.join(',') + ')';

      if (!typeMap.subtypeFactories.containsKey(factoryDef)) {
        typeMap.subtypeFactories[factoryDef] = new SubtypeFactoryInfo(returnType, arguments);
      }
      lines.add('return \$om.' + factoryInv + ';');

    } else if (elementInjectionType(methodElement) == '@Factory') {
      var best = typeMap.getBestCandidate(returnType);
      lines.add('//' + returnType.fullName);
      lines.add('return ' + best.generateCreator() + ';');
    } else if (elementInjectionType(methodElement) == '@Compile') {
      lines.add('//compiled method');
      //TODO: add original method if not abstract ??
      List<CompiledFieldMethodPart> calledParts = [];
      for (var methodPartElement in allMethods()) {
        if (methodPartElement.name.startsWith('_' + methodElement.name)) {
          if (elementInjectionType(methodPartElement) == '@CompilePart') {
            String part = await methodPartElement.getSourceCode(this.typeMap.step);
            lines.add(part);
          } else if (elementInjectionType(methodPartElement) == '@CompileFieldsOfType') {

            //var fieldType = typeMap.fromDartType(methodPartElement.parameters.last.type, context:typeArgumentsMap());
            if (!typeMap.compiledMethodsByType.containsKey(methodElement)) {
              typeMap.compiledMethodsByType[methodElement] = {};
              lines.add('//dbg: ' + methodElement.name);
            }



            for (var field in allFields()) {
              var compiledPart = await CompiledFieldMethodPart.addFieldMethodPart(this, methodElement, methodPartElement, field, 'dis');
              if (compiledPart != null && !calledParts.contains(compiledPart)) {
                lines.add(compiledPart.getCallExpression('this'));
                calledParts.add(compiledPart);
              }
            }
            for (var plugin in plugins) {
              for (var field in plugin.allFields()) {
                var compiledPart = await CompiledFieldMethodPart.addFieldMethodPart(this, methodElement, methodPartElement, field, 'dis.parent');
                if (compiledPart != null && !calledParts.contains(compiledPart)) {
                  lines.add(compiledPart.getCallExpression('this.${plugin.varName}'));
                  calledParts.add(compiledPart);
                }
              }
            }
          };
        };
      }
      //lines.add(methodElement.computeNode().body.toSource());
    } else {
      //check if method has any plugins

      Map<MethodElement, TypeInfo> beforePlugins = {};
      Map<MethodElement, TypeInfo> afterPlugins = {};
      plugins.forEach((p){
        p.allMethods().forEach((pluginMethodElement){
          if (elementInjectionType(pluginMethodElement) == '@MethodPlugin') {
            if (pluginMethodElement.name == "before" + methodElement.name.substring(0,1).toUpperCase() + methodElement.name.substring(1)) {
              beforePlugins[pluginMethodElement] = p;
            } else if (pluginMethodElement.name == "after" + methodElement.name.substring(0,1).toUpperCase() + methodElement.name.substring(1)) {
              afterPlugins[pluginMethodElement] = p;
            }
          }
        });
      });

      String paramsStr = methodElement.parameters.map((mp) => mp.name).join(",");
      String beforeArgsStr = '';
      if (beforePlugins.length > 0) {
        lines.add('List<dynamic> args = [$paramsStr];');
        int i = 0;
        beforeArgsStr = methodElement.parameters.map((mp) => "args[${i++}]").join(',');
      }
      for (var pluginMethod in beforePlugins.keys) {
        String pluginName = "${beforePlugins[pluginMethod]!.varName}";
        lines.add('args = ${pluginName}.${pluginMethod.name}($beforeArgsStr);');
      }
      if (beforePlugins.length > 0) {
        int i = 0;
        methodElement.parameters.forEach((mp) {
          lines.add('${mp.name} = args[$i];');
          i++;
        });
      }
      bool isVoid = methodElement.returnType.isVoid;
      if (beforePlugins.length + afterPlugins.length > 0) {
        lines.add((!isVoid ? 'var ret = ' : '') + 'super.${methodElement.name}($paramsStr);');
      }
      for (var pluginMethod in afterPlugins.keys) {
        String pluginName = "${afterPlugins[pluginMethod]!.varName}";
        lines.add((!isVoid ? 'ret = ' : '') + '${pluginName}.${pluginMethod.name}(${isVoid ? '' : 'ret'});');
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

/**
 * used to generate static method cfs_ with field logic per class
 */
class CompiledFieldMethodPart {
  MethodElement methodElement;
  TypeInfo type;
  TypeMap typeMap;
  Map<FieldElement, Map<MethodElement, List<String>>> stubs = {};
  CompiledFieldMethodPart(this.typeMap, this.methodElement, this.type);

  String get methodName => 'cfs_' + methodElement.name + type.flatName;

  getPartDeclaration() {
    List<String> params = [];
    params.add("${type.fullName} dis");
    params.addAll(methodElement.parameters.map((mp){
      TypeInfo parameterType = typeMap.fromDartType(mp.type);
      return "${parameterType.uniqueName} ${mp.name}";
    }));
    return 'void $methodName(' + params.join(",") + ')';
  }

  getCallExpression(String thisName) {
    List<String> params = [thisName];
    params.addAll(methodElement.parameters.map((mp) => mp.name));
    return '$methodName(' + params.join(",") + ');';
  }

  /**
   * analyse fieldMethodPart if fits compiledMethod
   */
  static Future<CompiledFieldMethodPart?> addFieldMethodPart(TypeInfo type, MethodElement compiledMethod, MethodElement fieldMethodPart, FieldElement field, String thisReplace) async {

    ParameterElement fieldParameter = fieldMethodPart.parameters.where((element) => element.name == 'field').first;

    if (!type.typeMap.typeSystem.isSubtypeOf(field.type, fieldParameter.type) ||
        //dynamic is nullable but returns empty suffix
        !(fieldParameter.type.isDynamic || field.type.nullabilitySuffix == fieldParameter.type.nullabilitySuffix)) {
      return null;
    }

    String? requireAnnotation = null;
    for (var m in fieldMethodPart.metadata) {
      if (m.toSource().startsWith('@AnnotatedWith(')) {
        requireAnnotation = '@' + m.toSource().substring(15, m.toSource().length - 1);
      }
    }

    if (requireAnnotation != null) {
      bool pass = false;
      for (var m in field.metadata) {
        //support for parametrised required annotations
        if (m.toSource() == requireAnnotation || m.toSource().startsWith(requireAnnotation + '(')) pass = true;
      }
      if (!pass) return null;
    }

    var enclosingType = type.typeMap.fromDartType((field.enclosingElement as ClassElement).thisType, context:type.typeArgumentsMap());

    CompiledFieldMethodPart compiledPart;
    if (!type.typeMap.compiledMethodsByType[compiledMethod]!.containsKey(enclosingType.uniqueName)) {
      type.typeMap.compiledMethodsByType[compiledMethod]![enclosingType.uniqueName] = compiledPart = new CompiledFieldMethodPart(type.typeMap, compiledMethod, enclosingType);
    } else {
      compiledPart = type.typeMap.compiledMethodsByType[compiledMethod]![enclosingType.uniqueName]!;
    }

    if (!compiledPart.stubs.containsKey(field) || !compiledPart.stubs[field]!.containsKey(fieldMethodPart)) {
      //generate stub;
      if (!compiledPart.stubs.containsKey(field)) {
        compiledPart.stubs[field] = {};
      }
      List<String> stubLines = compiledPart.stubs[field]![fieldMethodPart] = [];


      var compiledFieldType = type.typeMap.fromDartType(field.type, context:type.typeArgumentsMap());
      stubLines.add('{');
      //magic parameter match
      for (var methodParameter in fieldMethodPart.parameters) {
        if (compiledMethod.parameters.where((element) => element.name == methodParameter.name).isNotEmpty) {
          //this parameter comes from compiled method
          continue;
        }
        if (methodParameter.name == fieldParameter.name) {
          //this is a special param
          continue;
        }
        var methodParameterValue = 'null';
        if (methodParameter.name == 'name') {
          methodParameterValue = '"${field.name}"';
        } else if (methodParameter.name == 'className') {
          methodParameterValue = '"${compiledFieldType.uniqueName}"';
        } else if (methodParameter.isOptional) {
          methodParameterValue = methodParameter.defaultValueCode!;
          var nameParts = methodParameter.name.split('_');
          String annotationName = '@' + nameParts[0][0].toUpperCase() + nameParts[0].substring(1);
          if (nameParts.length == 1) {
            methodParameterValue = 'false';
            for (var fieldMeta in field.metadata) {
              if (fieldMeta.toSource() == annotationName) {
                methodParameterValue = 'true';
              }
            }
          } else {
            for (var fieldMeta in field.metadata) {
              if (fieldMeta.toSource().startsWith(annotationName + '(')) {
                DartObject annotationField = fieldMeta.computeConstantValue()!.getField(nameParts[1])!;
                switch (annotationField.type!.getDisplayString(withNullability: true)) {
                  case 'String':
                    methodParameterValue = '"' + annotationField.toStringValue()! + '"';
                    break;
                  case 'int':
                    methodParameterValue = annotationField.toIntValue().toString();
                    break;
                  default :
                    methodParameterValue = annotationField.toString();
                }
              }
            }
          }
        }
        stubLines.add('const ${methodParameter.name} = $methodParameterValue;');
      }
      String part = await fieldMethodPart.getSourceCode(type.typeMap.step);

      if (fieldMethodPart.parameters.indexWhere((element) => element.name == 'field') > -1) {
        part = part.replaceAll(fieldParameter.name, 'dis.${field.name}');
      }
      //TODO
      part = part.replaceAll('this', thisReplace);

      String paramClass = fieldParameter.type.getDisplayString(withNullability: false);
      String fieldClass = compiledFieldType.uniqueName;
      part = part.replaceAll(
          'as ${paramClass}',
          'as ${fieldClass}'
      );
      if (paramClass.indexOf('<') > -1 && fieldClass.indexOf('<') > -1) {
        //TODO support many parameters?
        String paramGenericParam = paramClass.substring(paramClass.indexOf('<') + 1, paramClass.length - 1);
        String fieldGenericParam = fieldClass.substring(fieldClass.indexOf('<') + 1, fieldClass.length - 1);
        part = part.replaceAll(
            'as ${paramGenericParam}',
            'as ${fieldGenericParam}'
        );
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

  Map<ClassElement, String> classNames = {};

  //indexed by compiled method and part declaring class name
  Map<MethodElement, Map<String, CompiledFieldMethodPart>> compiledMethodsByType = {};

  /**
   *
   */
  void registerClassElement(String fullName, Element element) async {
    if (element is ClassElement) {
      if (!classNames.containsKey(element)) {
        classNames[element] = fullName;
        TypeInfo elementType = new TypeInfo(
            this,
            element.thisType,
            config
        );
        allTypes[elementType.uniqueName] = elementType;
      }
    }
  }

  TypeInfo fromDartType(DartType type, {Map<TypeParameterElement, DartType> context = const {}}) {

    List<TypeInfo> typeArguments = [];
    if (type is ParameterizedType) {
      for (var arg in type.typeArguments) {
        typeArguments.add(fromDartType(arg, context:context));
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
    //output.writeLn('//!!!!' + type.getDisplayString(withNullability: true) + ' <=> ' + (type.element == null ? 'NULL' : type.element!.name!));

    TypeInfo ret = new TypeInfo(
        this,
        type,
        config,
        typeArguments:typeArguments
    );

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
    if (candidates.length == 0) {
      throw new Exception('no initialisation candidate for ' + type.fullName);
    }
    return candidates[0];
  }

  String generateTypeGetter(TypeInfo type) {
    TypeInfo candidate = getBestCandidate(type);
    String getterName = candidate.varName;
    return '\$om.${getterName}';
  }

  List<TypeInfo> getPluginsForType(TypeInfo type){
    List<TypeInfo> plugins = [];

    allTypes.forEach((name, ce){
      if (ce.element != null) {
        ce.element!.allSupertypes.forEach((st){
          if (st.getDisplayString(withNullability: false).startsWith('TypePlugin<') && st.typeArguments.length == 1 && typeSystem.isAssignableTo(type.type, st.typeArguments[0])) {
            plugins.add(ce);
          }
        });
      }
    });
    return plugins;
  }

  List<TypeInfo> getSubtypes(TypeInfo parentType, bool includeAbstract) {

    return allTypes.values.where((type){
      //output.writeLn("//candidate: " + type.displayName);
      if (type.element == null) return false;
      //output.writeLn("//element ok");

      if (!includeAbstract) {
        for (var metadataElement in (type.element as ClassElement).metadata) {
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


      type.element!.allSupertypes.forEach((st){
        bool parentFits = true;
        //isSubtype = isSubtype || i.displayName == parentType.displayName;
        //TODO: add results to debug info, fix in tests
        String stName = st.getDisplayString(withNullability: true);
        if (stName.indexOf('<') > -1) stName = stName.substring(0, stName.indexOf('<'));
        String parentTypeName = parentType.type.getDisplayString(withNullability: true);
        if (parentTypeName.indexOf('<') > -1) parentTypeName = parentTypeName.substring(0, parentTypeName.indexOf('<'));
        parentFits = parentFits & (stName == parentTypeName);
        if (parentType.typeArguments.length == st.typeArguments.length) {
          for (var i=0; i < parentType.typeArguments.length; i++) {
            parentFits = parentFits && (
                (parentType.typeArguments[i].type.getDisplayString(withNullability: false) == st.typeArguments[i].getDisplayString(withNullability: false))
                    //|| typeSystem.isSubtypeOf(parentType.typeArguments[i].type, st.typeArguments[i])  //TODO ????? maybe both? or maybe for separate usage case?
                    || typeSystem.isSubtypeOf(st.typeArguments[i], parentType.typeArguments[i].type)
            );//
            //parentFits = parentFits & st.typeArguments[i].isAssignableTo(parentType.arguments[i].type);
          }
        } else {
          parentFits = false;
        }
        fits = fits | parentFits;
      });
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
