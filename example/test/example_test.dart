import 'package:manifest_example/example.dart';
import 'package:test/test.dart';

void main() {
  // Such test must run after generating the manifest file.
  test('manifest gen.sh.sh', () {
    expect(manifest.name, 'manifest_example');
    expect(manifest.version, '1.2.3-pre-4.5');
    expect(
      manifest.description,
      'An example and the tester for the manifest package.',
    );
    expect(manifest.homepage, null);
  });
}
