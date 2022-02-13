library swift_composer;

import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'dart:async';
import 'dart:io';
import 'package:yaml/yaml.dart';

import 'type_info.dart';
import 'tools.dart';



class ImportedModule {
  String filePath;
  String? prefix;
  String packagePath;
  ImportedModule(this.filePath, this.packagePath, {this.prefix});
}

class CompiledOmGenerator implements TemplateLoader {

  TypeMap typeMap;
  LibraryReader library;
  BuildStep step;
  OutputWriter output;

  DiConfig config;
  List<ImportedModule> modules = [];

  CompiledOmGenerator(this.output, this.library, this.step, this.config) :
        typeMap = new TypeMap(output, library.element.typeSystem, config);

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
        output.writeLn('// config file for ' + (module.prefix ?? 'root') + ': ' + path);
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
          importElement.namespace.definedNames.forEach((key, value) {
            //output.writeLn('//' + key + ' ' + value.displayName + ' ' + value.getExtendedDisplayName('test') + " ${value.hashCode}");
          });
          //importedLibrariesMap[importElement!.importedLibrary!] = importElement.prefix == null ? null : importElement.prefix!.name;
          //output.writeLn('// import ' + (importElement.importedLibrary?.identifier ?? 'null') + (importElement.prefix == null ? '' : ' as ' + importElement.prefix!.name));
          importElement.namespace.definedNames.forEach(typeMap.registerClassElement);
        }
      }
      library.allElements.forEach((element) => typeMap.registerClassElement(element.name!, element));
      //DEBUG INFO

      new Map<String, TypeInfo>.from(typeMap.allTypes).forEach((key, value) {
        value.preAnaliseAllUsedTypes();
      });

      output.writeLn('// ALL TYPES INFO');
      output.writeSplit();
      typeMap.allTypes.forEach((key, value) {
        output.writeLn('// ' + key + ' => ' + value.debugInfo);
      });

      for (int i=0; i < typeMap.allTypes.keys.length; i++) {
        output.writeSplit();
        TypeInfo type = typeMap.allTypes[typeMap.allTypes.keys.elementAt(i)!]!;
        if (type.hasInterceptor()) {
          output.writeLn("// interceptor for [${type.uniqueName}]");
          await type.writeDebugInfo(output);
          await type.generateInterceptor(output, this);
        } else {
          output.writeLn("// no interceptor for [${type.uniqueName}]");
          await type.writeDebugInfo(output);
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
