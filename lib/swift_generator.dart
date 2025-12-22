library;

import 'dart:convert';
import 'dart:isolate';

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
    starts.add(DateTime.now());
  }

  void end() {
    String p = path.join('.');
    path.removeLast();
    var start = starts.removeLast();
    int ms = (DateTime.now()).millisecondsSinceEpoch - start.millisecondsSinceEpoch;

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
        output.writeLn('// $t = ${times[t]}ms\n');
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

  CompiledOmGenerator(this.output, this.library, this.step, this.config, this.timer, this.debug)
    : typeMap = TypeMap(output, library.element.typeSystem, step, config);

  TemplateLocation? openTemplate(String name) {
    for (var module in modules.reversed) {
      String searchName = name;
      if (searchName.startsWith('${module.name}_')) {
        searchName = searchName.replaceFirst('${module.name}_', '');
      }
      if (searchName.endsWith('.scss') && module.name == 'application') {
        //prevent scss parts from being build
        searchName = '_$searchName';
      }
      String filePath = '${module.packagePath}/lib/widgets/$searchName';
      File file = File(filePath);
      if (file.existsSync()) {
        return TemplateLocation(module, '/lib/widgets/$searchName', file);
      }
    }
    return null;
  }

  @override
  String? load(String name) {
    TemplateLocation? file = openTemplate(name);
    if (file != null) {
      return file.file.readAsStringSync();
    }
    return null;
  }

  Map<String, String> getAnnotations(ClassElement element) {
    Map<String, String> ret = {};
    for (var annotation in element.metadata.annotations) {
      String source = annotation.toSource();
      source = source.replaceFirst('@', '');
      if (['Compose', 'ComposeSubtypes'].contains(source)) {
        //todo better list of build in annotations
        continue;
      }
      String key = source;
      if (source.contains('(')) {
        key = source.substring(0, source.indexOf('('));
      }
      if (!ret.containsKey(key)) {
        var value = 'true';
        //todo support multiple values?
        if (source != key) {
          value = source.replaceAll(key, '');
          value = value.replaceFirst('(', '');
          value = value.replaceFirst(')', '');
        }
        ret[key] = value;
      }
    }
    return ret;
  }

  void generateSubtypesOf() {
    for (var typeInfo in typeMap.subtypesOf.values) {
      output.writeLn('class \$SubtypesOf${typeInfo.flatName} extends SubtypesOf<${typeInfo.uniqueName}> {');
      output.writeLn('String getCode<X extends ${typeInfo.uniqueName}>(){');
      for (var type in typeMap.getNonAbstractSubtypes(typeInfo)) {
        output.writeLn('if (X == ${type.fullName}) return ${type.classCodeAsReference};');
      }
      output.writeLn('throw new Exception(\'no code for type\');');
      output.writeLn('}');

      output.writeLn('Map<String, SubtypeInfo> get allSubtypes => {');
      for (var type in typeMap.getNonAbstractSubtypes(typeInfo)) {
        output.writeLn('${type.classCodeAsReference}: SubtypeInfo(');
        //find base class name
        String baseClassCode = type.classCodeAsReference;
        for (var parentType in type.allTypeInfoPath()) {
          if (parentType.element!.metadata.annotations.where((element) => element.toSource() == '@ComposeSubtypes').isNotEmpty) {
            break;
          }
          baseClassCode = parentType.classCodeAsReference;
        }
        output.writeLn('$baseClassCode,{');
        //save annotations
        var myAnnotations = getAnnotations(type.element!);
        myAnnotations.forEach((key, value) {
          output.writeLn('"$key" : $value,');
        });
        output.writeLn('}, {');
        //save inherited annotations
        for (var parentElement in type.parentClassElementsPath()) {
          getAnnotations(parentElement).forEach((key, value) {
            if (!myAnnotations.containsKey(key)) {
              output.writeLn('"$key" : $value,');
            }
          });
        }
        output.writeLn('}),');
      }
      output.writeLn('};');
      output.writeLn('}');
    }
  }

  void generateCompiledMethodsParts() {
    for (var method in typeMap.compiledMethodsByType.keys) {
      for (var classElement in typeMap.compiledMethodsByType[method]!.keys) {
        output.writeLn(typeMap.compiledMethodsByType[method]![classElement]!.getPartDeclaration());
        output.writeLn('{');
        var stubs = typeMap.compiledMethodsByType[method]![classElement]!.stubs;
        for (var field in stubs.keys) {
          for (var method in stubs[field]!.keys) {
            output.writeMany(stubs[field]![method]!);
          }
        }
        output.writeLn('}');
        //[methodPartElement]![field.enclosingElement as ClassElement]!.add('//TEST');
      }
    }
  }

  void generateObjectManager() {
    output.writeLn('class \$ObjectManager {');
    for (var type in typeMap.allTypes.values) {
      if (type.canBeSingleton()) {
        String getterName = type.varName;
        output.writeLn('${type.creatorName}? _$getterName;');
        output.writeLn('${type.creatorName} get $getterName {');
        output.writeLn('if(_$getterName == null){');
        output.writeLn('_$getterName = ${type.generateCreator()};');
        output.writeLn('}');
        output.writeLn('return _$getterName as ${type.creatorName};');
        output.writeLn('}');
      }
    }

    for (var typeInfo in typeMap.subtypeInstanes.values) {
      output.writeLn('Map<String, ${typeInfo.uniqueName}>? _instancesOf${typeInfo.flatName};');
      output.writeLn('Map<String, ${typeInfo.uniqueName}> get instancesOf${typeInfo.flatName} {');
      output.writeLn('if (_instancesOf${typeInfo.flatName} != null) return _instancesOf${typeInfo.flatName}!;');
      output.writeLn('return _instancesOf${typeInfo.flatName} = {');

      typeMap.getNonAbstractSubtypes(typeInfo).forEach((subtypeInfo) {
        if (subtypeInfo.allRequiredFields().isEmpty) {
          output.writeLn('${subtypeInfo.classCodeAsReference}: ');
          output.writeLn(subtypeInfo.varName);
          //output.writeMany(subtypeInfo.generateCreator());
          output.writeLn(',');
        } else {
          output.writeLn('//${subtypeInfo.fullName} requires a param');
        }
      });
      output.writeLn('};');
      output.writeLn('}');
    }

    typeMap.subtypeFactories.forEach((key, subtypeFactoryInfo) {
      output.writeLn('${subtypeFactoryInfo.returnType.uniqueName} $key {');

      //output.writeLn('switch(className){');
      for (var type in typeMap.getNonAbstractSubtypes(subtypeFactoryInfo.returnType)) {
        //TODO compare parameters by types and names?
        //type.allRequiredFields().map((f) => f.name).join(',');
        if (type.allRequiredFields().length == subtypeFactoryInfo.arguments.length - 1) {
          output.writeLn('if (className == ${type.classCodeAsReference})');
          output.writeLn('return ${type.generateCreator()};');
          //output.writeLn('case ${type.classCodeAsReference}:');
          //output.writeLn('return ' + type.generateCreator() + ';');
        }
      }
      //output.writeLn('}');
      output.writeLn('throw new UnknownTypeException(className);');
      output.writeLn('}');
    });
    for (var typeInfo in typeMap.subtypesOf.values) {
      output.writeLn('SubtypesOf<${typeInfo.uniqueName}> subtypesOf${typeInfo.flatName} = new \$SubtypesOf${typeInfo.flatName}();');
    }

    output.writeLn('final List<String> s = const [');
    output.writeLn(typeMap.allSymbols.map((e) => '"$e"').join(','));
    output.writeLn('];');
    output.writeLn('}');
    output.writeLn('\$ObjectManager \$om = new \$ObjectManager();');
  }

  ///
  Future<void> _loadLibraryFiles() async {
    var packagesMap = <String, String>{};

    for (var import in library.element.firstFragment.libraryImports) {
      if (import.uri is! DirectiveUriWithRelativeUriString) {
        continue;
      }
      String stringUri = (import.uri as DirectiveUriWithRelativeUriString).relativeUriString;
      String resolvedPath = (await Isolate.resolvePackageUri(Uri.parse(stringUri))).toString();
      if (resolvedPath.startsWith('file://')) {
        resolvedPath = resolvedPath.replaceFirst('file://', '');
      }

      if (stringUri.contains(':')) {
        String schema = stringUri.substring(0, stringUri.indexOf(':'));
        if (schema != 'package') {
          continue;
        }
        String package = stringUri.substring(stringUri.indexOf(':') + 1, stringUri.indexOf('/'));
        modules.add(ImportedModule(package, resolvedPath, resolvedPath.substring(0, resolvedPath.indexOf('/lib/')), prefix: import.prefix?.element.name));
      } else {
        modules.add(
          ImportedModule(
            'application',
            '${dirname('${Directory.current.path}/${step.inputId.path}')}/$stringUri',
            '${Directory.current.path}/',
            prefix: import.prefix?.element.name,
          ),
        );
      }
    }
    modules.add(ImportedModule('application', '${Directory.current.path}/${step.inputId.path}', '${Directory.current.path}/'));
  }

  Future<void> _loadModuleConfig(ImportedModule module) async {
    String path = module.filePath.replaceFirst('.dart', '.di.yaml', module.filePath.length - 5);
    File configFile = File(path);
    if (configFile.existsSync()) {
      output.writeLn('// config file for ${module.prefix ?? 'root'}: ${relative(path)}');
      var yaml = loadYaml(await configFile.readAsString());
      if (yaml is YamlMap) {
        config.append(yaml.value, module.prefix);
      }
    } else {
      output.writeLn('// no config file for ${module.prefix ?? 'root'}: ${relative(path)}');
    }
  }

  ///
  Future<void> _loadConfig() async {
    for (var module in modules) {
      if (module.prefix != null) {
        await _loadModuleConfig(module);
      }
    }
    var configDir = Directory('config');
    if (configDir.existsSync()) {
      for (var file in configDir.listSync(recursive: true).whereType<File>()) {
        if (file.path.endsWith('.yaml')) {
          var name = file.path.split('/').last;
          name = name.substring(0, name.length - 5);
          String content = File(file.path).readAsStringSync();
          output.writeLn('// config file for $name ${file.path}');
          var yaml = loadYaml(content);
          if (yaml is YamlMap) {
            config.append(yaml.value, name == 'app' ? null : name);
          }
        }
      }
    }
    for (var module in modules) {
      if (module.prefix == null) {
        await _loadModuleConfig(module);
      }
    }
  }

  ///
  Future<void> _buildWidgetsIndex() async {
    String widgetsIndexPath = '${Directory.current.path}/${step.inputId.path}';
    String widgetsDirName = widgetsIndexPath.substring(0, widgetsIndexPath.lastIndexOf('/') + 1);
    String widgetsFileName = widgetsIndexPath.substring(widgetsIndexPath.lastIndexOf('/') + 1);
    widgetsIndexPath = '${widgetsDirName}_${widgetsFileName.replaceFirst('.dart', '_widgets.scss')}';
    File widgetsIndex = File(widgetsIndexPath);
    List<String> widgetsIndexContent = [];
    //unique set to generate Generic widgets once.
    Set<String> widgetsSet = <String>{};
    if (widgetsIndex.existsSync()) {
      output.writeLn('// generating widgets index file at ${widgetsIndex.path}');
      widgetsIndexContent.add('// auto generated widgets index file. do not modify');

      if (typeMap.allTypes.containsKey('module_core.Widget')) {
        for (var type in typeMap.getAllSubtypes(typeMap.allTypes['module_core.Widget']!)) {
          widgetsSet.add(type.fullName.replaceAll('.', '_'));
        }
      }
      for (var widgetName in widgetsSet) {
        var templateFile = openTemplate('$widgetName.scss');
        if (templateFile != null) {
          //output.writeLn('// file: ${templateFile.module.name} ${templateFile.path} ${templateFile.file.path}');
          widgetsIndexContent.add('.$widgetName {');
          if (templateFile.module.name == 'application') {
            String relPath = relative('${Directory.current.path}/${templateFile.path}', from: dirname(widgetsIndexPath));
            widgetsIndexContent.add('    @import "$relPath"');
          } else {
            widgetsIndexContent.add('    @import "package:${templateFile.module.name}${templateFile.path.replaceFirst('/lib', '')}"');
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

  ///
  Future<String> generate() async {
    timer.start('composer');
    try {
      output.writeSplit();
      output.writeLn('// generated by swift_composer at ${timer.starts.first}');
      output.writeLn('// ignore common warnings in generated code, you can also exclude this file in analysis_options.yaml');
      output.writeLn('// ignore_for_file: unnecessary_non_null_assertion');
      output.writeLn('// ignore_for_file: dead_null_aware_expression');
      output.writeSplit();
      timer.start('config');
      output.writeLn('// CONFIG');
      await _loadLibraryFiles();
      await _loadConfig();
      output.writeSplit();
      output.writeLn('// MERGED CONFIG');
      config.config.forEach((key, value) {
        output.writeLn("// $key: $value".replaceAll('\n', '\\n'));
      });
      output.writeSplit();
      timer.end();

      for (var importElement in library.element.firstFragment.libraryImports) {
        if (!importElement.importedLibrary!.isDartCore) {
          String prefix = importElement.prefix?.element.name ?? '';
          if (prefix.isNotEmpty) {
            prefix = '$prefix.';
          }
          importElement.namespace.definedNames2.forEach((key, value) {
            //output.writeLn('//' + key + ' ' + value.displayName + ' ' + value.getExtendedDisplayName() + " ${value.hashCode}");
          });
          //importedLibrariesMap[importElement!.importedLibrary!] = importElement.prefix == null ? null : importElement.prefix!.name;
          //output.writeLn('// import ' + (importElement.importedLibrary?.identifier ?? 'null') + (importElement.prefix == null ? '' : ' as ' + importElement.prefix!.name));

          importElement.namespace.definedNames2.forEach((name, element) {
            for (var metadataElement in element.metadata.annotations) {
              // TODO: if ComposeIfModule is checked here, Compose can also be checked here so non composed classes wont be registered?
              var annotation = metadataElement.toSource();
              if (annotation.startsWith('@ComposeIfModule(')) {
                var requireModule = annotation.substring(18, annotation.length - 2);
                if (modules.where((module) => module.name == requireModule).isEmpty) {
                  output.writeLn('//type: ${element.name ?? 'NULL'} requires module: $requireModule but it is not imported. skipping');
                  return;
                }
              }
            }
            typeMap.registerClassElement(prefix + name, element);
          });
        }
      }
      for (var element in library.allElements) {
        (element.name != null) ? typeMap.registerClassElement(element.name!, element) : null;
      }

      //DEBUG INFO

      Map<String, TypeInfo>.from(typeMap.allTypes).forEach((key, value) {
        value.preAnaliseAllUsedTypes();
      });

      if (debug) {
        output.writeLn('// ALL TYPES INFO');
        output.writeSplit();
        typeMap.allTypes.forEach((key, value) {
          output.writeLn('// $key => ${value.debugInfo}');
        });
      }

      timer.start('interceptors');
      for (int i = 0; i < typeMap.allTypes.keys.length; i++) {
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
      generateCompiledMethodsParts();
      output.writeSplit();
      generateObjectManager();
      timer.end();
    } catch (e, stacktrace) {
      output.writeLn('/* unhandled code generator exception: \n$e\n$stacktrace*/');
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
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    bool debug = options.config.containsKey('debug') ? options.config['debug'] : false;
    //parts are not available at build time trough .fragments so we check manually for part declaration:
    var fileName = library.element.firstFragment.source.fullName.split('/').last;
    var partName = fileName.replaceAll('.dart', '.c.dart');
    if (library.element.firstFragment.source.contents.data.contains("\npart '$partName';\n")) {
      return await (CompiledOmGenerator(OutputWriter(debug), library, buildStep, DiConfig(), GenerationTimer(), debug)).generate();
    }
    return null;
  }
}

PartBuilder swiftBuilder(BuilderOptions options) {
  return PartBuilder([SwiftGenerator(options)], '.c.dart');
}
