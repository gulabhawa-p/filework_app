// lib/models/user_model.dart
// यह फाइल यूजर मॉडल को परिभाषित करती है, जिसमें एडमिन, सब-एडमिन और वर्कर का डेटा स्ट्रक्चर है।

class UserModel {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String role; // "admin", "sub_admin", or "worker"
  final double pieceRate; // प्रति टुकड़ा दर (केवल वर्कर के लिए)
  final String assignedAdmin; // सब-एडमिन और वर्कर के लिए, जिसने उन्हें असाइन किया है
  final DateTime createdAt;
  final String profileImage;
  final Map<String, dynamic> appSettings; // केवल एडमिन के लिए ऐप सेटिंग्स

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    this.pieceRate = 0.0,
    this.assignedAdmin = '',
    required this.createdAt,
    this.profileImage = '',
    this.appSettings = const {},
  });

  // JSON से यूजर मॉडल बनाना
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'worker',
      pieceRate: json['pieceRate']?.toDouble() ?? 0.0,
      assignedAdmin: json['assignedAdmin'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      profileImage: json['profileImage'] ?? '',
      appSettings: json['appSettings'] ?? {},
    );
  }

  // यूजर मॉडल से JSON बनाना
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'pieceRate': pieceRate,
      'assignedAdmin': assignedAdmin,
      'createdAt': createdAt.toIso8601String(),
      'profileImage': profileImage,
      'appSettings': appSettings,
    };
  }

  // यूजर मॉडल को कॉपी करके नए डेटा के साथ अपडेट करना
  UserModel copyWith({
    String? uid,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? role,
    double? pieceRate,
    String? assignedAdmin,
    DateTime? createdAt,
    String? profileImage,
    Map<String, dynamic>? appSettings,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      pieceRate: pieceRate ?? this.pieceRate,
      assignedAdmin: assignedAdmin ?? this.assignedAdmin,
      createdAt: createdAt ?? this.createdAt,
      profileImage: profileImage ?? this.profileImage,
      appSettings: appSettings ?? this.appSettings,
    );
  }
} 