library swift_composer;

import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import "package:path/path.dart" show dirname;

import 'dart:async';
import 'dart:io';
import 'package:yaml/yaml.dart';


extension MethodElementSource on MethodElement {
  String getSourceCode() {
    String part = this.session.getParsedLibraryByElement(this.library).getElementDeclaration(this).node.toSource();
    return part.substring(part.indexOf('{'));
  }
}

class TypeInfo {
  TypeMap typeMap;
  String fullName;
  ClassElement element;
  ClassElement genericElement;
  DartType genericType;
  DartType type;
  List<TypeInfo> typeArguments = [];

  Map<dynamic, dynamic> typeConfig;


  TypeInfo(this.typeMap, this.fullName, this.element) {
    type = element.thisType;
    /*for (var type in element.typeParameters) {
      typeArguments.add(new TypeInfo.fromType(type, {}));
    }*/
  }

  TypeInfo.fromType(this.typeMap, DartType type, Map<DartType, DartType> typeArgumentsMap) {
    if (typeArgumentsMap.containsKey(type)) {
      this.type = type = typeArgumentsMap[type];
    } else {
      this.type = type;
    }
    fullName = type.name;
    if (typeMap.allTypesByType.containsKey(type)) {
      fullName = typeMap.allTypesByType[type].fullName;
      element = typeMap.allTypesByType[type].element;
    }
    if (type is ParameterizedType) {
      for (DartType def in typeMap.allTypesByType.keys) {
        if (def is ParameterizedType) {
          if (def.typeArguments.length == type.typeArguments.length) {
            DartType instantiated = def.instantiate(type.typeArguments);
            if (instantiated == type) {
              genericType = def;
              fullName = typeMap.allTypesByType[def].fullName;
              genericElement = typeMap.allTypesByType[def].element;
            }
          }
        }
      }
    }
    //resolveToBound <<
    if (type.displayName.endsWith('>')) {
      for (var arg in (type as ParameterizedType).typeArguments) {
        typeArguments.add(TypeInfo.fromType(typeMap, arg, typeArgumentsMap));
      }
    }
  }

  String get displayName {
      return '${fullName}' + (typeArguments.isNotEmpty ? '<${typeArguments.map((e)=>e.displayName).join(',')}>' : '');
  }

  String get flatName {
    return '${fullName.replaceAll('.', '_')}' + (typeArguments.isNotEmpty ? '_${typeArguments.map((e)=>e.displayName).join('_')}_' : '');
  }

  String get creatorName {
    if (hasInterceptor()) {
      return '\$${fullName.replaceAll('.', '_')}' + (typeArguments.isNotEmpty ? '_${typeArguments.map((e)=>e.displayName).join('_')}_' : '');
    } else {
      return '${displayName}';
    }
  }

  String generateCompiledConstructorDefinition() {
    return '\$${fullName.replaceAll('.', '_')}' + '(' + allRequiredFields().map((f) => f.name).join(',') + ') {\n';
  }

  Iterable<FieldElement> allRequiredFields() {
    return allFields().where((f) => elementInjectionType(f) == '@Require');
  }

  List<String> generateCreator() {
    List<String> lines = [];
    lines.add('new ${creatorName}(' + allRequiredFields().map((f) => f.name).join(',') + ')');
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

  String elementInjectionType(Element element) {
    for (var metadataElement in element.metadata) {
      if (decorators.contains(metadataElement.toSource())) {
        return metadataElement.toSource();
      }
    }
    return null;
  }

  String getFieldInitializationValue(TypeInfo fieldType, FieldElement field) {
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
        break;
      case '@InjectInstances':
          TypeInfo type = fieldType.typeArguments[1];
          typeMap.subtypeInstanes[type.displayName] = type;
          return '\$om.instancesOf${type.flatName}';
      case '@InjectClassName':
        return '"' + displayName + '"';
      case '@InjectClassNames':
        List<String> names = [];
        if (field.enclosingElement != element) {
          names.add(displayName);
          for (var st in element.allSupertypes) {
            if (field.enclosingElement == st.element) break;
            names.add(new TypeInfo.fromType(typeMap, st, typeArgumentsMap()).displayName);
          }
        }
        return '[' + names.reversed.map((s)=>"'$s'").join(',') + ']';
      default:
        return null;
    }
  }

