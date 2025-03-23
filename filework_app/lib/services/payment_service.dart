// lib/services/payment_service.dart
// यह फाइल पेमेंट्स (एडवांस और फाइनल पेमेंट) के मैनेजमेंट के लिए फंक्शन्स प्रदान करती है

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import 'work_service.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WorkService _workService = WorkService();
  final uuid = const Uuid();
  
  // सभी पेमेंट्स फेच करना (एडमिन/सब-एडमिन के लिए)
  Future<List<PaymentModel>> fetchAllPayments({
    String? workerId,
    String? paidBy,
    PaymentType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore.collection(AppConstants.paymentsCollection);
      
      // फिल्टर्स अप्लाई करें
      if (workerId != null) {
        query = query.where('workerId', isEqualTo: workerId);
      }
      
      if (paidBy != null) {
        query = query.where('paidBy', isEqualTo: paidBy);
      }
      
      if (type != null) {
        final typeStr = type == PaymentType.advance ? 'advance' : 'final_payment';
        query = query.where('type', isEqualTo: typeStr);
      }
      
      final paymentsSnapshot = await query.get();
      
      List<PaymentModel> paymentList = paymentsSnapshot.docs
          .map((doc) => PaymentModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      // डेट फिल्टर अप्लाई करें
      if (startDate != null || endDate != null) {
        paymentList = paymentList.where((payment) {
          final paymentDate = payment.paymentDate;
          
          if (startDate != null && endDate != null) {
            return paymentDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
                   paymentDate.isBefore(endDate.add(const Duration(days: 1)));
          } else if (startDate != null) {
            return paymentDate.isAfter(startDate.subtract(const Duration(days: 1)));
          } else if (endDate != null) {
            return paymentDate.isBefore(endDate.add(const Duration(days: 1)));
          }
          
          return true;
        }).toList();
      }
      
      // डेट के अनुसार सॉर्ट करें (न्यूएस्ट फर्स्ट)
      paymentList.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
      
      return paymentList;
    } catch (e) {
      throw 'पेमेंट्स फेच करना असफल: $e';
    }
  }
  
  // स्पेसिफिक वर्कर की पेमेंट्स फेच करना
  Future<List<PaymentModel>> fetchWorkerPayments(String workerId, {PaymentType? type}) async {
    try {
      Query query = _firestore
          .collection(AppConstants.paymentsCollection)
          .where('workerId', isEqualTo: workerId);
      
      if (type != null) {
        final typeStr = type == PaymentType.advance ? 'advance' : 'final_payment';
        query = query.where('type', isEqualTo: typeStr);
      }
      
      final paymentsSnapshot = await query.get();
      
      List<PaymentModel> paymentList = paymentsSnapshot.docs
          .map((doc) => PaymentModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      // डेट के अनुसार सॉर्ट करें (न्यूएस्ट फर्स्ट)
      paymentList.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
      
      return paymentList;
    } catch (e) {
      throw 'वर्कर की पेमेंट्स फेच करना असफल: $e';
    }
  }
  
  // एक स्पेसिफिक पेमेंट फेच करना
  Future<PaymentModel?> fetchPaymentById(String id) async {
    try {
      final paymentDoc = await _firestore
          .collection(AppConstants.paymentsCollection)
          .doc(id)
          .get();
      
      if (!paymentDoc.exists || paymentDoc.data() == null) {
        return null;
      }
      
      return PaymentModel.fromJson(paymentDoc.data()!);
    } catch (e) {
      throw 'पेमेंट फेच करना असफल: $e';
    }
  }
  
  // एडवांस पेमेंट क्रिएट करना
  Future<PaymentModel> createAdvancePayment({
    required String workerId,
    required String workerName,
    required double amount,
    required String description,
    required DateTime paymentDate,
    required String paidBy,
    required String paidByName,
  }) async {
    try {
      // पेमेंट ID जनरेट करें
      final id = uuid.v4();
      
      // नया पेमेंट मॉडल बनाएं
      final newPayment = PaymentModel(
        id: id,
        workerId: workerId,
        workerName: workerName,
        amount: amount,
        type: PaymentType.advance,
        description: description,
        paymentDate: paymentDate,
        paidBy: paidBy,
        paidByName: paidByName,
        createdAt: DateTime.now(),
      );
      
      // फायरस्टोर में पेमेंट सेव करें
      await _firestore
          .collection(AppConstants.paymentsCollection)
          .doc(id)
          .set(newPayment.toJson());
      
      return newPayment;
    } catch (e) {
      throw 'एडवांस पेमेंट क्रिएट करना असफल: $e';
    }
  }
  
  // फाइनल पेमेंट क्रिएट करना (वर्क अमाउंट्स का सेटलमेंट)
  Future<PaymentModel> createFinalPayment({
    required String workerId,
    required String workerName,
    required double amount,
    required List<String> workIds,
    required String month,
    required String year,
    required String description,
    required DateTime paymentDate,
    required String paidBy,
    required String paidByName,
  }) async {
    try {
      // पेमेंट ID जनरेट करें
      final id = uuid.v4();
      
      // फायरबेस ट्रांजैक्शन यूज़ करें
      // 1. नया पेमेंट क्रिएट करें
      // 2. वर्क आइटम्स को पेड मार्क करें
      
      // नया पेमेंट मॉडल बनाएं
      final newPayment = PaymentModel(
        id: id,
        workerId: workerId,
        workerName: workerName,
        amount: amount,
        type: PaymentType.final_payment,
        description: description,
        paymentDate: paymentDate,
        paidBy: paidBy,
        paidByName: paidByName,
        createdAt: DateTime.now(),
        month: month,
        year: year,
        workIds: workIds,
      );
      
      // फायरस्टोर में पेमेंट सेव करें
      await _firestore
          .collection(AppConstants.paymentsCollection)
          .doc(id)
          .set(newPayment.toJson());
      
      // वर्क आइटम्स को पेड मार्क करें
      await _workService.markWorkAsPaid(workIds, paymentDate);
      
      return newPayment;
    } catch (e) {
      throw 'फाइनल पेमेंट क्रिएट करना असफल: $e';
    }
  }
  
  // वर्कर का एडवांस टोटल कैलकुलेट करें
  Future<double> calculateTotalAdvance(String workerId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      Query query = _firestore
          .collection(AppConstants.paymentsCollection)
          .where('workerId', isEqualTo: workerId)
          .where('type', isEqualTo: 'advance');
      
      final advancePayments = await query.get();
      
      double total = 0;
      
      for (final doc in advancePayments.docs) {
        final payment = PaymentModel.fromJson(doc.data() as Map<String, dynamic>);
        
        // डेट रेंज चेक करें अगर स्पेसिफाइड है
        if (startDate != null && endDate != null) {
          if (payment.paymentDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
              payment.paymentDate.isBefore(endDate.add(const Duration(days: 1)))) {
            total += payment.amount;
          }
        } else {
          total += payment.amount;
        }
      }
      
      return total;
    } catch (e) {
      throw 'एडवांस टोटल कैलकुलेट करना असफल: $e';
    }
  }
  
  // वर्कर का टोटल अर्निंग और पेमेंट सम्मरी कैलकुलेट करें
  Future<Map<String, dynamic>> calculateWorkerPaymentSummary(String workerId) async {
    try {
      // टोटल अर्निंग (सभी वर्क)
      final allWork = await _firestore
          .collection(AppConstants.workCollection)
          .where('workerId', isEqualTo: workerId)
          .get();
      
      double totalEarning = 0;
      double paidAmount = 0;
      double pendingAmount = 0;
      
      for (final doc in allWork.docs) {
        final work = WorkModel.fromJson(doc.data() as Map<String, dynamic>);
        totalEarning += work.totalAmount;
        
        if (work.isPaid) {
          paidAmount += work.totalAmount;
        } else {
          pendingAmount += work.totalAmount;
        }
      }
      
      // टोटल एडवांस
      final totalAdvance = await calculateTotalAdvance(workerId);
      
      return {
        'totalEarning': totalEarning,
        'paidAmount': paidAmount,
        'pendingAmount': pendingAmount,
        'totalAdvance': totalAdvance,
        'remainingPayment': pendingAmount - totalAdvance > 0 ? pendingAmount - totalAdvance : 0,
      };
    } catch (e) {
      throw 'वर्कर पेमेंट सम्मरी कैलकुलेट करना असफल: $e';
    }
  }
  
  // मंथली पेमेंट हिस्ट्री (एडमिन के लिए)
  Future<Map<String, dynamic>> getMonthlyPaymentHistory(int month, int year) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0); // मंथ का अंतिम दिन
      
      // सभी एडवांस और फाइनल पेमेंट्स फेच करें 
      final paymentsSnapshot = await _firestore
          .collection(AppConstants.paymentsCollection)
          .get();
      
      double totalAdvance = 0;
      double totalFinal = 0;
      List<PaymentModel> advancePayments = [];
      List<PaymentModel> finalPayments = [];
      
      for (final doc in paymentsSnapshot.docs) {
        final payment = PaymentModel.fromJson(doc.data() as Map<String, dynamic>);
        final paymentDate = payment.paymentDate;
        
        if (paymentDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
            paymentDate.isBefore(endDate.add(const Duration(days: 1)))) {
          
          if (payment.type == PaymentType.advance) {
            totalAdvance += payment.amount;
            advancePayments.add(payment);
          } else {
            totalFinal += payment.amount;
            finalPayments.add(payment);
          }
        }
      }
      
      return {
        'totalAdvance': totalAdvance,
        'totalFinal': totalFinal,
        'totalPaid': totalAdvance + totalFinal,
        'advancePayments': advancePayments,
        'finalPayments': finalPayments,
        'month': month,
        'year': year,
      };
    } catch (e) {
      throw 'मंथली पेमेंट हिस्ट्री फेच करना असफल: $e';
    }
  }
} 