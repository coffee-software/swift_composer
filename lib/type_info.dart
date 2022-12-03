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

extension MethodElementSource on MethodElement {
  Future<String> getSourceCode(BuildStep step) async {
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
    part = part.substring(part.indexOf(')'));
    return part.substring(part.indexOf('{'));
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
  }

  bool get isNullable => (type.nullabilitySuffix == NullabilitySuffix.question);

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

  @deprecated
  String get displayName {
    return '${fullName}'; // + (typeArguments.isNotEmpty ? '<${typeArguments.map((e)=>e.displayName).join(',')}>' : '') + (type.nullabilitySuffix == NullabilitySuffix.question ? '?' : '');
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
      classConfig[type.displayName] = test++;
      if (config.config.containsKey(type.displayName)){
        for ( var k in config.config[type.displayName].keys) {
          if (!classConfig.containsKey(k)) {
            classConfig[k] = config.config[type.displayName][k];
          }
        }
      }
    }
    return classConfig;
  }

  String get creatorName => hasInterceptor() ? '\$' + flatName : displayName;

  String generateCompiledConstructorDefinition() {
    return '\$${flatName}' + '(' + allRequiredFields().map((f) => f.name).join(',') + ') {\n';
  }

  Iterable<FieldElement> allRequiredFields() {
    return allFields().where((f) => elementInjectionType(f) == '@Require');
  }

  List<String> generateCreator() {
    List<String> lines = [];
    String constructor = creatorName;
    if (fullName == 'List') {
      constructor += '.empty';
    }
    lines.add('new ${constructor}(' + allRequiredFields().map((f) => f.name).join(',') + ')');
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

    return lines;
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

  String? elementInjectionType(Element? element) {
    for (var metadataElement in element!.metadata) {
      if (decorators.contains(metadataElement.toSource())) {
        return metadataElement.toSource();
      }
    }
    return null;
  }

  String? getFieldInitializationValue(TypeInfo fieldType, FieldElement field) {
    switch (elementInjectionType(field.getter)) {
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
          if (!fieldType.isNullable) {
            throw new Exception("missing config value for non nullable field ${fieldType.fullName} ${field.name}");
          }
          return 'null';
        }
        switch (fieldType.fullName){
          case "String":
            return '"' + typeConfig[field.name] + '"';
          case "int":
          case "double":
          case "bool":
            return typeConfig[field.name].toString();
          default:
            return 'new ' + fieldType.displayName + '.fromString("' + typeConfig[field.name] + '")';
        }
      case '@InjectInstances':
        TypeInfo type = fieldType.typeArguments[1];
        typeMap.subtypeInstanes[type.uniqueName] = type;
        return '\$om.instancesOf${type.flatName}';
      case '@InjectClassName':
        return '"' + displayName + '"';
      case '@InjectClassNames':
        List<String> path = [];
        for (var type in allTypeInfoPath()){
          if (field.enclosingElement == type.element) break;
          path.add(type.displayName);
        }
        return '[' + path.reversed.map((s)=>"'$s'").join(',') + ']';
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
    for (var st in element!.allSupertypes) {
      if (st.element.name == 'Object') {
        break;
      }
      yield st.element as ClassElement;
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
    for (var c in allClassElementsPath()) {
      for (var metadataElement in c.metadata) {
        if (metadataElement.toSource() == '@ComposeSubtypes') {
          return c != element;
        }
        if (metadataElement.toSource() == '@Compose') {
          return true;
        }
      }
    }
    return false;
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
    if (element == null) return allFields;
    for (var element in allClassElementsPath()) {
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
            "// argument: ${element.name} ${element.hashCode.toString()}");
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
              "// argument: ${element.name} ${element.hashCode.toString()}");
        });
      }
      //lines.add("//config: ${json.encode(typeConfig)}");

      for (var p in plugins) {
        output.writeLn("// plugin: ${p.displayName}");
      }


      output.writeLn("// CONFIG");
      typeConfig.forEach((key, value) {
        output.writeLn("// config: ${key} ${value}");
      });
      output.writeLn("// TYPE PATH:");
      for (var type in this.allTypeInfoPath()) {
        output.writeLn("//  " + type.displayName);
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
          '${abstract}class \$$flatName$typeArgs extends $displayName$shortArgs implements Pluggable {');
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
        output.writeLn("//${fieldElement.type.getDisplayString(withNullability: true)}");

        if (elementInjectionType(fieldElement) == '@Create') {
          //TMP
          TypeInfo ti = typeMap.fromDartType(fieldElement.type, context:typeArgumentsMap());
          output.writeLn("//" + ti.uniqueName, debug:true);
          typeMap.getNonAbstractSubtypes(ti).forEach((element) {
            output.writeLn("// c: ${element.uniqueName}", debug:true);
          });

          TypeInfo candidate = typeMap.getBestCandidate(ti);
          output.writeLn('this.${fieldElement.name} = ');
          output.writeMany(candidate.generateCreator());
          output.writeLn(';');
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
      output.writeLn("// ${fieldType.uniqueName} ${fieldElement.name}");
      String? value = getFieldInitializationValue(fieldType, fieldElement);
      //debug
      typeMap.getNonAbstractSubtypes(fieldType).forEach((element) {
        output.writeLn("// c: ${element.uniqueName}", debug: true);
      });
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
          (methodElement.parameters[0].type.name != 'String')) {
        throw new Exception('SubtypeFactory first argument needs to be named className and be of type String');
      }
      lines.add('switch(className){');
      for (var type in typeMap.getNonAbstractSubtypes(returnType)) {
        if (type.allRequiredFields().length == methodElement.parameters.length - 1) {
          lines.add('case \'${type.fullName}\':');
          lines.add('return ');
          lines.addAll(type.generateCreator());
          lines.add(';');
        }
      }
      lines.add('}');
      lines.add('throw new Exception(\'no type for \' + className);');
    } else if (elementInjectionType(methodElement) == '@Factory') {
      var best = typeMap.getBestCandidate(returnType);
      lines.add('//' + returnType.fullName);
      lines.add('return ');
      lines.addAll(best.generateCreator());
      lines.add(';');
    } else if (elementInjectionType(methodElement) == '@Compile') {
      lines.add('//compiled method');
      //TODO: add original method ??
      for (var methodPartElement in allMethods()) {
        if (methodPartElement.name.startsWith('_' + methodElement.name)) {
          if (elementInjectionType(methodPartElement) == '@CompilePart') {
            String part = await methodPartElement.getSourceCode(this.typeMap.step);
            lines.add(part);
          } else if (elementInjectionType(methodPartElement) == '@CompileFieldsOfType') {

            String? requireAnnotation = null;
            for (var m in methodPartElement.metadata) {
              if (m.toSource().startsWith('@AnnotatedWith(')) {
                requireAnnotation = '@' + m.toSource().substring(15, m.toSource().length - 1);
                lines.add('//' + requireAnnotation);
              }
            }
            
            //var fieldType = typeMap.fromDartType(methodPartElement.parameters.last.type, context:typeArgumentsMap());

            Future<void> filedBitGenerator(String prefix, FieldElement field) async {
              ParameterElement fieldParameter = methodPartElement.parameters.where((element) => element.name == 'field').first;

              if (typeMap.typeSystem.isSubtypeOf(field.type, fieldParameter.type) &&
                  //dynamic is nullable but returns empty suffix
                (fieldParameter.type.isDynamic || field.type.nullabilitySuffix == fieldParameter.type.nullabilitySuffix)) {

                if (requireAnnotation != null) {
                  bool pass = false;
                  for (var m in field.metadata) {
                    if (m.toSource() == requireAnnotation) pass = true;
                  }
                  if (!pass) return;
                }

                var compiledFieldType = typeMap.fromDartType(field.type, context:typeArgumentsMap());
                lines.add('{');
                //magic parameter match
                for (var methodParameter in methodPartElement.parameters) {
                  if (methodElement.parameters.where((element) => element.name == methodParameter.name).isNotEmpty) {
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
                  lines.add('const ${methodParameter.name} = $methodParameterValue;');
                }
                String part = await methodPartElement.getSourceCode(this.typeMap.step);

                if (methodPartElement.parameters.indexWhere((element) => element.name == 'field') > -1) {
                  part = part.replaceAll(fieldParameter.name, '${prefix}${field.name}');
                }

                String paramClass = methodPartElement.parameters.last.type.getDisplayString(withNullability: false);
                String fieldClass = compiledFieldType.uniqueName;
                part = part.replaceAll(
                    'as ${paramClass}',
                    'as ${fieldClass}'
                );
                
                if (paramClass.startsWith('List<') && fieldClass.startsWith('List<')) {
                  part = part.replaceAll(
                      'as ${paramClass.substring(5 , paramClass.length - 1)}',
                      'as ${fieldClass.substring(5 , fieldClass.length - 1)}'
                  );
                }

                //part = "// ${paramClass} \n" + part;
                //part = "// ${fieldClass} \n" + part;
                lines.add(part);
                lines.add('}');
              }
            };
            for (var f in allFields()) await filedBitGenerator('this.', f);
            for (var plugin in plugins) {
              for (var f in plugin.allFields()) {
                await filedBitGenerator('this.${plugin.varName}.', f);
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


class TypeMap {

  TypeSystem typeSystem;
  OutputWriter output;
  DiConfig config;
  BuildStep step;
  //Map<LibraryElement, String?> importedLibrariesMap = {};

  TypeMap(this.output, this.typeSystem, this.step, this.config);

  Map<String, TypeInfo> allTypes = {};
  Map<String, TypeInfo> subtypeInstanes = {};
  Map<String, TypeInfo> subtypesOf = {};

  Map<ClassElement, String> classNames = {};

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

    //output.writeLn("//LOOKING FORL " + name);
    //output.writeLn("//THIS IS: ${type.hashCode}");
    allTypes.forEach((key, value) {
      //output.writeLn("//$key => ${value.element?.thisType.hashCode}");
    });
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
      throw new Exception('no initialisation candidate for ' + type.displayName);
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
          if (st.name == 'TypePlugin' && st.typeArguments.length == 1 && typeSystem.isAssignableTo(type.type, st.typeArguments[0])) {
            plugins.add(ce);
          }
        });
      }
    });
    return plugins;
  }

  List<TypeInfo> getNonAbstractSubtypes(TypeInfo parentType) {
    return allTypes.values.where((type){
      //output.writeLn("//candidate: " + type.displayName);
      if (type.element == null) return false;
      //output.writeLn("//element ok");

      for (var metadataElement in (type.element as ClassElement).metadata) {
        if (metadataElement.toSource() == '@ComposeSubtypes') {
          return false;
        }
      }

      if (type.uniqueName == parentType.uniqueName) {
        return true;
      }
      //output.writeLn("//name not fit");
      if (!type.hasInterceptor() && type.element!.isAbstract) return false;
      //output.writeLn("//interceptor ok");
      bool fits = false;


      type.element!.allSupertypes.forEach((st){
        bool parentFits = true;
        //isSubtype = isSubtype || i.displayName == parentType.displayName;
        parentFits = parentFits & (st.name == parentType.type.name);
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
}