  String getFieldAssignmentValue(FieldElement field) {

      TypeInfo fieldType = new TypeInfo.fromType(typeMap, field.type, typeArgumentsMap());

      switch (elementInjectionType(field)) {
        case '@Require':
            return field.name;
        case '@InjectFields':
            String args = allFields().where((f) => f.type.getDisplayString() != 'dynamic').map((e) => '\'${e.name}\':this.${e.name}').join(',');
            return 'new ${fieldType.type.getDisplayString()}({${args}});\n';
      }
      return null;
  }

  List<ClassElement> classPath() {
    List<ClassElement> path = [this.element];

    for (var st in element.allSupertypes) {
      if (st.isObject) {
          break;
      }
      path.add(st.element);
    }
    return path;
  }

  bool canBeSingleton() {
    if (element.typeParameters.length > 0) {
      return false;
    }
    if (allRequiredFields().length > 0) {
      return false;
    }
    for (var c in classPath()) {
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
    if (element != null) {
      for (var c in classPath()) {
        for (var metadataElement in c.metadata) {
          if (metadataElement.toSource() == '@Compose') {
            return true;
          }
          if (metadataElement.toSource() == '@ComposeSubtypes') {
            return c != element;
          }
        }
      }
    }
    return false;
    /*
    if (element.isAbstract) {
      return false;
    }

    for (var c in element.constructors) {
      if (c.isDefaultConstructor) {
        return true;
      }
    }
    return false;
    */
  }

  List<FieldElement> allFields() {
    List<FieldElement> allFields = [];
    if (element == null) return allFields;

    for (var st in element.allSupertypes) {
        if (st.isObject) {
            break;
        }
        for (var f in st.element.fields) {
          if (!f.name.startsWith('_'))
            allFields.add(f);
        }
    }

    element.fields.forEach((f){
      if (!f.name.startsWith('_'))
        allFields.add(f);
    });
    return allFields;
  }

  List<MethodElement> allMethods() {
    List<MethodElement> allMethods = [];

    for (var st in element.allSupertypes) {
        if (st.isObject) {
            break;
        }
        for (var m in st.element.methods) {
          //if (!m.name.startsWith('_'))
            allMethods.add(m);
        }
    }

    element.methods.forEach((m){
      //if (!m.name.startsWith('_'))
        allMethods.add(m);
    });
    return allMethods;
  }

  Map<DartType, DartType> typeArgumentsMap() {
    Map<DartType, DartType> typeArgumentsMap = {};
    for (var st in element.allSupertypes) {
        if (st.isObject) {
            break;
        }
        int j = 0;
        st.typeParameters.forEach((tp){
            typeArgumentsMap[tp.type] = st.typeArguments[j++];
        });
    }

    element.typeParameters.forEach((tp){
        //typeArgumentsMap[tp.type] = element.typeArguments[j++];
    });


    return typeArgumentsMap;
  }

  List<TypeInfo> plugins;

  Future<List<String>> generateInterceptor() async {
    List<String> lines = [];

    lines.add("//interceptor for ${displayName}");
    for (var k in typeArgumentsMap().keys) {
      lines.add("//${k.getDisplayString()}[${k.hashCode.toString()}] => ${typeArgumentsMap()[k].getDisplayString()}[${typeArgumentsMap()[k].hashCode.toString()}]");
    }
    lines.add("//can be singleton: ${canBeSingleton()?'TRUE':'FALSE'}");
    for (var s in classPath()) {
      lines.add("//parent: ${s.displayName} ${s.metadata.toString()}");
    }

    //lines.add("//config: ${json.encode(typeConfig)}");

    plugins = typeMap.getPluginsForType(this);

    var typeArgsList = element.typeParameters.map((e) {
      return e.name + (e.bound != null ? " extends " + (new TypeInfo.fromType(this.typeMap, e.bound, this.typeArgumentsMap())).fullName : '');
    }).join(',');
    var typeArgs = element.typeParameters.isNotEmpty ? "<" + typeArgsList + ">" : '';

    var shortArgs = element.typeParameters.isNotEmpty ? "<${element.typeParameters.map((e) => e.name).join(',')}>" : '';


    lines.add('class \$$flatName$typeArgs extends $displayName$shortArgs implements Pluggable {');

    for (var p in plugins) {
      lines.add('${p.fullName} ${p.flatName[0].toLowerCase()}${p.flatName.substring(1)};');
    }

    lines.add(generateCompiledConstructorDefinition());


    allFields().forEach((fieldElement){
      if (fieldElement.setter != null) {
        lines.add("//${fieldElement.type.getDisplayString()}");
        //typeArgumentsMap());

        if (elementInjectionType(fieldElement) == '@Create') {
          lines.add("//create");
          //TMP
          TypeInfo ti = TypeInfo.fromType(typeMap, fieldElement.type, typeArgumentsMap());

          TypeInfo candidate = typeMap.getBestCandidate(ti);
          if (candidate != null) {
            lines.add('this.${fieldElement.name} = ');
            lines.addAll(candidate.generateCreator());
            lines.add(';');
          }
        } else {
          String value = getFieldAssignmentValue(fieldElement);
          if (value != null) {
            lines.add(
              'this.${fieldElement.name} = ' + value + ';'
            );
          }
        }
      }
    });

    for (var p in plugins) {
      lines.add(
        "${p.flatName[0].toLowerCase()}${p.flatName.substring(1)} = new ${p.creatorName}(this);"
      );
    }
    lines.add('}');

    //TODO if pluggable
    lines.add("T plugin<T>() {");
    for (var p in plugins) {
      lines.add("if (T == ${p.fullName}) {");
      lines.add("return ${p.flatName[0].toLowerCase()}${p.flatName.substring(1)} as T;");
      lines.add("}");
    }
    lines.add("return null;");
    lines.add("}");

    allFields().forEach((fieldElement){

        TypeInfo fieldType = new TypeInfo.fromType(typeMap, fieldElement.type, typeArgumentsMap());
        //fieldElement.type.isDartAsyncFutureOr
        String value = getFieldInitializationValue(fieldType, fieldElement);
        if (value != null) {
          lines.add(
            "${fieldType.displayName} get ${fieldElement.name} => ${value};"
          );
        }
    });

    allMethods().forEach((methodElement){
      List<String> methodLines = generateMethodOverride(methodElement);
      if (methodLines.length > 0) {

        TypeInfo returnType = new TypeInfo.fromType(typeMap, methodElement.returnType, typeArgumentsMap());
        var typeArgsList = methodElement.typeParameters.map((e) {
          return e.name + (e.bound != null ? " extends " + (new TypeInfo.fromType(this.typeMap, e.bound, this.typeArgumentsMap())).fullName : '');
        }).join(',');
        var typeArgs = typeArgsList.isNotEmpty ? "<" + typeArgsList + ">" : '';

        lines.add("${returnType.displayName} ${methodElement.name}${typeArgs}(");
        lines.add(methodElement.parameters.map((mp){
          TypeInfo parameterType = new TypeInfo.fromType(typeMap, mp.type, typeArgumentsMap());
          return "${parameterType.displayName} ${mp.name}";
        }).join(","));

        lines.add("){");
        lines.addAll(methodLines);
        lines.add("}");
      }

    });

    for (var fieldElement in allFields()) {
      for (var metadataElement in fieldElement.getter.metadata) {
        if (metadataElement.toSource() == '@Template') {
          String templateBody = null;
          for (var p in typeMap.modulesPaths.reversed) {
            String filePath = p + '/templates/' + flatName + '.' + fieldElement.name;
            bool use = false;
            if (templateBody == null) {
              File file = new File(filePath);
              if (file.existsSync()) {
                templateBody = await file.readAsString();
                use = true;
              }
            }
            lines.add('//' + filePath + (use ? ' USED' : ''));
          }
          if (templateBody != null) {
            lines.add("${fieldElement.type.toString()} get ${fieldElement.name} => \'\'\'");
            lines.add(templateBody);
            lines.add("\'\'\';");
          }
        }
      }
    };

    lines.add('}');

    return lines;
  }

  List<String> generateMethodOverride(MethodElement methodElement) {
    TypeInfo returnType = new TypeInfo.fromType(typeMap, methodElement.returnType, typeArgumentsMap());
    List<String> lines = [];
    if (elementInjectionType(methodElement) == '@Factory' ||
      elementInjectionType(methodElement) == '@SubtypeFactory' ||
      elementInjectionType(methodElement) == '@InjectSubtypesNames') {

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
      } else if (elementInjectionType(methodElement) == '@InjectSubtypesNames') {
        var bound = new TypeInfo.fromType(this.typeMap, methodElement.typeParameters[0].bound, this.typeArgumentsMap());
        for (var type in typeMap.getNonAbstractSubtypes(bound)) {
          lines.add('if (T == ${type.fullName}) return \'${type.fullName}\';');
        }
      } else {
        var best = typeMap.getBestCandidate(returnType);
        lines.add('//' + returnType.fullName);
        if (best != null) {
          lines.add('return ');
          lines.addAll(best.generateCreator());
          lines.add(';');
        }
      }
    } else if (elementInjectionType(methodElement) == '@Compile') {

      //TODO: add original method ??
      allMethods().forEach((methodPartElement){
        if (methodPartElement.name.startsWith('_' + methodElement.name)) {
          if (elementInjectionType(methodPartElement) == '@CompilePart') {
            String part = methodPartElement.getSourceCode();
            lines.add(part);
          } else if (elementInjectionType(methodPartElement) == '@CompileFieldsOfType') {

            String requireAnnotation = null;
            for (var m in methodPartElement.metadata) {
              if (m.toSource().startsWith('@AnnotatedWith(')) {
                requireAnnotation = '@' + m.toSource().substring(15, m.toSource().length - 1);
                lines.add('//' + requireAnnotation);
              }
            }

            var fieldType = new TypeInfo.fromType(typeMap, methodPartElement.parameters.last.type, typeArgumentsMap());
            allFields().forEach((f){
              if (typeMap.library.typeSystem.isSubtypeOf(f.type, fieldType.type)) {

                if (requireAnnotation != null) {
                  bool pass = false;
                  for (var m in f.metadata) {
                    if (m.toSource() == requireAnnotation) pass = true;
                  }
                  if (!pass) return;
                }

                String part = methodPartElement.getSourceCode();
                part = part.replaceAll('name', '\'${f.name}\'');
                part = part.replaceAll('field', 'this.${f.name}');
                lines.add(part);
              }
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
        lines.add('args = ${beforePlugins[pluginMethod].flatName}.${pluginMethod.name}($beforeArgsStr);');
      }
      if (beforePlugins.length > 0) {
        int i = 0;
        methodElement.parameters.forEach((mp) {
          lines.add('${mp.name} = args[$i];');
          i++;
        });
      }
      if (beforePlugins.length + afterPlugins.length > 0) {
        lines.add('var ret = super.${methodElement.name}($paramsStr);');
      }
      for (var pluginMethod in afterPlugins.keys) {
        lines.add('ret = ${afterPlugins[pluginMethod].flatName}.${pluginMethod.name}(ret);');
      }
      if (beforePlugins.length + afterPlugins.length > 0) {
        lines.add('return ret;');
      }
    }
    return lines;
  }

}

class TypeMap {

  List<String> modulesPaths = [];

  LibraryElement library;
  Map<LibraryElement, String> libraryPrefixes = {};

  Map<String, TypeInfo> allTypes = {};
  Map<DartType, TypeInfo> allTypesByType = {};

  Map<String, TypeInfo> subtypeInstanes = {};

  bool registerElement(String fullname, Element element) {
    if (element is ClassElement) {
      //ret += '//lib ${fullname}\n';
      allTypesByType[element.thisType] = allTypes[fullname] = new TypeInfo(this, fullname, element);
      return true;
    }
    return false;
  }

  TypeInfo getBestCandidate(TypeInfo type) {

    List<TypeInfo> candidates = getNonAbstractSubtypes(type);

    candidates.sort((t1, t2) => library.typeSystem.isSubtypeOf(t1.type, t2.type) ? 1 : 0);

    if (candidates.length > 1) {
      //throw new Exception('too many ${type.displayName}');
    }
    if (candidates.length == 0) {
      return null;
      /*for ( var c in candidates) {
        ret += '//can:' + c.displayName + '\n';
      }*/
    }
    return candidates[0];
  }

  String generateTypeGetter(TypeInfo type) {
    TypeInfo candidate = getBestCandidate(type);
    if (candidate == null) {
      return 'null /* no candidate for ${type.displayName}*/';
      //throw new Exception('No instantiation candidate for ${type.displayName}');
    }

    String getterName = candidate.flatName[0].toLowerCase() + candidate.flatName.substring(1);
    return '\$om.${getterName}';
  }

  List<TypeInfo> getPluginsForType(TypeInfo type){
      List<TypeInfo> plugins = [];
      allTypes.forEach((name, ce){
          //if (!ce.element.isAbstract) {
            ce.element.allSupertypes.forEach((st){
              if (st.name == 'TypePlugin' && st.typeArguments.length == 1 && library.typeSystem.isAssignableTo(st.typeArguments[0], type.type)) {
                plugins.add(ce);
              }
            });
          //}
      });
      return plugins;
  }

  List<TypeInfo> getNonAbstractSubtypes(TypeInfo parentType) {
    return allTypes.values.where((type){
      if (type.element == null) return false;

      if (!type.hasInterceptor() && type.element.isAbstract) return false;

      bool fits = false;

      if (type.displayName == parentType.displayName) {
        return true;
      }

      type.element.allSupertypes.forEach((st){
        bool parentFits = true;
        //isSubtype = isSubtype || i.displayName == parentType.displayName;
        parentFits = parentFits & (st.name == parentType.type.name);
        if (parentType.typeArguments.length == st.typeArguments.length) {
          for (var i=0; i < parentType.typeArguments.length; i++) {
            parentFits = parentFits && (
              (parentType.typeArguments[i].type.getDisplayString() == st.typeArguments[i].getDisplayString())
              ||
              library.typeSystem.isSubtypeOf(st.typeArguments[i], parentType.typeArguments[i].type)
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

class CompiledOmGenerator {

  TypeMap typeMap = new TypeMap();

  Map<String,dynamic> config = {};

  Map getClassConfig(ClassElement classElement) {
    Map<dynamic, dynamic> classConfig = {};
    for (var st in classElement.allSupertypes.reversed) {
      if (config.containsKey(st.getDisplayString())){
        //ret += '//' + ;
        classConfig.addAll(config[st.getDisplayString()]);
      }
    }

    if (config.containsKey(classElement.name)){
      classConfig.addAll(config[classElement.name]);
    }
    return classConfig;
  }


  List<String> generateObjectManager() {
    List<String> lines = [];
    lines.add('class \$ObjectManager {');
    for (var type in typeMap.allTypes.values) {
      if (type.canBeSingleton()) {

        String getterName = type.flatName[0].toLowerCase() + type.flatName.substring(1);
        lines.add('${type.creatorName} _${getterName};');
        lines.add('${type.creatorName} get ${getterName} {');
        lines.add('if(_${getterName} == null){');
        lines.add('_${getterName} = ');
        lines.addAll(type.generateCreator());
        lines.add(';');
        lines.add('}');
        lines.add('return _${getterName};');
        lines.add('}');
      }
    }


    typeMap.subtypeInstanes.values.forEach((typeInfo){
      lines.add('Map<String, ${typeInfo.fullName}> get instancesOf${typeInfo.flatName} {');
      lines.add('return {');
      typeMap.getNonAbstractSubtypes(typeInfo).forEach((subtypeInfo){
        if (subtypeInfo.allRequiredFields().length == 0) {
          lines.add('"${subtypeInfo.displayName}": ');
          lines.addAll(subtypeInfo.generateCreator());
          lines.add(',');
        }
        });
      lines.add('};');
      lines.add('}');
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

    lines.add('}');
    lines.add('\$ObjectManager \$om = new \$ObjectManager();');
    return lines;
  }

  Future<String> generate(LibraryReader library, Map config) async {
    this.config = config;
    typeMap.library = library.element;

    var generationStart = new DateTime.now().millisecondsSinceEpoch;

    List<String> lines = [];

    try {
      for (var importElement in library.element.imports) {
        if (importElement.prefix != null) {
          typeMap.libraryPrefixes[importElement.library] = importElement.prefix.name;
        }

        if (!importElement.importedLibrary.isDartCore) {
          importElement.namespace.definedNames.forEach(typeMap.registerElement);
        }
      }
      library.allElements.forEach((element) => typeMap.registerElement(element.name, element));

      for (var s in typeMap.allTypes.keys) {
          typeMap.allTypes[s].typeConfig = getClassConfig(typeMap.allTypes[s].element);
          if (typeMap.allTypes[s].hasInterceptor()) {
            lines.add("//interceptor for [${typeMap.allTypes[s].fullName}]");
            lines.addAll(await typeMap.allTypes[s].generateInterceptor());
          } else {
            lines.add("//no interceptor for [${typeMap.allTypes[s].fullName}]");
          }
      };

      lines.addAll(generateObjectManager());



      var generationEnd = new DateTime.now().millisecondsSinceEpoch;
      lines.add('//generated in ${generationEnd - generationStart}ms\n');

    } catch(e, stacktrace) {
      return '/* unhandled code generator exception: \n' + e.toString() + '\n' + stacktrace.toString() + '*/';
    }
    return lines.join('\n');

  }

}

extension MergeMap on Map {
  void merge(Map other) {
   for (var key in other.keys) {
     if (this.containsKey(key) && this[key] is Map) {
       (this[key] as Map).merge(other[key]);
     } else {
       this[key] = other[key];
     }
   }
  }
}

class SwiftGenerator extends Generator {

  const SwiftGenerator();
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep step) async {

    if (library.element.parts.isNotEmpty) { // && library.element.parts.first.name.endsWith('.c.dart')

      CompiledOmGenerator generator = new CompiledOmGenerator();

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

      List<String> libraryFiles = [];
      library.element.imports.forEach((e){
        if (e.uri != null && !e.uri.startsWith('dart:')) {
            AssetId id = AssetId.resolve(e.uri, from:step.inputId);
            libraryFiles.add(packagesMap[id.package] + id.path);
        }
      });
      libraryFiles.add(Directory.current.path + '/' + step.inputId.path);

      Map<String,dynamic> config = {};

      for (var path  in libraryFiles){
        generator.typeMap.modulesPaths.add(dirname(dirname(path)));
        path = path.replaceFirst('.dart', '.di.yaml', path.length - 5);
        File configFile = new File(path);
        if (configFile.existsSync()) {
          var yaml = loadYaml(await configFile.readAsString());
          if (yaml is YamlMap){
            config.merge(yaml.value);
          }
        }
      };

      return generator.generate(library, config);
    }
    return null;
  }

}

PartBuilder swiftBuilder(_) {
  print(_);
  return new PartBuilder([const SwiftGenerator()], '.c.dart');
}
