import 'dart:io' show File;

import 'package:glob/glob.dart';
import 'package:yaml/yaml.dart';

/// A class that represents the configuration of the lcov_excluder.
class Config {
  const Config._(
    this.name,
    this.patterns,
    this.sourceRoot,
    this.sources,
    this.targets,
  );

  /// Creates a new instance from the given [config] file path.
  /// If [info] is specified, it will be used as the source of the lcov.info
  /// file. Otherwise, the value of the [sources] key in the config file will
  /// be used. If the [sources] key is not specified, the default value
  /// `['coverage/lcov.info']` will be used.
  factory Config.filePath({required String config, String? info}) {
    final configFile = File(config);
    if (!configFile.existsSync()) {
      throw ArgumentError.value(config, 'config', 'does not exist');
    }

    final yaml = loadYaml(configFile.readAsStringSync()) as Map;
    final root = yaml[_rootKey] as Map?;
    if (root == null) {
      throw ArgumentError.value(config, 'config', 'does not contain $_rootKey');
    }

    final target = root[_targetKey] as Map? ?? root;
    final targets = root[_targetsKey] as List? ?? [];
    return Config._target('target', target, info, targets);
  }

  factory Config._target(
    String name,
    Map<dynamic, dynamic> target,
    String? info, [
    List<dynamic> targets = const [],
  ]) {
    const path = 'coverage/lcov.info';

    final exclude = target[_excludeKey] as List? ?? [];
    final sources =
        (info != null ? [info] : target[_sourcesKey] as List?) ?? [path];
    final sourceRoot = target[_sourceRootKey] as String? ?? '';

    return Config._(
      name,
      exclude.map((e) => Glob(e as String)).toList(),
      sourceRoot,
      sources.map((source) => source as String).toList(),
      targets.map((target) {
        final map = target as Map;
        final keys = map.keys.where((key) => !_reserved.contains(key)).toList();
        if (keys.isEmpty) {
          throw ArgumentError.value(
            target,
            'target',
            'does not contain the unique key',
          );
        }

        return Config._target(
          keys.first as String,
          (map[keys.first] ?? map) as Map,
          info,
        );
      }).toList(),
    );
  }

  static const _rootKey = 'coverage';
  static const _targetKey = 'target';
  static const _excludeKey = 'exclude';
  static const _sourceRootKey = 'sourceRoot';
  static const _sourcesKey = 'sources';
  static const _targetsKey = 'targets';
  static Set<String> get _reserved => {
        _excludeKey,
        _sourceRootKey,
        _sourcesKey,
      };

  /// The name of the target.
  final String name;

  /// The patterns to exclude.
  final List<Glob> patterns;

  /// The source files to manipulate.
  final List<String> sources;

  /// The root path of the source files.
  final String sourceRoot;

  /// The targets to manipulate.
  final List<Config> targets;

  /// The resolved source files.
  List<String> get resolved => sources.map((source) {
        final fullPath = '$sourceRoot/$source';
        return fullPath.substring(fullPath.startsWith('/') ? 1 : 0);
      }).toList();

  @override
  String toString() {
    return '''
Config(
  name: $name,
  patterns: $patterns,
  sourceRoot: $sourceRoot,
  sources: $sources,
  targets: $targets
)''';
  }
}
