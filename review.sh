echo_pos() { echo && echo "\033[32m"$1"\033[0m" && echo; }

echo_pos "[root repo]"
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test

cd example && echo_pos "[example child repo]"
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
cd .. && echo_pos "[back to root repo]"

dart pub publish --dry-run
