## Getting Started

If you're interested in contributing code to AlistHelper, you'll need to follow these steps:

## Run

Fork the repository and install [Flutter](https://flutter.dev).

After you have installed [Flutter](https://flutter.dev), then you can start this app by typing the following commands:

```shell
flutter pub get
dart run build_runner build
flutter run
```

## Translation

You can help translating this app to other languages!

1. Fork this repository
2. Choose one
   - Add missing translations in existing languages: Only update `_missing_translations_<locale>.json` in [lib/i18n](https://github.com/Xmarmalade/alisthelper/tree/master/lib/i18n)
   - Fix existing translations: Update `strings_<locale>.i18n.json` in [lib/i18n](https://github.com/Xmarmalade/alisthelper/tree/master/lib/i18n)
   - Add new languages: Create a new file, see also: [locale codes](https://saimana.com/list-of-country-locale-code/).
3. Optional: Re-run this app
   1. Make sure you have [run](#run) this app once.
   2. Update translations via `dart run build_runner build`
   3. Run app via `flutter run`
4. Open a pull request

#### _Take note:_ Fields decorated with `@` are not meant to be translated, they are not used in the app in any way, being merely informative text about the file or to give context to the translator.

## Contributing Guidelines

Before you submit a pull request to AlistHelper, please ensure that you have followed these guidelines:

- Code should be well-documented and formatted according to the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- All changes should be covered by tests.
- Commits should be well-written and descriptive, with a clear summary of the changes made and any relevant context.
- Pull requests should target the `master` branch and include a clear summary of the changes made.

## Bug Reports and Feature Requests

If you encounter a bug in AlistHelper or have a feature request, please submit an issue to the [issue tracker](https://github.com/Xmarmalade/alisthelper/issues). Please be sure to provide a clear description of the problem or feature request, along with any relevant context or steps to reproduce the issue.
