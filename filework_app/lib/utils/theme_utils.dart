// lib/utils/theme_utils.dart
// यह फाइल एप्लिकेशन की थीम डिफाइन करती है, जिसमें लाइट और डार्क मोड शामिल हैं

import 'package:flutter/material.dart';
import 'constants.dart';

class ThemeUtils {
  // लाइट थीम
  static ThemeData getLightTheme() {
    return ThemeData(
      // प्राइमरी एंड सेकेंडरी कलर
      primaryColor: AppConstants.primaryColor,
      colorScheme: ColorScheme.light(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      
      // एप्प बार थीम
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // बटन थीम
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppConstants.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // टेक्स्ट फील्ड थीम
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 1.0),
        ),
        errorStyle: const TextStyle(
          color: AppConstants.errorColor,
          fontSize: 12.0,
        ),
      ),
      
      // कार्ड थीम
      cardTheme: CardTheme(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        margin: const EdgeInsets.all(8.0),
      ),
      
      // फॉन्ट थीम
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
        ),
        displayMedium: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
        ),
        displaySmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: AppConstants.textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: AppConstants.textColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        ),
      ),
      
      // बैकग्राउंड कलर थीम
      scaffoldBackgroundColor: Colors.grey[100],
    );
  }

  // डार्क थीम
  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
      // प्राइमरी एंड सेकेंडरी कलर
      primaryColor: AppConstants.primaryColor,
      colorScheme: ColorScheme.dark(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        surface: const Color(0xFF303030),
        background: const Color(0xFF212121),
        onSurface: Colors.white,
      ),
      
      // एप्प बार थीम
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF303030),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // बटन थीम
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppConstants.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // टेक्स्ट फील्ड थीम
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppConstants.errorColor, width: 1.0),
        ),
        errorStyle: const TextStyle(
          color: AppConstants.errorColor,
          fontSize: 12.0,
        ),
      ),
      
      // कार्ड थीम
      cardTheme: CardTheme(
        color: const Color(0xFF424242),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        margin: const EdgeInsets.all(8.0),
      ),
      
      // स्कैफोल्ड बैकग्राउंड थीम
      scaffoldBackgroundColor: const Color(0xFF212121),
    );
  }

  // हेक्स कलर से Flutter Color ऑब्जेक्ट बनाने का फंक्शन
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
} 