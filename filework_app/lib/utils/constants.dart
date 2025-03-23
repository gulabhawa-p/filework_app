// lib/utils/constants.dart
// यह फाइल एप्लिकेशन में उपयोग किए जाने वाले स्थिर मानों को परिभाषित करती है

import 'package:flutter/material.dart';

// एप्लिकेशन बेसिक डेटा
class AppConstants {
  static const String appName = 'फाइल वर्क';
  static const String appVersion = '1.0.0';
  
  // रोल्स
  static const String roleAdmin = 'admin';
  static const String roleSubAdmin = 'sub_admin';
  static const String roleWorker = 'worker';
  
  // फायरबेस कलेक्शन्स
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String workCollection = 'work';
  static const String paymentsCollection = 'payments';
  static const String settingsCollection = 'settings';
  static const String appSettingsDocId = 'app_settings';
  
  // स्टोरेज पाथ
  static const String userProfilesStorage = 'user_profiles';
  static const String productImagesStorage = 'product_images';
  static const String appAssetsStorage = 'app_assets';
  
  // शेयर्ड प्रेफरेंस कीज
  static const String themeModePref = 'theme_mode';
  static const String userDataPref = 'user_data';
  static const String appSettingsPref = 'app_settings';
  
  // एरर मैसेज
  static const String somethingWentWrong = 'कुछ गड़बड़ हो गई। कृपया बाद में पुनः प्रयास करें।';
  static const String noInternetConnection = 'इंटरनेट कनेक्शन नहीं है। कृपया अपना कनेक्शन जांचें और पुनः प्रयास करें।';
  static const String unexpectedError = 'अप्रत्याशित त्रुटि। कृपया बाद में पुनः प्रयास करें।';
  
  // सक्सेस मैसेज
  static const String loginSuccess = 'सफलतापूर्वक लॉगिन किया गया!';
  static const String logoutSuccess = 'सफलतापूर्वक लॉगआउट किया गया!';
  static const String dataSaved = 'डेटा सफलतापूर्वक सहेजा गया!';
  static const String dataUpdated = 'डेटा सफलतापूर्वक अपडेट किया गया!';
  static const String dataDeleted = 'डेटा सफलतापूर्वक हटाया गया!';
  
  // थीम कलर्स
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03A9F4);
  static const Color accentColor = Color(0xFFFFA000);
  static const Color textColor = Color(0xFF333333);
  static const Color lightGreyColor = Color(0xFFEEEEEE);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  
  // पेडिंग और मार्जिन
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  
  // बॉर्डर रेडियस
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
  
  // आइकन साइज़
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // फॉन्ट साइज़
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeExtraLarge = 20.0;
  static const double fontSizeHeading = 24.0;
} 