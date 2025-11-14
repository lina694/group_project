import 'dart:io';

/// Helper class for handling localization strings
class LocalizationHelper {
  /// Checks if device is set to British English
  static bool isBritishEnglish() {
    final locale = Platform.localeName;
    return locale.contains('en_GB') || locale.contains('en-GB');
  }

  /// Returns "Kilometers" or "Kilometres" based on locale
  static String get kilometers {
    return isBritishEnglish() ? 'Kilometres Driven' : 'Kilometers Driven';
  }

  /// Returns "Kilometers" or "Kilometres" hint based on locale
  static String get kilometersHint {
    return isBritishEnglish()
        ? 'Total kilometres driven'
        : 'Total kilometers driven';
  }
}