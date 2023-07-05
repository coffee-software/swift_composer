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

class TemplateLocation {
  ImportedModule module;
  String path;
  File file;
  TemplateLocation(this.module, this.path, this.file);
}

class GenerationTimer {

  GenerationTimer();

  List<String> path = [];
  List<DateTime> starts = [];

  Map<String, int> times = {};

  void start(String name) {
    path.add(name);
    starts.add(new DateTime.now());

  }

  void end() {
    String p = path.join('.');
    path.removeLast();
    var start = starts.removeLast();
    int ms = (new DateTime.now()).millisecondsSinceEpoch - start.millisecondsSinceEpoch;

    if (times.containsKey(p)) {
      times[p] = times[p]! + ms;
    } else {
      times[p] = ms;
    }
  }

  void print(OutputWriter output, bool detailed) {
    if (detailed) {
      output.writeLn('// generation times');
      for (var t in times.keys) {
        output.writeLn('// ${t} = ${times[t]}ms\n');
      }
    } else {
      output.writeLn("// generated in ${times['composer']}ms");
    }
  }
}

class CompiledOmGenerator implements TemplateLoader {

  TypeMap typeMap;
  LibraryReader library;
  BuildStep step;
  OutputWriter output;
  bool debug;
  GenerationTimer timer;

  DiConfig config;
  List<ImportedModule> modules = [];

  CompiledOmGenerator(this.output, this.library, this.step, this.config, this.timer, this.debug) :
        typeMap = new TypeMap(output, library.element.typeSystem, step, config);

  TemplateLocation? openTemplate(String name) {
    for (var module in modules.reversed) {
      String searchName = name;
      if (searchName.startsWith(module.name + '_')) {
        searchName = searchName.replaceFirst(module.name + '_', '');
      }
      if (searchName.endsWith('.scss') && module.name == 'application') {
        //prevent scss parts from being build
        searchName = '_' + searchName;
      }
      String filePath = module.packagePath + '/lib/widgets/' + searchName;
      File file = new File(filePath);
      if (file.existsSync()) {
        return TemplateLocation(module, '/lib/widgets/' + searchName, file);
      }
    }
    return null;
  }

  String? load(String name) {
    TemplateLocation? file = openTemplate(name);
    if (file != null) {
      return file.file.readAsStringSync();
    }
    return null;
  }

  void generateSubtypesOf() {
    typeMap.subtypesOf.values.forEach((typeInfo) {

      output.writeLn('class \$SubtypesOf' + typeInfo.flatName + ' extends SubtypesOf<' + typeInfo.uniqueName + '> {');
      output.writeLn('String getCode<X extends ' + typeInfo.uniqueName + '>(){');
      for (var type in typeMap.getNonAbstractSubtypes(typeInfo)) {
        output.writeLn('if (X == ${type.fullName}) return \'${type.fullName}\';');
      }
      output.writeLn('throw new Exception(\'no code for type\');');
      output.writeLn('}');
      output.writeLn('List<String> get allClassNames => [');
      for (var type in typeMap.getNonAbstractSubtypes(typeInfo)) {
        output.writeLn('\'${type.fullName}\',');
      }
      output.writeLn('];');

      output.writeLn('Map<String, String> get baseClassNamesMap => {');
      for (var type in typeMap.getNonAbstractSubtypes(typeInfo)) {
        String baseClassName = type.fullName;
        for (var parentType in type.allTypeInfoPath()){
          if (parentType.element!.metadata.where((element) => element.toSource() == '@ComposeSubtypes').isNotEmpty) {
            break;
          }
          baseClassName = parentType.fullName;
        }
        output.writeLn('\'${type.fullName}\' : \'${baseClassName}\',');
      }
      output.writeLn('};');

      output.writeLn('}');
    });
  }

