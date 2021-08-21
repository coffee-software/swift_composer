library swift_composer;

import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

import 'package:build/build.dart';
import "package:path/path.dart" show dirname;

import 'dart:async';
import 'dart:io';
import 'package:yaml/yaml.dart';

extension MethodElementSource on MethodElement {
  String getSourceCode() {
    String part = this.session!.getParsedLibraryByElement(this.library).getElementDeclaration(this)!.node.toSource();
    return part.substring(part.indexOf('{'));
  }
}

abstract class TemplateLoader {
  String? load(String path);
}

class TypeInfo {

  TypeMap typeMap;
  late String fullName;
  ClassElement? element;
  late DartType type;
  List<TypeInfo> plugins = [];
  List<TypeInfo> typeArguments;
  DiConfig config;

  TypeInfo(this.typeMap, this.fullName, this.element, this.type, this.config, {this.typeArguments = const []});

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

  String get displayName {
     return '${fullName}' + (typeArguments.isNotEmpty ? '<${typeArguments.map((e)=>e.displayName).join(',')}>' : '');
  }

  String get varName {
    return '${flatName[0].toLowerCase()}${flatName.substring(1)}';
  }

  String get flatName {
    return '${fullName.replaceAll('.', '_')}' + (typeArguments.isNotEmpty ? '_${typeArguments.map((e)=>e.flatName).join('_')}_' : '');
  }

  String get creatorName => hasInterceptor() ? '\$' + flatName : displayName;

  String generateCompiledConstructorDefinition() {
    return '\$${fullName.replaceAll('.', '_')}' + '(' + allRequiredFields().map((f) => f.name).join(',') + ') {\n';
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
    '@InjectSubtypesNames',
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
          return typeMap.generateTypeGetter(fieldType);
      case '@InjectConfig':
        if (!typeConfig.containsKey(field.name)) {
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
          typeMap.subtypeInstanes[type.displayName] = type;
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

      TypeInfo fieldType = typeMap.fromDartType(field.type, typeArgumentsMap());

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
      yield typeMap.fromDartType(element.thisType, typeArgumentsMap());
    }
  }

