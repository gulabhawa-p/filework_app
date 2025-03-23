// lib/models/app_settings_model.dart
// यह फाइल ऐप के सेटिंग्स मॉडल को परिभाषित करती है, जिसे एडमिन द्वारा कॉन्फ़िगर किया जा सकता है।

class AppSettingsModel {
  final String id;
  final String appName; // ऐप का नाम
  final String currency; // मुद्रा (₹, $, € आदि)
  final bool enableNotifications; // नोटिफिकेशन सक्षम करें या नहीं
  final String primaryColor; // प्राइमरी थीम कलर
  final bool darkMode; // डार्क मोड सक्षम है या नहीं
  final String logo; // ऐप लोगो URL
  final String adminContact; // एडमिन कांटेक्ट नंबर
  final String adminEmail; // एडमिन ईमेल
  final DateTime lastUpdated;
  final String updatedBy; // किसने अपडेट किया

  AppSettingsModel({
    required this.id,
    this.appName = 'फाइल वर्क ऐप',
    this.currency = '₹',
    this.enableNotifications = true,
    this.primaryColor = '#1976D2', // डिफ़ॉल्ट ब्लू कलर
    this.darkMode = false,
    this.logo = '',
    this.adminContact = '',
    this.adminEmail = '',
    required this.lastUpdated,
    required this.updatedBy,
  });

  // JSON से ऐप सेटिंग्स मॉडल बनाना
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      id: json['id'] ?? 'app_settings',
      appName: json['appName'] ?? 'फाइल वर्क ऐप',
      currency: json['currency'] ?? '₹',
      enableNotifications: json['enableNotifications'] ?? true,
      primaryColor: json['primaryColor'] ?? '#1976D2',
      darkMode: json['darkMode'] ?? false,
      logo: json['logo'] ?? '',
      adminContact: json['adminContact'] ?? '',
      adminEmail: json['adminEmail'] ?? '',
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated']) 
          : DateTime.now(),
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  // ऐप सेटिंग्स मॉडल से JSON बनाना
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appName': appName,
      'currency': currency,
      'enableNotifications': enableNotifications,
      'primaryColor': primaryColor,
      'darkMode': darkMode,
      'logo': logo,
      'adminContact': adminContact,
      'adminEmail': adminEmail,
      'lastUpdated': lastUpdated.toIso8601String(),
      'updatedBy': updatedBy,
    };
  }

  // ऐप सेटिंग्स मॉडल को कॉपी करके नए डेटा के साथ अपडेट करना
  AppSettingsModel copyWith({
    String? id,
    String? appName,
    String? currency,
    bool? enableNotifications,
    String? primaryColor,
    bool? darkMode,
    String? logo,
    String? adminContact,
    String? adminEmail,
    DateTime? lastUpdated,
    String? updatedBy,
  }) {
    return AppSettingsModel(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      currency: currency ?? this.currency,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      primaryColor: primaryColor ?? this.primaryColor,
      darkMode: darkMode ?? this.darkMode,
      logo: logo ?? this.logo,
      adminContact: adminContact ?? this.adminContact,
      adminEmail: adminEmail ?? this.adminEmail,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
} 