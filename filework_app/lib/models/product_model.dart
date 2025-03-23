// lib/models/product_model.dart
// यह फाइल प्रोडक्ट (फाइल प्रकार) मॉडल को परिभाषित करती है।

class ProductModel {
  final String id;
  final String name; // फाइल का नाम (उदाहरण: ऑफिस फाइल, हॉस्पिटल फाइल)
  final String description;
  final double rate; // प्रति नग दर
  final String createdBy; // किस एडमिन ने बनाया
  final DateTime createdAt;
  final String imageUrl;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rate,
    required this.createdBy,
    required this.createdAt,
    this.imageUrl = '',
    this.isActive = true,
  });

  // JSON से प्रोडक्ट मॉडल बनाना
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      rate: json['rate']?.toDouble() ?? 0.0,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  // प्रोडक्ट मॉडल से JSON बनाना
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rate': rate,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }

  // प्रोडक्ट मॉडल को कॉपी करके नए डेटा के साथ अपडेट करना
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? rate,
    String? createdBy,
    DateTime? createdAt,
    String? imageUrl,
    bool? isActive,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }
} 