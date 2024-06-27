import 'dart:io';

import 'package:args/args.dart';
import 'package:manifest/manifest.dart';
import 'package:path/path.dart';

void main(List<String> args) {
  // Process parameters.
  final params = (ArgParser()
        ..addOption('root', abbr: 'r', defaultsTo: '.')
        ..addOption('output', abbr: 'o'))
      .parse(args);
  if (params.option('output') == null) {
    throw Exception('output file (-o) must be specified');
  }

  // Generate code and write into output file.
  final input = join(params.option('root')!, 'pubspec.yaml');
  final output = join(params.option('root')!, params.option('output')!);
  final code = Manifest.fromYaml(File(input).readAsStringSync()).gen;
  File(output).writeAsStringSync(code);
}
