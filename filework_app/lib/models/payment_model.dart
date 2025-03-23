// lib/models/payment_model.dart
// यह फाइल पेमेंट मॉडल को परिभाषित करती है, जिसमें एडवांस और फाइनल पेमेंट का विवरण है।

enum PaymentType {
  advance,  // एडवांस पेमेंट
  final_payment,  // फाइनल पेमेंट (मंथ एंड)
}

class PaymentModel {
  final String id;
  final String workerId; // वर्कर का uid
  final String workerName; // वर्कर का नाम
  final double amount; // भुगतान की राशि
  final PaymentType type; // पेमेंट का प्रकार (एडवांस या फाइनल)
  final String description; // भुगतान का विवरण
  final DateTime paymentDate; // भुगतान की तारीख
  final String paidBy; // किसने भुगतान किया (admin या sub-admin का uid)
  final String paidByName; // भुगतान करने वाले का नाम
  final DateTime createdAt;
  final String? month; // किस महीने का भुगतान (फाइनल पेमेंट के लिए)
  final String? year; // किस साल का भुगतान (फाइनल पेमेंट के लिए)
  final List<String>? workIds; // भुगतान से संबंधित वर्क IDs (फाइनल पेमेंट के लिए)

  PaymentModel({
    required this.id,
    required this.workerId,
    required this.workerName,
    required this.amount,
    required this.type,
    required this.description,
    required this.paymentDate,
    required this.paidBy,
    required this.paidByName,
    required this.createdAt,
    this.month,
    this.year,
    this.workIds,
  });

  // JSON से पेमेंट मॉडल बनाना
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      workerId: json['workerId'] ?? '',
      workerName: json['workerName'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      type: json['type'] == 'advance' 
          ? PaymentType.advance 
          : PaymentType.final_payment,
      description: json['description'] ?? '',
      paymentDate: json['paymentDate'] != null 
          ? DateTime.parse(json['paymentDate']) 
          : DateTime.now(),
      paidBy: json['paidBy'] ?? '',
      paidByName: json['paidByName'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      month: json['month'],
      year: json['year'],
      workIds: json['workIds'] != null 
          ? List<String>.from(json['workIds']) 
          : null,
    );
  }

  // पेमेंट मॉडल से JSON बनाना
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workerId': workerId,
      'workerName': workerName,
      'amount': amount,
      'type': type == PaymentType.advance ? 'advance' : 'final_payment',
      'description': description,
      'paymentDate': paymentDate.toIso8601String(),
      'paidBy': paidBy,
      'paidByName': paidByName,
      'createdAt': createdAt.toIso8601String(),
      'month': month,
      'year': year,
      'workIds': workIds,
    };
  }

  // पेमेंट मॉडल को कॉपी करके नए डेटा के साथ अपडेट करना
  PaymentModel copyWith({
    String? id,
    String? workerId,
    String? workerName,
    double? amount,
    PaymentType? type,
    String? description,
    DateTime? paymentDate,
    String? paidBy,
    String? paidByName,
    DateTime? createdAt,
    String? month,
    String? year,
    List<String>? workIds,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      paymentDate: paymentDate ?? this.paymentDate,
      paidBy: paidBy ?? this.paidBy,
      paidByName: paidByName ?? this.paidByName,
      createdAt: createdAt ?? this.createdAt,
      month: month ?? this.month,
      year: year ?? this.year,
      workIds: workIds ?? this.workIds,
    );
  }
} 