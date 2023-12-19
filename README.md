# lcov_excluder

It is possible to exclude coverage by editing the contents of the lcov.info file.

## Getting started

Add `lcov_excluder` to your `pubspec.yaml` file. Or, activate `lcov_excluder` to your global pub.

```bash
$ dart pub global activate lcov_excluder
```

## Requirements

- Dart 3.0.0+

## Usage

### Create configuration YAML file

Create `lcov-config.yaml` on your project root directory. Or, you can create a `.yaml` file with any name and specify the file during the execution of `lcov_excluder`. If no specification is provided, `lcov-config.yaml` will be automatically loaded.

```bash
$ dart run lcov_excluder exclude --config-file your-config.yaml
```

### Basic configuration file example

Define `coverage` at the root. `coverage` can have `target` and `targets` defined.

```yaml
coverage:
  target:
    sources:
      - "cov/lcov.info"
    exclude:
      - "lib/db/*"
      - "lib/test/*"
      - "lib/**/*.*.dart"
  targets:
    - service:
      sourceRoot: packages/service
      exclude:
        - "lib/**/*.*.dart"
    - db:
      sources:
        - "packages/db/coverage/lcov.info"
        - "packages/db/cov/lcov.info"
```

### Sources

You can define `sourceRoot` and `sources` for each target. `sourceRoot` specifies the source root, and `sources` specifies the paths to the `lcov.info` files. `sourceRoot` can also be omitted. The following two definitions have the same meaning:

```yaml
coverage:
  target:
    sourceRoot: packages/root
    sources:
      - "lib/cov/lcov.info"
      - "bin/cov/lcov.info"
    exclude:
      - "lib/**/*.*.dart"
```

and

```yaml
coverage:
  target:
    sources:
      - "packages/root/lib/cov/lcov.info"
      - "packages/root/bin/cov/lcov.info"
    exclude:
      - "lib/**/*.*.dart"
```

It is also possible to omit `sources`. In that case, the `lcov.info` specified during the execution of `lcov_excluder` will be loaded.

```bash
$ dart run lcov_excluder exclude --info-file your-lcov.info
```

If `sources` is omitted and no `info-file` is specified, `coverage/lcov.info` will be automatically loaded.

### Exclude

The `exclude` keyword specifies the files to be excluded. You can use globs to specify the `exclude` pattern. Files that match the globs specified in `exclude` will be excluded.

```yaml
coverage:
  target:
    exclude:
      - "lib/**/*.*.dart"
```

When configured as shown above, all Dart files with double extensions under the `lib` directory will be excluded.

### Target

The `target` keyword can also be omitted. The following two definitions have the same meaning.

```yaml
coverage:
  target:
    sources:
      - "cov/lcov.info"
    exclude:
      - "lib/**/*.*.dart"
```

and

```yaml
coverage:
  sources:
    - "cov/lcov.info"
  exclude:
    - "lib/**/*.*.dart"
```

`targets` allows you to define multiple targets. Each item in `targets` should have the same definition as `target`. Additionally, you can specify any string as the key for each item in `targets`.

```yaml
coverage:
  targets:
    - example:
      sources:
        - "cov/lcov.info"
      exclude:
        - "lib/**/*.*.dart"
```

## License
Smooth Counter is released under the [BSD-3-Clause License](./LICENSE).
