import 'package:yaml/yaml.dart';

/// Dart&Flutter pubspec.yaml manifest definitions and helper methods.
class Manifest {
  const Manifest({
    required this.name,
    required this.version,
    this.description,
    this.homepage,
  });

  final String name;
  final String version;
  final String? description;
  final String? homepage;

  /// Parse a [Manifest] object from raw yaml string.
  /// It will throw error if the format is invalid.
  static Manifest fromYaml(String raw) {
    final yaml = loadYaml(raw) as Map;
    return Manifest(
      name: yaml.check(['name']),
      version: yaml.check(['version']),
      description: yaml.peek(['description']),
      homepage: yaml.peek(['homepage']),
    );
  }
}

extension MapParser on Map<Object?, Object?> {
  /// Parse a value from a map with given path.
  ///
  /// 1. The returned value is the value when found or error.
  /// 2. The returned depth is the index of the path when return (start from 0).
  /// 3. If success, the depth should be the same as [path]'s length.
  (Object? value, int depth) parse<T>(List<Object?> path) {
    Object? current = this;
    for (int i = 0; i < path.length; i++) {
      final key = path[i];
      if (!(current is Map && current.containsKey(key))) return (null, i);
      current = current[key];
      if (i != path.length - 1) continue;
      return current is T ? (current, path.length) : (current, i);
    }
    return (null, -1); // Unreachable.
  }

  /// Encapsulation of [parse],
  /// throw error when cannot parse the value.
  T check<T>(List<Object?> path) {
    final (value, depth) = parse<T>(path);
    if (depth != path.length) throw InvalidYamlStructure(path, depth, value);
    return value as T;
  }

  /// Encapsulation of [parse],
  /// return null when cannot parse the value.
  T? peek<T>(List<Object?> path) {
    final (value, depth) = parse<T>(path);
    return depth == path.length ? value as T : null;
  }
}

class InvalidYamlStructure extends Error {
  /// See [toString] to understand what its format means.
  InvalidYamlStructure(this.path, this.depth, this.value);

  final List<Object?> path;
  final int depth;
  final Object? value;

  /// The error format will output its path and value.
  /// 1. The path is the current path when error happens.
  /// 2. When the value is correct, it means the specified type might be error.
  /// 3. Generics will not be available after compilation,
  ///    so it cannot output the specified type here.
  @override
  String toString() {
    final path = this.path.sublist(0, depth + 1).join('.');
    return 'InvalidYamlStructure: $path: $value';
  }
}
