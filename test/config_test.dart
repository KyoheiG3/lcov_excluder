import 'package:lcov_excluder/src/config.dart';
import 'package:test/test.dart';

void main() {
  group('Config', () {
    group('when the basically valid YAML file is given.', () {
      test('should create a Config instance.', () {
        final config = Config.filePath(config: 'test/config/basic-config.yaml');

        // test target
        expect(config.name, 'target');
        expect(config.patterns.length, 3);
        expect(config.patterns[0].pattern, 'lib/db/*');
        expect(config.patterns[1].pattern, 'lib/test/*');
        expect(config.patterns[2].pattern, 'lib/**/*.*.dart');
        expect(config.sourceRoot, 'packages/root');
        expect(config.sources.length, 1);
        expect(config.sources[0], 'cov/lcov.info');
        expect(config.resolved[0], 'packages/root/cov/lcov.info');
        expect(config.targets.length, 2);

        // test target1
        final test1 = config.targets[0];
        expect(test1.name, 'test1');
        expect(test1.patterns.length, 1);
        expect(test1.patterns[0].pattern, 'lib/**/*.*.dart');
        expect(test1.sourceRoot, 'packages/test1');
        expect(test1.sources.length, 1);
        expect(test1.sources[0], 'coverage/lcov.info');
        expect(test1.resolved[0], 'packages/test1/coverage/lcov.info');
        expect(test1.targets.length, 0);

        // test target1
        final test2 = config.targets[1];
        expect(test2.name, 'test2');
        expect(test2.patterns.length, 0);
        expect(test2.sourceRoot, '');
        expect(test2.sources.length, 2);
        expect(test2.sources[0], 'packages/test2/coverage/lcov.info');
        expect(test2.sources[1], 'packages/test2/cov/lcov.info');
        expect(test2.resolved[0], 'packages/test2/coverage/lcov.info');
        expect(test2.resolved[1], 'packages/test2/cov/lcov.info');
        expect(test2.targets.length, 0);
      });
    });

    group('when the short valid YAML file is given.', () {
      test('should create a Config instance.', () {
        final config = Config.filePath(config: 'test/config/short-config.yaml');

        // test target
        expect(config.name, 'target');
        expect(config.patterns.length, 1);
        expect(config.patterns[0].pattern, 'lib/**/*.*.dart');
        expect(config.sourceRoot, '');
        expect(config.sources.length, 1);
        expect(config.sources[0], 'coverage/lcov.info');
        expect(config.resolved[0], 'coverage/lcov.info');
        expect(config.targets.length, 0);
      });
    });

    group('when the YAML file does not contain the target key.', () {
      test('should create a Config instance.', () {
        final config =
            Config.filePath(config: 'test/config/not-contain-target.yaml');

        // test target
        expect(config.name, 'target');
        expect(config.patterns.length, 0);
        expect(config.sourceRoot, '');
        expect(config.sources.length, 1);
        expect(config.sources[0], 'coverage/lcov.info');
        expect(config.resolved[0], 'coverage/lcov.info');
        expect(config.targets.length, 2);

        // test target1
        final test1 = config.targets[0];
        expect(test1.name, 'test1');
        expect(test1.patterns.length, 1);
        expect(test1.patterns[0].pattern, 'lib/**/*.*.dart');
        expect(test1.sourceRoot, 'packages/test1');
        expect(test1.sources.length, 1);
        expect(test1.sources[0], 'coverage/lcov.info');
        expect(test1.resolved[0], 'packages/test1/coverage/lcov.info');
        expect(test1.targets.length, 0);

        // test target1
        final test2 = config.targets[1];
        expect(test2.name, 'test2');
        expect(test2.patterns.length, 0);
        expect(test2.sourceRoot, '');
        expect(test2.sources.length, 2);
        expect(test2.sources[0], 'packages/test2/coverage/lcov.info');
        expect(test2.sources[1], 'packages/test2/cov/lcov.info');
        expect(test2.resolved[0], 'packages/test2/coverage/lcov.info');
        expect(test2.resolved[1], 'packages/test2/cov/lcov.info');
        expect(test2.targets.length, 0);
      });
    });

    group('when the short indent YAML file is given.', () {
      test('should create a Config instance.', () {
        final config = Config.filePath(config: 'test/config/short-indent.yaml');

        // test target
        expect(config.name, 'target');
        expect(config.patterns.length, 0);
        expect(config.sourceRoot, '');
        expect(config.sources.length, 1);
        expect(config.sources[0], 'coverage/lcov.info');
        expect(config.resolved[0], 'coverage/lcov.info');
        expect(config.targets.length, 2);

        // test target1
        final test1 = config.targets[0];
        expect(test1.name, 'test1');
        expect(test1.patterns.length, 1);
        expect(test1.patterns[0].pattern, 'lib/**/*.*.dart');
        expect(test1.sourceRoot, 'packages/test1');
        expect(test1.sources.length, 1);
        expect(test1.sources[0], 'coverage/lcov.info');
        expect(test1.resolved[0], 'packages/test1/coverage/lcov.info');
        expect(test1.targets.length, 0);

        // test target1
        final test2 = config.targets[1];
        expect(test2.name, 'test2');
        expect(test2.patterns.length, 0);
        expect(test2.sourceRoot, '');
        expect(test2.sources.length, 2);
        expect(test2.sources[0], 'packages/test2/coverage/lcov.info');
        expect(test2.sources[1], 'packages/test2/cov/lcov.info');
        expect(test2.resolved[0], 'packages/test2/coverage/lcov.info');
        expect(test2.resolved[1], 'packages/test2/cov/lcov.info');
        expect(test2.targets.length, 0);
      });
    });

    group('when the YAML file does not exist.', () {
      test('should throw an error', () {
        expect(
          () => Config.filePath(config: 'nonexistent.yaml'),
          throwsArgumentError,
        );
      });
    });

    group('when the YAML file does not contain the root key.', () {
      test('should throw an error', () {
        expect(
          () => Config.filePath(config: 'test/config/not-contain-root.yaml'),
          throwsArgumentError,
        );
      });
    });

    group('when the YAML file does not contain the targets key.', () {
      test('should throw an error', () {
        expect(
          () => Config.filePath(
            config: 'test/config/not-contain-targets-key.yaml',
          ),
          throwsArgumentError,
        );
      });
    });

    test('should show string representation.', () {
      final config = Config.filePath(config: 'test/config/basic-config.yaml');
      expect(config.toString().startsWith('Config('), isTrue);
    });
  });
}
