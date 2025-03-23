// lib/models/work_model.dart
// यह फाइल वर्क मॉडल को परिभाषित करती है, जिसमें कर्मचारियों द्वारा किए गए काम का विवरण है।

class WorkModel {
  final String id;
  final String workerId; // वर्कर का uid
  final String workerName; // वर्कर का नाम
  final String productId; // किस प्रोडक्ट/फाइल पर काम किया
  final String productName; // प्रोडक्ट का नाम
  final int quantity; // कितनी फाइल्स बनाईं
  final double rate; // प्रति फाइल दर
  final double totalAmount; // कुल राशि (quantity * rate)
  final DateTime workDate; // काम की तारीख
  final String assignedBy; // किसने असाइन किया (admin या sub-admin का uid)
  final DateTime createdAt;
  final bool isPaid; // भुगतान हो गया है या नहीं
  final DateTime? paidDate; // भुगतान की तारीख

  WorkModel({
    required this.id,
    required this.workerId,
    required this.workerName,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.rate,
    required this.totalAmount,
    required this.workDate,
    required this.assignedBy,
    required this.createdAt,
    this.isPaid = false,
    this.paidDate,
  });

  // JSON से वर्क मॉडल बनाना
  factory WorkModel.fromJson(Map<String, dynamic> json) {
    return WorkModel(
      id: json['id'] ?? '',
      workerId: json['workerId'] ?? '',
      workerName: json['workerName'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      rate: json['rate']?.toDouble() ?? 0.0,
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
      workDate: json['workDate'] != null 
          ? DateTime.parse(json['workDate']) 
          : DateTime.now(),
      assignedBy: json['assignedBy'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isPaid: json['isPaid'] ?? false,
      paidDate: json['paidDate'] != null 
          ? DateTime.parse(json['paidDate']) 
          : null,
    );
  }

  // वर्क मॉडल से JSON बनाना
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workerId': workerId,
      'workerName': workerName,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'rate': rate,
      'totalAmount': totalAmount,
      'workDate': workDate.toIso8601String(),
      'assignedBy': assignedBy,
      'createdAt': createdAt.toIso8601String(),
      'isPaid': isPaid,
      'paidDate': paidDate?.toIso8601String(),
    };
  }

  // वर्क मॉडल को कॉपी करके नए डेटा के साथ अपडेट करना
  WorkModel copyWith({
    String? id,
    String? workerId,
    String? workerName,
    String? productId,
    String? productName,
    int? quantity,
    double? rate,
    double? totalAmount,
    DateTime? workDate,
    String? assignedBy,
    DateTime? createdAt,
    bool? isPaid,
    DateTime? paidDate,
  }) {
    return WorkModel(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      totalAmount: totalAmount ?? this.totalAmount,
      workDate: workDate ?? this.workDate,
      assignedBy: assignedBy ?? this.assignedBy,
      createdAt: createdAt ?? this.createdAt,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
    );
  }
} 