  void generateObjectManager() {
    output.writeLn('class \$ObjectManager {');
    for (var type in typeMap.allTypes.values) {
      if (type.canBeSingleton()) {

        String getterName = type.varName;
        output.writeLn('${type.creatorName}? _${getterName};');
        output.writeLn('${type.creatorName} get ${getterName} {');
        output.writeLn('if(_${getterName} == null){');
        output.writeLn('_${getterName} = ' + type.generateCreator() + ';');
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
          output.writeLn('"${subtypeInfo.fullName}": ');
          output.writeLn(subtypeInfo.varName);
          //output.writeMany(subtypeInfo.generateCreator());
          output.writeLn(',');
        } else {
          output.writeLn('//${subtypeInfo.fullName} requires a param');
        }
      });
      output.writeLn('};');
      output.writeLn('}');
    });

    typeMap.subtypeFactories.forEach((key, subtypeFactoryInfo) {
      output.writeLn('${subtypeFactoryInfo.returnType.uniqueName} ${key} {');

      output.writeLn('switch(className){');
      for (var type in typeMap.getNonAbstractSubtypes(subtypeFactoryInfo.returnType)) {
        //TODO compare parameters by types and names?
        //type.allRequiredFields().map((f) => f.name).join(',');
        if (type.allRequiredFields().length == subtypeFactoryInfo.arguments.length - 1) {
          output.writeLn('case \'${type.fullName}\':');
          output.writeLn('return ' + type.generateCreator() + ';');
        }
      }
      output.writeLn('}');
      output.writeLn('throw new Exception(\'no type for \' + className);');
      output.writeLn('}');
    });
    typeMap.subtypesOf.values.forEach((typeInfo) {
      output.writeLn('SubtypesOf<${typeInfo.uniqueName}> subtypesOf${typeInfo.flatName} = new \$SubtypesOf' + typeInfo.flatName + '();');
    });

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

    library.element.libraryImports.forEach((import) {

      if (!(import.uri is DirectiveUriWithRelativeUriString)) {
        return;
      }
      String stringUri = (import.uri as DirectiveUriWithRelativeUriString).relativeUriString;

      if (stringUri.indexOf(':') > -1) {
        String schema = stringUri.substring(0, stringUri.indexOf(':'));
        if (schema != 'package') {
          return;
        }
        String package = stringUri.substring(
            stringUri.indexOf(':') + 1, stringUri.indexOf('/'));
        if (packagesMap.containsKey(package)) {
          String file = stringUri.substring(stringUri.indexOf('/') + 1);
          modules.add(new ImportedModule(
              package,
              packagesMap[package]! + '/lib/' + file,
              packagesMap[package]!,
              prefix: import.prefix?.element.name
          ));
        }
      } else {

        modules.add(new ImportedModule(
            'application',
            dirname(Directory.current.path + '/' + step.inputId.path) + '/' + stringUri,
            Directory.current.path + '/',
            prefix: import.prefix?.element.name
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
      String path = module.filePath.replaceFirst('.dart', '.di.yaml', module.filePath.length - 5);
      File configFile = new File(path);
      if (configFile.existsSync()) {
        output.writeLn(
            '// config file for ' + (module.prefix ?? 'root') + ': ' + relative(path));
        var yaml = loadYaml(await configFile.readAsString());
        if (yaml is YamlMap) {
          config.append(yaml.value, module.prefix);
        }
      } else {
        output.writeLn(
            '// no config file for ' + (module.prefix ?? 'root') + ': ' + relative(path));
      }
    }
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
  Future<void> _buildWidgetsIndex() async {

    String widgetsIndexPath = Directory.current.path + '/' + step.inputId.path;
    String widgetsDirName = widgetsIndexPath.substring(0, widgetsIndexPath.lastIndexOf('/') + 1);
    String widgetsFileName = widgetsIndexPath.substring(widgetsIndexPath.lastIndexOf('/') + 1);
    widgetsIndexPath = widgetsDirName + '_' + widgetsFileName.replaceFirst('.dart', '_widgets.scss');
    File widgetsIndex = new File(widgetsIndexPath);
    List<String> widgetsIndexContent = [];
    //unique set to generate Generic widgets once.
    Set<String> widgetsSet = new Set<String>();
    if (widgetsIndex.existsSync()) {
      if (typeMap.allTypes.containsKey('module_core.Widget')) {
        for (var type in typeMap.getNonAbstractSubtypes(typeMap.allTypes['module_core.Widget']!)) {
          widgetsSet.add(type.fullName.replaceAll('.', '_'));
        }
      }
      for (var widgetName in widgetsSet) {
        var templateFile = openTemplate(widgetName + '.scss');
        if (templateFile != null) {
          //relativePath =
          //output.writeLn('// file: ${templateFile.module.name} ${templateFile.path} ${templateFile.file.path}');
          widgetsIndexContent.add('.${widgetName} {');
          if (templateFile.module.name == 'application') {
            String relPath = relative(Directory.current.path + '/' + templateFile.path, from:dirname(widgetsIndexPath));
            widgetsIndexContent.add('    @import \"${relPath}\"');
          } else {
            widgetsIndexContent.add('    @import \"package:${templateFile.module.name}${templateFile.path.replaceFirst('/lib', '')}\"');
          }
          widgetsIndexContent.add('}');
          var content = widgetsIndexContent.join("\n");
          if (widgetsIndex.readAsStringSync() != content) {
            //avoid rebuilding scss
            widgetsIndex.writeAsStringSync(content);
          }
        }
      }
    }
  }

  /**
   *
   */
  Future<String> generate() async {

    timer.start('composer');
    try {
      output.writeSplit();
      output.writeLn('// generated by swift_composer at ' + timer.starts.first.toString());
      output.writeSplit();
      timer.start('config');
      output.writeLn('// CONFIG');
      await _loadLibraryFiles();
      await _loadConfig();
      output.writeSplit();
      output.writeLn('// MERGED CONFIG');
      this.config.config.forEach((key, value) {
        output.writeLn("// ${key}: ${value}");
      });
      output.writeSplit();
      timer.end();

      for (var importElement in library.element.libraryImports) {
        if (!importElement.importedLibrary!.isDartCore) {
          importElement.namespace.definedNames.forEach((key, value) {
            //output.writeLn('//' + key + ' ' + value.displayName + ' ' + value.getExtendedDisplayName('test') + " ${value.hashCode}");
          });
          //importedLibrariesMap[importElement!.importedLibrary!] = importElement.prefix == null ? null : importElement.prefix!.name;
          //output.writeLn('// import ' + (importElement.importedLibrary?.identifier ?? 'null') + (importElement.prefix == null ? '' : ' as ' + importElement.prefix!.name));
          importElement.namespace.definedNames.forEach(typeMap.registerClassElement);
        }
      }
      library.allElements.forEach((element) => (element.name != null) ? typeMap.registerClassElement(element.name!, element) : null);

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

      timer.start('interceptors');
      for (int i=0; i < typeMap.allTypes.keys.length; i++) {
        TypeInfo type = typeMap.allTypes[typeMap.allTypes.keys.elementAt(i)]!;
        if (type.hasInterceptor() && !type.isNullable) {
          output.writeSplit();
          if (debug) {
            output.writeLn("// interceptor for [${type.uniqueName}]");
            await type.writeDebugInfo(output);
          }
          await type.generateInterceptor(output, this);
        } else {
          if (debug) {
            output.writeLn("// no interceptor for [${type.uniqueName}]");
            await type.writeDebugInfo(output);
          }
        }
      }
      timer.end();
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
      timer.start('om');
      output.writeSplit();
      generateSubtypesOf();
      output.writeSplit();
      generateObjectManager();
      timer.end();

    } catch(e, stacktrace) {
      output.writeLn('/* unhandled code generator exception: \n' + e.toString() + '\n' + stacktrace.toString() + '*/');
    }
    timer.start('index');
    await _buildWidgetsIndex();
    timer.end();
    timer.end();
    timer.print(output, debug);
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
              new GenerationTimer(),
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
