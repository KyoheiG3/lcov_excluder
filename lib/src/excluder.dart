import 'package:glob/glob.dart';
import 'package:lcov_excluder/src/writer.dart';

/// A class that excludes the specified files.
class Excluder {
  const Excluder({
    required this.patterns,
  });

  static const sourceFilePrefix = 'SF:';
  static const endOfRecord = 'end_of_record';

  final List<Glob> patterns;

  /// Excludes the specified files from the given [lines].
  /// If [verbose] is `true`, the excluded files will be printed to the console.
  String excluded(List<String> lines, {required bool verbose}) {
    var excluding = false;
    bool exclude(String line) {
      late final path = line.substring(3);
      if (line.startsWith(sourceFilePrefix) &&
          patterns.any((pattern) => pattern.matches(path))) {
        excluding = true;
        if (verbose) {
          writer.write('excluding $path..');
        }
      } else if (excluding && line == endOfRecord) {
        return excluding = false;
      }
      return !excluding;
    }

    return lines.where(exclude).join('\n');
  }
}
