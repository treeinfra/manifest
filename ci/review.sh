dart pub get || exit 1
dart format --output=none --set-exit-if-changed . || exit 1
dart analyze --fatal-infos || exit 1
sh ci/gen.sh || exit 1
dart test test/*.dart || exit 1
dart pub publish --dry-run || exit 1
