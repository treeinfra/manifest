# Manifest

A command line tool to generate Dart package manifest from pubspec.yaml.

## How to use

Run the following code in your project root directory,
and it will generate `lib/manifest.dart` according to your `pubspec.yaml`.

```sh
dart run manifest -o lib/manifest.dart
```

The output file will only contain a `const` with the manifest data,
and you can call it like this:

```dart
import 'package:manifest/manifest.dart';
import 'manifest.dart';

void main() {
  print('${manifest.name}: ${manifest.version}');
}
```
