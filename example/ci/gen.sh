output="lib/manifest.dart"
dart run manifest --output $output || exit 1
dart format --output=none --set-exit-if-changed $output || exit 1
