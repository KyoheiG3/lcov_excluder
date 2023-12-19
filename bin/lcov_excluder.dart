import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:lcov_excluder/lcov_excluder.dart';

void main(List<String> arguments) {
  CommandRunner<dynamic>(
    'lcov_excluder',
    'Removes files from the lcov.info file whose paths match any pattern.',
  )
    ..addCommand(LcovExcludeCommand())
    ..run(arguments);
}

/// The command to manipulate the lcov.info file.
class LcovExcludeCommand extends Command<dynamic> {
  LcovExcludeCommand() {
    argParser
      ..addOption(
        'info-file',
        abbr: 'i',
        help:
            'The target .info file path to manipulate. Defaults to `coverage/lcov.info.`',
        valueHelp: 'FILE',
      )
      ..addOption(
        'config-file',
        abbr: 'c',
        help: 'Configuration .yaml file path. Defaults to `lcov-config.yaml.`',
        valueHelp: 'FILE',
      )
      ..addFlag(
        'verbose',
        negatable: false,
        help: 'Show verbose log.',
      );
  }

  @override
  String get name => 'exclude';

  @override
  String get description =>
      'Removes files from the .info file whose paths match any pattern.';

  @override
  void run() {
    const configPath = 'lcov-config.yaml';

    final config = Config.filePath(
      config: argResults?['config-file'] as String? ?? configPath,
      info: argResults?['info-file'] as String?,
    );

    final allTargets = [config, ...config.targets];
    if (allTargets.every((target) => target.patterns.isEmpty)) {
      stdout.writeln('Warning: No patterns to exclude.\n');
      exit(0);
    }

    final verbose = argResults?['verbose'] == true;
    for (final target in allTargets) {
      if (target.patterns.isNotEmpty) {
        final manipulated =
            Manipulator(config: target).manipulated(verbose: verbose);
        if (manipulated.isNotEmpty) {
          stdout
              .writeln('Success: Manipulated files: ${manipulated.join('\n')}');
        }
      }
    }
  }
}
