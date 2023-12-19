import 'dart:io';

import 'package:lcov_excluder/lcov_excluder.dart';
import 'package:lcov_excluder/src/writer.dart';
import 'package:test/test.dart';

void main() {
  writer.write = (_) {};

  group('lcov_excluder', () {
    test('should be manipulated the lcov.info file.', () {
      final src = File('test/coverage/src.info');
      final test = src.copySync('test/coverage/test.info');

      final config = Config.filePath(config: 'test/config/test-config.yaml');

      for (final target in [config, ...config.targets]) {
        Manipulator(config: target).manipulated(verbose: true);
      }

      final dst = File('test/coverage/dst.info');
      expect(test.readAsBytesSync(), dst.readAsBytesSync());
      test.delete();
    });
  });
}
