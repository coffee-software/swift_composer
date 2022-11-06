library swift_composer;

import 'dart:convert';

import 'package:path/path.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'dart:async';
import 'dart:io';
import 'package:yaml/yaml.dart';

import 'type_info.dart';
import 'tools.dart';

class ImportedModule {
  String name;
  String filePath;
  String? prefix;
  String packagePath;
  ImportedModule(this.name, this.filePath, this.packagePath, {this.prefix});
}

class CompiledOmGenerator implements TemplateLoader {

  TypeMap typeMap;
  LibraryReader library;
  BuildStep step;
  OutputWriter output;
  bool debug;

  DiConfig config;
  List<ImportedModule> modules = [];

  CompiledOmGenerator(this.output, this.library, this.step, this.config, this.debug) :
        typeMap = new TypeMap(output, library.element.typeSystem, config);

  String? load(String name) {
    for (var module in modules.reversed) {
      String searchName = name;
      if (searchName.startsWith(module.name + '_')) {
        searchName = searchName.replaceFirst(module.name + '_', '');
      }
      String filePath = module.packagePath + '/lib/widgets/' + searchName;
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
      output.writeLn('Map<String, ${typeInfo.uniqueName}>? _instancesOf${typeInfo.flatName};');
      output.writeLn('Map<String, ${typeInfo.uniqueName}> get instancesOf${typeInfo.flatName} {');
      output.writeLn('if (_instancesOf${typeInfo.flatName} != null) return _instancesOf${typeInfo.flatName}!;');
      output.writeLn('return _instancesOf${typeInfo.flatName} = {');

      typeMap.getNonAbstractSubtypes(typeInfo).forEach((subtypeInfo){
        if (subtypeInfo.allRequiredFields().length == 0) {
          output.writeLn('"${subtypeInfo.displayName}": ');
          output.writeLn(subtypeInfo.varName);
          //output.writeMany(subtypeInfo.generateCreator());
          output.writeLn(',');
        } else {
          output.writeLn('//${subtypeInfo.displayName} requires a param');
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

    File packagesFile = new File(Directory.current.path + '/.dart_tool/package_config.json');
    var packagesInfo = jsonDecode(packagesFile.readAsStringSync());
    for (var i = 0; i < packagesInfo['packages'].length; i++) {
      String name = packagesInfo['packages'][i]['name'];
      String root = packagesInfo['packages'][i]['rootUri'];
      if (root.startsWith('file://')) {
        root = root.replaceFirst('file://', '');
      }
      if (!root.startsWith('/')) {
        root = Directory.current.path + '/.dart_tool/' + root;
      }
      packagesMap[name] = root;
    }

    library.element.imports.forEach((import) {
      if (import.uri == null) {
        return;
      }

      if (import.uri!.indexOf(':') > -1) {
        String schema = import.uri!.substring(0, import.uri!.indexOf(':'));
        if (schema != 'package') {
          return;
        }
        String package = import.uri!.substring(
            import.uri!.indexOf(':') + 1, import.uri!.indexOf('/'));
        if (packagesMap.containsKey(package)) {
          String file = import.uri!.substring(import.uri!.indexOf('/') + 1);
          modules.add(new ImportedModule(
              package,
              packagesMap[package]! + '/lib/' + file,
              packagesMap[package]!,
              prefix: import.prefix?.name
          ));
        }
      } else {

        modules.add(new ImportedModule(
            'application',
            dirname(Directory.current.path + '/' + step.inputId.path) + '/' + import.uri!,
            Directory.current.path + '/',
            prefix: import.prefix?.name
        ));
      }
    });
    modules.add(new ImportedModule(
        'application',
        Directory.current.path + '/' + step.inputId.path,
        Directory.current.path + '/'
    ));
  }

  /**
   *
   */
  Future<void> _loadConfig() async {
    for (var module in modules) {
      String path = module.filePath.replaceFirst(
          '.dart', '.di.yaml', module.filePath.length - 5);
      File configFile = new File(path);
      if (configFile.existsSync()) {
        output.writeLn(
            '// config file for ' + (module.prefix ?? 'root') + ': ' + path);
        var yaml = loadYaml(await configFile.readAsString());
        if (yaml is YamlMap) {
          config.append(yaml.value, module.prefix);
        }
      } else {
        output.writeLn(
            '// no config file for ' + (module.prefix ?? 'root') + ': ' + path);
      }
    };
    var configDir = new Directory('config');
    if (configDir.existsSync()) {
      for (var file in configDir.listSync(recursive: true).where((element) => element is File)) {
        if (file.path.endsWith('.yaml')) {
          var name = file.path
              .split('/')
              .last;
          name = name.substring(0, name.length - 5);
          String content = await File(file.path).readAsStringSync();
          output.writeLn('// config file for module_' + name + ' ' + file.path);
          var yaml = loadYaml(content);
          if (yaml is YamlMap) {
            config.append(yaml.value, 'module_' + name);
          }
        }

      }
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
      output.writeSplit();
      output.writeLn('// CONFIG');
      await _loadLibraryFiles();
      await _loadConfig();
      output.writeSplit();
      output.writeLn('// MERGED CONFIG');
      this.config.config.forEach((key, value) {
        output.writeLn("// ${key}: ${value}");
      });
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

      if (debug) {
        output.writeLn('// ALL TYPES INFO');
        output.writeSplit();
        typeMap.allTypes.forEach((key, value) {
          output.writeLn('// ' + key + ' => ' + value.debugInfo);
        });
      }

      for (int i=0; i < typeMap.allTypes.keys.length; i++) {
        output.writeSplit();
        TypeInfo type = typeMap.allTypes[typeMap.allTypes.keys.elementAt(i)!]!;
        if (type.hasInterceptor() && !type.isNullable) {
          output.writeLn("// interceptor for [${type.uniqueName}]");
          if (debug) {
            await type.writeDebugInfo(output);
          }
          await type.generateInterceptor(output, this);
        } else {
          output.writeLn("// no interceptor for [${type.uniqueName}]");
          if (debug) {
            await type.writeDebugInfo(output);
          }
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

  final BuilderOptions options;

  const SwiftGenerator(this.options);

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep step) async {
    bool debug = options.config.containsKey('debug') ? options.config['debug'] : false;
    if (library.element.parts.isNotEmpty) {
      return await (
          new CompiledOmGenerator(
              new OutputWriter(debug),
              library,
              step,
              new DiConfig(),
              debug
          )
      ).generate();
    }
    return null;
  }

}

PartBuilder swiftBuilder(BuilderOptions options) {
  return new PartBuilder([new SwiftGenerator(options)], '.c.dart');
}
