# alisthelper

<p align="center">
  <img src="https://github.com/Xmarmalade/alisthelper/assets/16839488/2067509c-756e-48cd-8f20-5ea961f46ef7" width="100" height="100">
</p>

English | [简体中文](./README_zh-Hans.md) |  [CODE_OF_CONDUCT](./CODE_OF_CONDUCT.md)

![](https://img.shields.io/badge/language-dart-blue.svg?style=for-the-badge&color=00ACC1)
![Downloads](https://img.shields.io/badge/flutter-00B0FF?style=for-the-badge&logo=flutter)
[![](https://img.shields.io/github/downloads/Xmarmalade/alisthelper/total?style=for-the-badge&color=FF2196)](https://github.com/Xmarmalade/alisthelper/releases)
[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/Xmarmalade/alisthelper?include_prereleases&style=for-the-badge)](https://github.com/Xmarmalade/alisthelper/releases/latest)
[![](https://img.shields.io/github/license/Xmarmalade/alisthelper?style=for-the-badge)](./LICENSE)
![](https://img.shields.io/github/stars/Xmarmalade/alisthelper?style=for-the-badge)
![](https://img.shields.io/github/issues/Xmarmalade/alisthelper?style=for-the-badge&color=9C27B0)

Alist Helper is an application developed using Flutter, designed to simplify the use of the desktop version of alist. It can manage alist, allowing you to easily start and stop the alist program.

### Screenshots
| ![image](https://user-images.githubusercontent.com/16839488/235718140-0572c7ae-b3d5-46a8-b092-65a3dff7d92f.png) | ![image](https://user-images.githubusercontent.com/16839488/235718717-e7fae230-284e-4ad8-9e8e-5f9a7d6a22dd.png) |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| ![image](https://user-images.githubusercontent.com/16839488/236637250-ec2b437f-0dcb-4c4e-b284-4db44dd06e19.png) | ![image](https://user-images.githubusercontent.com/16839488/236637200-5b9f2383-b29e-434d-a8e6-41187e00eb02.png) |

Alist Helper includes several useful features:

- Automatic launching of alist
- Minimizing to the system tray
- Automatic startup on boot, with the option for silent startup
- Quick access to alist version and administrator information
- Adjustable alist startup parameters. You can customize the startup parameters to meet your specific needs and preferences.

Free. No tracking. No ads.

Currently, this app is available on Windows and macOS. Adaptation plans for more platforms are in progress.

Please note that this program does not include the binary files for alist. You will need to download them manually.

|                     | alist                        | alisthelper | alist desktop   |
| ------------------- | ---------------------------- | ----------- | --------------- |
| Price               | 🆓 Free                       | 🆓 Free      | 💰8$/50￥         |
| Startup at boot     | 🛠️ Needs manual configuration | ✅ Supported | ✅ Supported     |
| Silent startup      | ❌ Not supported              | ✅ Supported | ✅ Supported     |
| Accompanied startup | ❌ Not supported              | ✅ Supported | ❌ Not supported |
| GUI                 | ❌ Not supported              | ✅ Supported | ✅ Supported     |
| System tray         | ❌ Not supported              | ✅ Supported | ✅ Supported     |
| Startup parameters  | 🛠️ Needs manual configuration | ✅ Supported | ❌ Not supported |
| Http proxy          | 🛠️ Needs manual configuration | ✅ Supported | ❌ Not supported |

# Contributing to AlistHelper

AlistHelper is an open-source project, and we welcome contributions from anyone who is interested in helping improve the app. Whether you're a developer, a translator, or a documentation writer, there are many ways to get involved.

## Getting Started

If you're interested in contributing code to AlistHelper, you'll need to follow these steps:

## Run

Fork the repository and install [Flutter](https://flutter.dev).

After you have installed [Flutter](https://flutter.dev), then you can start this app by typing the following commands:

```shell
flutter pub get
dart run slang
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
   2. Update translations via `dart run slang`
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