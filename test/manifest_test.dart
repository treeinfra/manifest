import 'package:manifest/manifest.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  const raw = '''
    name: example
    description: This is an example.
    version: 1.2.3 # Here is comments.
    publish_to: "none" # Use double quote here.
    environment: {sdk: '>=3.4.3 <4.0.0'}
  ''';

  group('parse yaml', () {
    final yaml = loadYaml(raw);
    test('load yaml type', () => expect(yaml is Map, true));

    final map = yaml as Map;

    group('parse', () {
      test('not exist', () => expect(map.parse<int>(['not-exist']), (null, 0)));
      test('wrong type', () {
        expect(map.parse<int>(['name']), ('example', 0));
      });

      test('normal single layer', () {
        expect(map.parse<String>(['name']), ('example', 1));
        expect(map.parse<String>(['version']), ('1.2.3', 1));
        expect(map.parse<String>(['publish_to']), ('none', 1));
      });

      test('nesting', () {
        expect(
          map.parse<String>(['environment', 'sdk']),
          ('>=3.4.3 <4.0.0', 2),
        );
      });
    });

    group('check', () {
      test('success', () {
        expect(map.check<String>(['name']), 'example');
        expect(map.check<String>(['version']), '1.2.3');
        expect(map.check<String>(['publish_to']), 'none');
        expect(map.check<String>(['environment', 'sdk']), '>=3.4.3 <4.0.0');
      });

      test('error message: cannot find', () {
        try {
          map.check<String>(['not-exist']);
        } on InvalidYamlStructure catch (e) {
          expect(e.toString(), 'InvalidYamlStructure: not-exist: null');
        }
      });

      test('error message: error type', () {
        try {
          map.check<int>(['name']);
        } on InvalidYamlStructure catch (e) {
          expect(e.toString(), 'InvalidYamlStructure: name: example');
        }
      });
    });

    test('peek', () {
      expect(map.peek<int>(['name']), null);
      expect(map.peek<String>(['not-exist']), null);
      expect(map.peek<String>(['name']), 'example');
    });
  });

  test('parse manifest', () {
    final manifest = Manifest.fromYaml(raw);
    expect(manifest.name, 'example');
    expect(manifest.description, 'This is an example.');
    expect(manifest.version, '1.2.3');
    expect(manifest.homepage, null);
  });
}
