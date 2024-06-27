import 'package:manifest_example/example.dart';
import 'package:test/test.dart';

void main() {
  test('manifest gen', () {
    expect(manifest.name, 'manifest_example');
    expect(manifest.version, '1.2.3-pre-4.5');
    expect(
      manifest.description,
      'An example and the tester for the manifest package.',
    );
    expect(manifest.homepage, null);
  });
}
