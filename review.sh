echo_pos() { echo && echo "\033[32m"$1"\033[0m" && echo; }

echo_pos "[root repo]"
dart pub get || exit 1
dart format --output=none --set-exit-if-changed . || exit 1
dart analyze --fatal-infos || exit 1
dart test test/*.dart || exit 1

cd example && echo_pos "[example child repo]" || exit 1
output="lib/manifest.dart"
dart run manifest --output $output || exit 1
dart format --output=none --set-exit-if-changed $output || exit 1
dart test || exit 1

cd .. && echo_pos "[back to root repo]"
dart pub publish --dry-run || exit 1