  Iterable<ClassElement> allClassElementsPath() sync* {
    if (element != null) {
      yield element!;
    }
    for (var st in element!.allSupertypes) {
      if (st.element.name == 'Object') {
        break;
      }
      yield st.element;
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

    for (var k in typeArguments) {
      if (k.element == null) {
        return false;
      }
    }

    bool ret = false;
    if (element != null) {
      for (var c in allClassElementsPath()) {
        for (var metadataElement in c.metadata) {
          if (metadataElement.toSource() == '@Compose') {
            ret = true;
          }
          if (metadataElement.toSource() == '@ComposeSubtypes') {
            if (c != element) {
              ret = true;
            }
          }
        }
        if (ret) break;
      }
      /*if (ret == false ) {
        if (element!.displayName == 'Map' || element!.displayName == 'List') {
          ret = true;
        }
      }*/
    }

    //TODO optimise if does not have plugins?
    //typeMap.getPluginsForType(this).isEmpty

    return ret;
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
    for (var element in allClassElementsPath()) {
        for (var m in element.methods) {
          //if (!m.name.startsWith('_'))
            allMethods.add(m);
        }
    }
    return allMethods;
  }

  Map<TypeParameterElement, DartType> typeArgumentsMap() {
    Map<TypeParameterElement, DartType> ret = {};
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

  Future<void> generateInterceptor(OutputWriter output, TemplateLoader templateLoader) async {
    output.writeLn("//type arguments[1]:");
    for (var k in typeArgumentsMap().keys) {
      output.writeLn("//${k.getDisplayString(withNullability: true)}[${k.hashCode.toString()}] => ${typeArgumentsMap()[k]!.getDisplayString(withNullability: true)}[${typeArgumentsMap()[k].hashCode.toString()}]");
    }

    output.writeLn("//type arguments[2]:");
    for (var k in typeArguments) {
      output.writeLn("//ENCLOSING: " + (k.element != null ? (k.element!.enclosingElement.name ?? "XXX") : "NULL"));
      output.writeLn("//${k.type.getDisplayString(withNullability: true)}[${k.hashCode.toString()}]");
    }

    output.writeLn("//can be singleton: ${canBeSingleton()?'TRUE':'FALSE'}");

    element!.typeParameters.forEach((element) {
      output.writeLn("//parameter: ${element.name} ${element.hashCode.toString()}");
      //lines.add("//parameter: ${element.bound == null ? "NULL" : element.bound.name}");
      //lines.add("//parameter: ${element.instantiate(nullabilitySuffix: NullabilitySuffix.none).element.name}");
    });
    element!.thisType.typeArguments.forEach((element) {
      output.writeLn("//argument: ${element.name} ${element.hashCode.toString()}");
    });

    for (var s in element!.allSupertypes) {
      output.writeLn("//parent: ${s.element.displayName} ${s.element.metadata.toString()}");
      s.element.typeParameters.forEach((element) {
        output.writeLn("//parameter: ${element.name} ${element.hashCode.toString()}");
        //lines.add("//parameter: ${element.bound == null ? "NULL" : element.bound.name}");
        //lines.add("//parameter: ${element.instantiate(nullabilitySuffix: NullabilitySuffix.none).element.name}");
      });
      s.typeArguments.forEach((element) {
        output.writeLn("//argument: ${element.name} ${element.hashCode.toString()}");
      });
    }


    //lines.add("//config: ${json.encode(typeConfig)}");

    plugins = typeMap.getPluginsForType(this);
    for (var p in plugins) {
      output.writeLn("//plugin: ${p.displayName}");
    }

    output.writeLn("//CONFIG");
    config.config.forEach((key, value) {
      output.writeLn("//config: ${key} ${value}");
    });
    typeConfig.forEach((key, value) {
      output.writeLn("//config: ${key} ${value}");
    });
    output.writeLn("//TYPE PATH:");
    for (var type in this.allTypeInfoPath()) {
      output.writeLn("//   " + type.displayName);
    }

    var typeArgsList = element!.typeParameters.map((e) {
      return e.name + (e.bound != null ? " extends " + (this.typeMap.fromDartType(e.bound!, this.typeArgumentsMap())).fullName : '');
    }).join(',');
    var typeArgs = element!.typeParameters.isNotEmpty ? "<" + typeArgsList + ">" : '';

    var shortArgs = element!.typeParameters.isNotEmpty ? "<${element!.typeParameters.map((e) => e.name).join(',')}>" : '';

    if (typeArguments.length > 0) {
      String parent = '\$${fullName.replaceAll('.', '_')}' + '<${typeArguments.map((e)=>e.creatorName).join(',')}>';
      output.writeLn('//parametrized type');
      output.writeLn(
          'class \$$flatName extends $parent implements Pluggable {');
    } else {
      output.writeLn(
          'class \$$flatName$typeArgs extends $displayName$shortArgs implements Pluggable {');
    }

    for (var p in plugins) {
      output.writeLn('late ${p.fullName} ${p.varName};');
    }

    output.writeLn(generateCompiledConstructorDefinition());


    allFields().forEach((fieldElement){
      if (fieldElement.setter != null) {
        output.writeLn("//${fieldElement.type.getDisplayString(withNullability: true)}");

        if (elementInjectionType(fieldElement) == '@Create') {
          output.writeLn("//create");
          //TMP
          TypeInfo ti = typeMap.fromDartType(fieldElement.type, typeArgumentsMap());

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
        TypeInfo fieldType = typeMap.fromDartType(fieldElement.type, typeArgumentsMap());


        //fieldElement.type.isDartAsyncFutureOr
        String? value = getFieldInitializationValue(fieldType, fieldElement);
        if (value != null) {
          output.writeLn(
            "${fieldType.displayName} get ${fieldElement.name} => ${value};"
          );
        }
    });

    allMethods().forEach((methodElement){
      List<String> methodLines = generateMethodOverride(methodElement);
      if (methodLines.length > 0) {

        TypeInfo returnType = typeMap.fromDartType(methodElement.returnType, typeArgumentsMap());
        var typeArgsList = methodElement.typeParameters.map((e) {
          return e.name + (e.bound != null ? " extends " + (this.typeMap.fromDartType(e.bound!, this.typeArgumentsMap())).fullName : '');
        }).join(',');
        var typeArgs = typeArgsList.isNotEmpty ? "<" + typeArgsList + ">" : '';

        output.writeLn("${returnType.displayName} ${methodElement.name}${typeArgs}(");
        output.writeLn(methodElement.parameters.map((mp){
          TypeInfo parameterType = typeMap.fromDartType(mp.type, typeArgumentsMap());
          return "${parameterType.displayName} ${mp.name}";
        }).join(","));

        output.writeLn("){");
        output.writeMany(methodLines);
        output.writeLn("}");
      }

    });

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

  List<String> generateMethodOverride(MethodElement methodElement) {
    TypeInfo returnType = typeMap.fromDartType(methodElement.returnType, typeArgumentsMap());
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
      lines.add('throw new Exception(\'no type for\' + className);');
    } else if (elementInjectionType(methodElement) == '@InjectSubtypesNames') {
      var bound = this.typeMap.fromDartType(methodElement.typeParameters[0].bound!, this.typeArgumentsMap());
      for (var type in typeMap.getNonAbstractSubtypes(bound)) {
        lines.add('if (T == ${type.fullName}) return \'${type.fullName}\';');
      }
    } else if (elementInjectionType(methodElement) == '@Factory') {
      var best = typeMap.getBestCandidate(returnType);
      lines.add('//' + returnType.fullName);
      lines.add('return ');
      lines.addAll(best.generateCreator());
      lines.add(';');
    } else if (elementInjectionType(methodElement) == '@Compile') {
      lines.add('//compiled method');
      //TODO: add original method ??
      allMethods().forEach((methodPartElement){
        if (methodPartElement.name.startsWith('_' + methodElement.name)) {
          if (elementInjectionType(methodPartElement) == '@CompilePart') {
            String part = methodPartElement.getSourceCode();
            lines.add(part);
          } else if (elementInjectionType(methodPartElement) == '@CompileFieldsOfType') {

            String? requireAnnotation = null;
            for (var m in methodPartElement.metadata) {
              if (m.toSource().startsWith('@AnnotatedWith(')) {
                requireAnnotation = '@' + m.toSource().substring(15, m.toSource().length - 1);
                lines.add('//' + requireAnnotation);
              }
            }
            var fieldType = typeMap.fromDartType(methodPartElement.parameters.last.type, typeArgumentsMap());

            var filedBitGenerator = (String prefix, FieldElement field){
              if (typeMap.typeSystem.isSubtypeOf(field.type, fieldType.type)) {

                if (requireAnnotation != null) {
                  bool pass = false;
                  for (var m in field.metadata) {
                    if (m.toSource() == requireAnnotation) pass = true;
                  }
                  if (!pass) return;
                }
                //TODO
                var compiledFieldType = typeMap.fromDartType(field.type, typeArgumentsMap());
                String part = methodPartElement.getSourceCode();
                if (methodPartElement.parameters.indexWhere((element) => element.name == 'name') > -1) {
                  part = part.replaceAll('name', '\'${field.name}\'');
                }
                if (methodPartElement.parameters.indexWhere((element) => element.name == 'field') > -1) {
                  part = part.replaceAll('field', '${prefix}${field.name}');
                }
                if (methodPartElement.parameters.indexWhere((element) => element.name == 'className') > -1) {
                  part = part.replaceAll(
                      'className',
                      '"${compiledFieldType.fullName}"'
                  );
                }
                lines.add(part);
              }
            };
            allFields().forEach((f) => filedBitGenerator('this.', f));
            plugins.forEach((plugin){
              plugin.allFields().forEach((f) => filedBitGenerator('this.${plugin.varName}.', f));
            });
          };
        };
      });
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
  Map<LibraryElement, String?> importedLibrariesMap;

  TypeMap(this.output, this.typeSystem, this.config, this.importedLibrariesMap);

  Map<String, TypeInfo> allTypes = {};
  Map<String, TypeInfo> subtypeInstanes = {};

  TypeInfo fromDartType(DartType type, Map<TypeParameterElement, DartType> context) {

    List<TypeInfo> typeArguments = [];
    if (type is ParameterizedType) {
      for (var arg in type.typeArguments) {
        typeArguments.add(fromDartType(arg, context));
      }
    }

    context.forEach((key, value) {
      key.instantiate(nullabilitySuffix: NullabilitySuffix.none).bound.name!;
      /*output.writeLn(
        "//BOUND OF " + key.name + " " + key.instantiate(nullabilitySuffix: NullabilitySuffix.none).bound.name!
      );*/
      if (key.hashCode == type.hashCode) {
        type = value;
      }
    });
    ClassElement? element;
    if ((type.element != null) && (type.element is ClassElement)) {
        element = type.element as ClassElement;
    } else {
      output.writeLn("//NO ELEMENT!");
    }

    String name = type.getDisplayString(withNullability: true);
    if (type.element != null) {
      name = type.element!.name!;
      if (type.element!.library != null) {
        if (!type.element!.library!.isDartCore) {
          if (importedLibrariesMap.containsKey(type.element!.library!)) {
            String? prefix = importedLibrariesMap[type.element!.library!];
            if (prefix != null) {
              name = prefix + '.' + name;
            }
          } else {
            //throw new Exception('library ' + type.element!.library!.name! + ' for element ' + name + ' is not imported');
          }
        }
      }
    }
    //output.writeLn('//!!!!' + type.getDisplayString(withNullability: true) + ' <=> ' + (type.element == null ? 'NULL' : type.element!.name!));

    TypeInfo ret = new TypeInfo(
          this,
          name,
          element,
          type,
          config,
          typeArguments:typeArguments
    );

    if (allTypes.containsKey(ret.displayName)) {
      return allTypes[ret.displayName]!;
    }
    allTypes[ret.displayName] = ret;

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
    return ret;

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
              if (st.name == 'TypePlugin' && st.typeArguments.length == 1 && typeSystem.isAssignableTo(st.typeArguments[0], type.type)) {
                plugins.add(ce);
              }
            });
          }
      });
      return plugins;
  }

  List<TypeInfo> getNonAbstractSubtypes(TypeInfo parentType) {
    return allTypes.values.where((type){
      output.writeLn("//candidate: " + type.displayName);
      if (type.element == null) return false;
      output.writeLn("//element ok");
      if (type.displayName == parentType.displayName) {
        return true;
      }
      output.writeLn("//name not fit");
      if (!type.hasInterceptor() && type.element!.isAbstract) return false;
      output.writeLn("//interceptor ok");
      bool fits = false;


      type.element!.allSupertypes.forEach((st){
        bool parentFits = true;
        //isSubtype = isSubtype || i.displayName == parentType.displayName;
        parentFits = parentFits & (st.name == parentType.type.name);
        if (parentType.typeArguments.length == st.typeArguments.length) {
          for (var i=0; i < parentType.typeArguments.length; i++) {
            parentFits = parentFits && (
              (parentType.typeArguments[i].type.getDisplayString(withNullability: false) == st.typeArguments[i].getDisplayString(withNullability: false))
              ||
              typeSystem.isSubtypeOf(st.typeArguments[i], parentType.typeArguments[i].type)
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

class OutputWriter {
  List<String> _lines = [];

  writeLn(String line) {
    _lines.add(line);
  }

  writeMany(List<String> lines) {
    _lines.addAll(lines);
  }

  writeSplit() {
    this.writeLn('// **************************************************************************');
  }

  String getOutput() => _lines.join("\n");
}

class ImportedModule {
  String filePath;
  String? prefix;
  String packagePath;
  ImportedModule(this.filePath, this.packagePath, {this.prefix});
}

class DiConfig {
  Map<String, dynamic> config = {};

  void append(Map config, String? prefix) {
    _mergeMaps(this.config, config, prefix);
  }

  void _mergeMaps(Map first, Map other, String? prefix) {
    for (var key in other.keys) {
      String prefixedKey = (prefix != null) ? prefix + '.' + key : key;
      if (first.containsKey(prefixedKey) && first[prefixedKey] is Map) {
        _mergeMaps(first[prefixedKey] as Map, other[key], null);
      } else {
        first[prefixedKey] = other[key];
      }
    }
  }

}

class CompiledOmGenerator implements TemplateLoader {

  TypeMap typeMap;
  LibraryReader library;
  BuildStep step;
  OutputWriter output;

  DiConfig config;
  List<ImportedModule> modules = [];
  static Map<LibraryElement, String?> importedLibrariesMap = {};


  CompiledOmGenerator(this.output, this.library, this.step, this.config) :
        typeMap = new TypeMap(output, library.element.typeSystem, config, importedLibrariesMap);

  String? load(String name) {
    for (var m in modules.reversed) {
      String filePath = m.packagePath + '/templates/' + name;
      File file = new File(filePath);
      if (file.existsSync()) {
        return file.readAsStringSync();
      }
    }
    return null;
  }

  void generateObjectManager() {
    output.writeLn('class \$ObjectManager {');
    for (var type in typeMap.allTypes.values) {
      if (type.canBeSingleton()) {

        String getterName = type.varName;
        output.writeLn('${type.creatorName}? _${getterName};');
        output.writeLn('${type.creatorName} get ${getterName} {');
        output.writeLn('if(_${getterName} == null){');
        output.writeLn('_${getterName} = ');
        output.writeMany(type.generateCreator());
        output.writeLn(';');
        output.writeLn('}');
        output.writeLn('return _${getterName} as ${type.creatorName};');
        output.writeLn('}');
      }
    }


    typeMap.subtypeInstanes.values.forEach((typeInfo){
      output.writeLn('Map<String, ${typeInfo.fullName}> get instancesOf${typeInfo.flatName} {');
      output.writeLn('return {');
      typeMap.getNonAbstractSubtypes(typeInfo).forEach((subtypeInfo){
        if (subtypeInfo.allRequiredFields().length == 0) {
          output.writeLn('"${subtypeInfo.displayName}": ');
          output.writeMany(subtypeInfo.generateCreator());
          output.writeLn(',');
        }
        });
      output.writeLn('};');
      output.writeLn('}');
    });

    /*

    Set<String> generated = new Set<String>();
    childTypesLists.forEach((parentType){
      if (generated.contains(parentType.flatName)) {
        return;
      }
      generated.add(parentType.flatName);

      ret += 'class \$SubtypesOf' + parentType.flatName + ' extends SubtypesOf<' + parentType.displayName + '> {\n';

      List<ClassElement> subtypes = map.getNonAbstractSubtypes(parentType);


      ret += '\tfinal Map<String, SubtypeOf<' + parentType.displayName + '>> delegate = {\n';
      subtypes.forEach((childElement) {
          ret += '\t\t\'' + childElement.name + '\' : new SubtypeOf<' + parentType.displayName + '>(';
          ret += '() => new \$' + childElement.library.name + '_' + childElement.name + '()\n';
          ret += ', [';
          for (var m in childElement.metadata) {
            ret += 'new ' + m.toSource().substring(1) + ', ';
          }
          ret += ']';
          ret += '),\n';
      });
      ret += '\t};\n';

      ret += '}\n';
    });

    */

    output.writeLn('}');
    output.writeLn('\$ObjectManager \$om = new \$ObjectManager();');
  }

  /**
   *
   */
  Future<void> _loadLibraryFiles() async {
    var packagesMap = new Map<String, String>();
    File packagesFile = new File(Directory.current.path + '/.packages');
    (await packagesFile.readAsString()).split("\n").skip(1).forEach((line){
      if (line.indexOf(':') > -1) {
        String package = line.substring(0, line.indexOf(':'));
        String root = line.substring(line.indexOf(':') + 1);
        root = root.replaceFirst('lib/', '', root.length - 4);
        if (root.startsWith('file://')) {
          root = root.replaceFirst('file://', '');
        } else if (!root.startsWith('/')) {
          root = Directory.current.path + '/' + root;
        }
        packagesMap[package] = root;
      }
    });

    library.element.imports.forEach((e){
      if (e.uri != null && !e.uri!.startsWith('dart:')) {
        AssetId id = AssetId.resolve(new Uri.file(e.uri!), from:step.inputId);
        modules.add(new ImportedModule(
            packagesMap[id.package]! + id.path,
            packagesMap[id.package]!,
            prefix: e.prefix?.name
        ));
      }
    });
    modules.add(new ImportedModule(
        Directory.current.path + '/' + step.inputId.path,
        Directory.current.path + '/'
    ));
  }

  /**
   *
   */
  Future<void> _loadConfig() async {
    for (var module in modules){
      String path = module.filePath.replaceFirst('.dart', '.di.yaml', module.filePath.length - 5);
      File configFile = new File(path);
      if (configFile.existsSync()) {
        output.writeLn('//loading config file ' + path);
        var yaml = loadYaml(await configFile.readAsString());
        if (yaml is YamlMap){
          config.append(yaml.value, module.prefix);
        }
      }
    };
  }

  /**
   *
   */
  void registerClassElement(String fullName, Element element) async {
    if (element is ClassElement) {
      typeMap.allTypes[fullName] = new TypeInfo(
          this.typeMap,
          fullName,
          element,
          element.thisType,
          config
      );
    }
  }

  /**
   *
   */
  Future<String> generate() async {

    var generationStart = new DateTime.now();
    try {
      output.writeSplit();
      output.writeLn('// generated by swift_composer at ' + generationStart.toString());
      await _loadLibraryFiles();
      await _loadConfig();
      output.writeSplit();

      for (var importElement in library.element.imports) {
        if (!importElement.importedLibrary!.isDartCore) {
          importedLibrariesMap[importElement!.importedLibrary!] = importElement.prefix == null ? null : importElement.prefix!.name;
          output.writeLn('// import ' + (importElement.importedLibrary?.identifier ?? 'null') + (importElement.prefix == null ? '' : ' as ' + importElement.prefix!.name));
          importElement.namespace.definedNames.forEach(registerClassElement);
        }
      }
      library.allElements.forEach((element) => registerClassElement(element.name!, element));


      for (int i=0; i < typeMap.allTypes.keys.length; i++) {
        output.writeSplit();
        TypeInfo type = typeMap.allTypes[typeMap.allTypes.keys.elementAt(i)!]!;
        if (type.hasInterceptor()) {
          output.writeLn("//interceptor for [${type.displayName}]");
          await type.generateInterceptor(output, this);
        } else {
          output.writeLn("//no interceptor for [${type.displayName}]");
        }
      }
      /*List<String> allTypes = [];
      allTypes.addAll(typeMap.allTypes.keys);
      for (var s in allTypes) {
        output.writeSplit();
        if (typeMap.allTypes[s]!.hasInterceptor()) {
            output.writeLn("//interceptor for [${typeMap.allTypes[s]!.fullName}]");
            await typeMap.allTypes[s]!.generateInterceptor(output, this);
        } else {
          output.writeLn("//no interceptor for [${typeMap.allTypes[s]!.fullName}]");
        }
      };*/
      output.writeSplit();

      output.writeLn("// All Types:");
      for (var s in typeMap.allTypes.keys) {
        output.writeLn("//" + s + " " + typeMap.allTypes[s]!.displayName);
      }
      output.writeSplit();

      generateObjectManager();

    } catch(e, stacktrace) {
      output.writeLn('/* unhandled code generator exception: \n' + e.toString() + '\n' + stacktrace.toString() + '*/');
    }

    var generationEnd = new DateTime.now();
    output.writeLn('//generated in ${generationEnd.millisecondsSinceEpoch - generationStart.millisecondsSinceEpoch}ms\n');
    return output.getOutput();
  }

}

class SwiftGenerator extends Generator {

  const SwiftGenerator();
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep step) async {
    if (library.element.parts.isNotEmpty) {
      return await (
          new CompiledOmGenerator(
              new OutputWriter(),
              library,
              step,
              new DiConfig()
          )
      ).generate();
    }
    return null;
  }

}

PartBuilder swiftBuilder(_) {
  print(_);
  return new PartBuilder([const SwiftGenerator()], '.c.dart');
}
