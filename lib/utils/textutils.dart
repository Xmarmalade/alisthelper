import 'dart:convert';

import 'package:fast_gbk/fast_gbk.dart';

class TextUtils {
  static String removeEscapeSequences(String input) {
    // Remove all escape sequences from the input string
    return input.replaceAll(RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]'), '');
  }

  static List<int> removeExtraBreaks(List<int> input) {
    // Remove the last character if it is a newline
    if (input.length > 2) {
      if (input[input.length - 1] == 10) {
        return input.sublist(0, input.length - 1);
      }
    }
    return input;
  }

  static String stdDecode(List<int> input,bool isGBK) {
    if (isGBK) {
      return removeEscapeSequences(gbk.decode(removeExtraBreaks(input)));
    }
    return removeEscapeSequences(utf8.decode(removeExtraBreaks(input)));
  }

  static bool isNewVersion(String currentVersion, String latestVersion) {
    List<int> currentVersionNumbers = versionNumbersFromString(currentVersion);
    List<int> comparedVersionNumbers = versionNumbersFromString(latestVersion);

    // Compare each component of the version number, starting from the major version
    for (int i = 0; i < currentVersionNumbers.length; i++) {
      int currentComponent = currentVersionNumbers[i];
      int comparedComponent =
          i < comparedVersionNumbers.length ? comparedVersionNumbers[i] : 0;

      if (currentComponent < comparedComponent) {
        return true;
      } else if (currentComponent > comparedComponent) {
        return false;
      }
    }

    // All version components are equal, so the versions are not new
    return false;
  }

  static List<int> versionNumbersFromString(String versionString) {
    // if version String like v1.2.3-debug, remove -debug
    if (versionString.contains('-')) {
      versionString = versionString.split('-')[0];
    }

    // Remove the leading "v" character and split the version string into components

    List<String> versionComponents = versionString.substring(1).split('.');

    // Convert each component to an integer and return the list of numbers
    return versionComponents.map((component) => int.parse(component)).toList();
  }
}