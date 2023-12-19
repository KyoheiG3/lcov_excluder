import 'dart:io';

/// A writer for stdout.
class Writer {
  void Function(String text)? _write;

  /// Sets the [write] function.
  set write(void Function(String text) write) {
    _write = write;
  }

  /// Returns the [write] function.
  void Function(String text) get write {
    return _write ?? stdout.write;
  }
}

/// This is used in the production code.
final writer = Writer();
