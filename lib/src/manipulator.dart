import 'dart:io' show File;

import 'package:lcov_excluder/src/config.dart';
import 'package:lcov_excluder/src/excluder.dart';
import 'package:lcov_excluder/src/writer.dart';

/// Manipulator for lcov.info file.
class Manipulator {
  const Manipulator({
    required this.config,
  });

  final Config config;

  /// Manipulates the lcov.info file based on the given [config].
  List<String> manipulated({required bool verbose}) {
    return config.resolved.where((targetPath) {
      final targetFile = File(targetPath);
      if (targetFile.existsSync()) {
        if (verbose) {
          writer.write('Start: Manipulating $targetPath..');
        }

        final result = Excluder(patterns: config.patterns).excluded(
          targetFile.readAsLinesSync(),
          verbose: verbose,
        );

        targetFile.writeAsStringSync(result);
        return true;
      } else {
        writer.write('Warning: $targetPath does not exist (${config.name}).');
        return false;
      }
    }).toList();
  }
}
