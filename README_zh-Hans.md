# alisthelper

<p align="center">
  <img src="https://github.com/Xmarmalade/alisthelper/assets/16839488/2067509c-756e-48cd-8f20-5ea961f46ef7" width="100" height="100">
</p>

[English](./README.md) | 简体中文 |  [CODE_OF_CONDUCT](./CODE_OF_CONDUCT.md)

![](https://img.shields.io/badge/language-dart-blue.svg?style=for-the-badge&color=00ACC1)
![Downloads](https://img.shields.io/badge/flutter-00B0FF?style=for-the-badge&logo=flutter)
[![](https://img.shields.io/github/downloads/Xmarmalade/alisthelper/total?style=for-the-badge&color=FF2196)](https://github.com/Xmarmalade/alisthelper/releases)
[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/Xmarmalade/alisthelper?include_prereleases&style=for-the-badge)](https://github.com/Xmarmalade/alisthelper/releases/latest)
[![](https://img.shields.io/github/license/Xmarmalade/alisthelper?style=for-the-badge)](./LICENSE)
![](https://img.shields.io/github/stars/Xmarmalade/alisthelper?style=for-the-badge)
![](https://img.shields.io/github/issues/Xmarmalade/alisthelper?style=for-the-badge&color=9C27B0)

Alist Helper是一款使用Flutter开发的应用程序，旨在简化桌面版alist的使用。它可以管理alist，让您更轻松地开启、关闭alist程序。

### 截图
| ![image](https://user-images.githubusercontent.com/16839488/235718140-0572c7ae-b3d5-46a8-b092-65a3dff7d92f.png) | ![image](https://user-images.githubusercontent.com/16839488/235718717-e7fae230-284e-4ad8-9e8e-5f9a7d6a22dd.png) |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| ![image](https://user-images.githubusercontent.com/16839488/236637250-ec2b437f-0dcb-4c4e-b284-4db44dd06e19.png) | ![image](https://user-images.githubusercontent.com/16839488/236637200-5b9f2383-b29e-434d-a8e6-41187e00eb02.png) |

Alist Helper包括多个实用功能

 - 自动启动alist
 - 最小化至系统托盘
 - 开机自启和开机静默启动
 - 能够快速查看alist的版本和管理员信息
 - 可调整的alist启动参数。你可以可以根据自己的特定需求和偏好来自定义启动参数。

免费。无跟踪。无广告。

目前，此应用可在 Windows 和 macOS 上使用。更多平台的适配计划正在进行中。

特别注意，本程序不包含alist的二进制文件，您需要手动下载。

|          | alist          | alisthelper | alist desktop |
| -------- | -------------- | ----------- | ------------- |
| 价格     | 🆓 Free         | 🆓 Free      | 💰8$/50￥       |
| 开机自启 | 🛠️ 需要手动配置 | ✅ 支持      | ✅ 支持        |
| 静默启动 | ❌ 不支持       | ✅ 支持      | ✅ 支持        |
| 伴随启动 | ❌ 不支持       | ✅ 支持      | ❌ 不支持      |
| GUI      | ❌ 不支持       | ✅ 支持      | ✅ 支持        |
| 系统托盘 | ❌ 不支持       | ✅ 支持      | ✅ 支持        |
| 参数调整 | 🛠️ 需要手动配置 | ✅ 支持      | ❌ 不支持      |
| Http代理 | 🛠️ 需要手动配置 | ✅ 支持      | ❌ 不支持      |

# 贡献

AlistHelper 是一个开源项目，我们欢迎任何有兴趣帮助改进该应用程序的人进行贡献。无论你是开发人员、翻译者还是文档编写者，都有很多参与方式。

## 入门指南

如果你有意向为 AlistHelper 贡献代码，你需要遵循以下步骤：

## 运行

Fork存储库并安装[Flutter](https://flutter.dev)。

在你安装了[Flutter](https://flutter.dev)之后，你可以通过键入以下命令来启动该应用程序：

```shell
flutter pub get
dart run slang
flutter run
```

## 翻译

你可以帮助将该应用程序翻译成其他语言！

1. Fork该存储库
2. 选择一项
   - 添加缺失的现有语言翻译：只需更新[lib/i18n](https://github.com/Xmarmalade/alisthelper/tree/master/lib/i18n)中的`_missing_translations_<locale>.json`
   - 修复现有翻译：更新[lib/i18n](https://github.com/Xmarmalade/alisthelper/tree/master/lib/i18n)中的`strings_<locale>.i18n.json`
   - 添加新语言：创建一个新文件，关于`locale`参见：[locale codes](https://saimana.com/list-of-country-locale-code/)。
3. 可选项：重新运行该应用程序
   1. 确保你已经[运行](#run)过该应用程序。
   2. 通过`dart run slang`更新翻译
   3. 通过`flutter run`运行应用程序
4. 提交拉取请求

#### _请注意:_ 使用`@`标记装饰的字段不应被翻译，它们在应用程序中不会被使用，仅仅是有关该文件的信息文本或为翻译者提供上下文。

## 贡献指南

在向AlistHelper提交拉取请求之前，请确保你遵循了以下准则：

- 代码应该有良好的文档，并根据[Dart风格指南](https://dart.dev/guides/language/effective-dart/style)进行格式化。
- 所有更改都应该有测试覆盖。
- 提交的注释应该写得清晰明了，概述更改内容和任何相关上下文。
- 拉取请求应该针对`master`分支，并包含对更改的清晰概述。

## 缺陷报告和功能请求

如果你在AlistHelper中遇到了一个缺陷或者有一个功能请求，请在[问题跟踪器](https://github.com/Xmarmalade/alisthelper/issues)中提交一个问题。请确保提供清晰的问题或功能请求描述，以及任何相关的上下文或复现该问题的步骤。