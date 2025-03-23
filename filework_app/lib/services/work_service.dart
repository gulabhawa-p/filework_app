// lib/services/work_service.dart
// यह फाइल वर्क (वर्कर्स द्वारा किए गए काम) के मैनेजमेंट के लिए फंक्शन्स प्रदान करती है

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../utils/constants.dart';

class WorkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uuid = const Uuid();
  
  // सभी वर्क फेच करना (एडमिन/सब-एडमिन के लिए)
  Future<List<WorkModel>> fetchAllWork({
    String? workerId,
    String? assignedBy,
    DateTime? startDate,
    DateTime? endDate,
    bool? isPaid,
  }) async {
    try {
      Query query = _firestore.collection(AppConstants.workCollection);
      
      // फिल्टर्स अप्लाई करें
      if (workerId != null) {
        query = query.where('workerId', isEqualTo: workerId);
      }
      
      if (assignedBy != null) {
        query = query.where('assignedBy', isEqualTo: assignedBy);
      }
      
      if (isPaid != null) {
        query = query.where('isPaid', isEqualTo: isPaid);
      }
      
      final workSnapshot = await query.get();
      
      List<WorkModel> workList = workSnapshot.docs
          .map((doc) => WorkModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      // डेट फिल्टर मैन्युअली अप्लाई करें (फायरस्टोर में रेंज क्वेरी कॉम्प्लेक्स हो सकती है)
      if (startDate != null || endDate != null) {
        workList = workList.where((work) {
          final workDate = work.workDate;
          
          if (startDate != null && endDate != null) {
            return workDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
                   workDate.isBefore(endDate.add(const Duration(days: 1)));
          } else if (startDate != null) {
            return workDate.isAfter(startDate.subtract(const Duration(days: 1)));
          } else if (endDate != null) {
            return workDate.isBefore(endDate.add(const Duration(days: 1)));
          }
          
          return true;
        }).toList();
      }
      
      // डेट और क्वांटिटी के अनुसार सॉर्ट करें
      workList.sort((a, b) {
        final dateComparison = b.workDate.compareTo(a.workDate);
        if (dateComparison != 0) return dateComparison;
        return b.quantity.compareTo(a.quantity);
      });
      
      return workList;
    } catch (e) {
      throw 'वर्क फेच करना असफल: $e';
    }
  }
  
  // एक स्पेसिफिक वर्क आइटम फेच करना
  Future<WorkModel?> fetchWorkById(String id) async {
    try {
      final workDoc = await _firestore
          .collection(AppConstants.workCollection)
          .doc(id)
          .get();
      
      if (!workDoc.exists || workDoc.data() == null) {
        return null;
      }
      
      return WorkModel.fromJson(workDoc.data()!);
    } catch (e) {
      throw 'वर्क फेच करना असफल: $e';
    }
  }
  
  // स्पेसिफिक वर्कर का वर्क फेच करना
  Future<List<WorkModel>> fetchWorkerWork(String workerId, {bool? isPaid}) async {
    try {
      Query query = _firestore
          .collection(AppConstants.workCollection)
          .where('workerId', isEqualTo: workerId);
      
      if (isPaid != null) {
        query = query.where('isPaid', isEqualTo: isPaid);
      }
      
      final workSnapshot = await query.get();
      
      List<WorkModel> workList = workSnapshot.docs
          .map((doc) => WorkModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      
      // डेट के अनुसार डिसेंडिंग सॉर्ट करें
      workList.sort((a, b) => b.workDate.compareTo(a.workDate));
      
      return workList;
    } catch (e) {
      throw 'वर्कर का वर्क फेच करना असफल: $e';
    }
  }
  
  // नया वर्क रिकॉर्ड क्रिएट करना
  Future<WorkModel> createWork({
    required String workerId,
    required String workerName,
    required String productId,
    required String productName,
    required int quantity,
    required double rate,
    required DateTime workDate,
    required String assignedBy,
  }) async {
    try {
      // वर्क ID जनरेट करें
      final id = uuid.v4();
      
      // टोटल अमाउंट कैलकुलेट करें
      final totalAmount = quantity * rate;
      
      // नया वर्क मॉडल बनाएं
      final newWork = WorkModel(
        id: id,
        workerId: workerId,
        workerName: workerName,
        productId: productId,
        productName: productName,
        quantity: quantity,
        rate: rate,
        totalAmount: totalAmount,
        workDate: workDate,
        assignedBy: assignedBy,
        createdAt: DateTime.now(),
        isPaid: false,
      );
      
      // फायरस्टोर में वर्क सेव करें
      await _firestore
          .collection(AppConstants.workCollection)
          .doc(id)
          .set(newWork.toJson());
      
      return newWork;
    } catch (e) {
      throw 'वर्क रिकॉर्ड क्रिएट करना असफल: $e';
    }
  }
  
  // वर्क अपडेट करना
  Future<WorkModel> updateWork({
    required String id,
    int? quantity,
    double? rate,
    DateTime? workDate,
  }) async {
    try {
      // वर्तमान वर्क फेच करें
      final workDoc = await _firestore
          .collection(AppConstants.workCollection)
          .doc(id)
          .get();
      
      if (!workDoc.exists || workDoc.data() == null) {
        throw 'वर्क रिकॉर्ड नहीं मिला।';
      }
      
      final currentWork = WorkModel.fromJson(workDoc.data()!);
      
      // अगर पहले से पेड है, तो अपडेट न करें
      if (currentWork.isPaid) {
        throw 'पेड वर्क अपडेट नहीं किया जा सकता।';
      }
      
      // अपडेट के लिए डेटा प्रिपेयर करें
      final updatedQuantity = quantity ?? currentWork.quantity;
      final updatedRate = rate ?? currentWork.rate;
      final updatedWorkDate = workDate ?? currentWork.workDate;
      
      // न्यू टोटल अमाउंट कैलकुलेट करें
      final totalAmount = updatedQuantity * updatedRate;
      
      final data = <String, dynamic>{
        'quantity': updatedQuantity,
        'rate': updatedRate,
        'totalAmount': totalAmount,
        'workDate': updatedWorkDate.toIso8601String(),
      };
      
      // फायरस्टोर में वर्क अपडेट करें
      await _firestore
          .collection(AppConstants.workCollection)
          .doc(id)
          .update(data);
      
      // अपडेटेड वर्क रिटर्न करें
      return currentWork.copyWith(
        quantity: updatedQuantity,
        rate: updatedRate,
        totalAmount: totalAmount,
        workDate: updatedWorkDate,
      );
    } catch (e) {
      throw 'वर्क अपडेट करना असफल: $e';
    }
  }
  
  // वर्क को डिलीट करना
  Future<void> deleteWork(String id) async {
    try {
      // पहले चेक करें कि वर्क पेड तो नहीं है
      final workDoc = await _firestore
          .collection(AppConstants.workCollection)
          .doc(id)
          .get();
      
      if (!workDoc.exists || workDoc.data() == null) {
        throw 'वर्क रिकॉर्ड नहीं मिला।';
      }
      
      final work = WorkModel.fromJson(workDoc.data()!);
      
      if (work.isPaid) {
        throw 'पेड वर्क डिलीट नहीं किया जा सकता।';
      }
      
      // फायरस्टोर से वर्क डिलीट करें
      await _firestore
          .collection(AppConstants.workCollection)
          .doc(id)
          .delete();
    } catch (e) {
      throw 'वर्क डिलीट करना असफल: $e';
    }
  }
  
  // मल्टिपल वर्क्स मार्क एज पेड
  Future<void> markWorkAsPaid(List<String> workIds, DateTime paidDate) async {
    try {
      // बैच ट्रांजैक्शन का उपयोग करें
      final batch = _firestore.batch();
      
      for (final id in workIds) {
        final docRef = _firestore
            .collection(AppConstants.workCollection)
            .doc(id);
        
        batch.update(docRef, {
          'isPaid': true,
          'paidDate': paidDate.toIso8601String(),
        });
      }
      
      await batch.commit();
    } catch (e) {
      throw 'वर्क को पेड मार्क करना असफल: $e';
    }
  }
  
  // वर्कर का पेंडिंग (अनपेड) टोटल अमाउंट कैलकुलेट करें
  Future<double> calculatePendingAmount(String workerId) async {
    try {
      final unpaidWork = await _firestore
          .collection(AppConstants.workCollection)
          .where('workerId', isEqualTo: workerId)
          .where('isPaid', isEqualTo: false)
          .get();
      
      double total = 0;
      
      for (final doc in unpaidWork.docs) {
        final work = WorkModel.fromJson(doc.data() as Map<String, dynamic>);
        total += work.totalAmount;
      }
      
      return total;
    } catch (e) {
      throw 'पेंडिंग अमाउंट कैलकुलेट करना असफल: $e';
    }
  }
  
  // मंथली वर्क सम्मरी कैलकुलेट करें (एडमिन रिपोर्ट्स के लिए)
  Future<Map<String, dynamic>> calculateMonthlySummary(int month, int year) async {
    try {
      final workDocs = await _firestore
          .collection(AppConstants.workCollection)
          .get();
      
      // इनिशियलाइज़ करें
      double totalProduction = 0;
      int totalQuantity = 0;
      Map<String, int> productWiseCount = {};
      Map<String, double> workerWiseProduction = {};
      
      // फिल्टर करें और डेटा कैलकुलेट करें
      for (final doc in workDocs.docs) {
        final work = WorkModel.fromJson(doc.data() as Map<String, dynamic>);
        
        // चेक करें कि यह वर्क स्पेसिफाइड मंथ और ईयर के लिए है
        if (work.workDate.month == month && work.workDate.year == year) {
          totalProduction += work.totalAmount;
          totalQuantity += work.quantity;
          
          // प्रोडक्ट वाइज़ कैलकुलेशन
          if (productWiseCount.containsKey(work.productId)) {
            productWiseCount[work.productId] = (productWiseCount[work.productId] ?? 0) + work.quantity;
          } else {
            productWiseCount[work.productId] = work.quantity;
          }
          
          // वर्कर वाइज़ कैलकुलेशन
          if (workerWiseProduction.containsKey(work.workerId)) {
            workerWiseProduction[work.workerId] = (workerWiseProduction[work.workerId] ?? 0) + work.totalAmount;
          } else {
            workerWiseProduction[work.workerId] = work.totalAmount;
          }
        }
      }
      
      return {
        'totalProduction': totalProduction,
        'totalQuantity': totalQuantity,
        'productWiseCount': productWiseCount,
        'workerWiseProduction': workerWiseProduction,
        'month': month,
        'year': year,
      };
    } catch (e) {
      throw 'मंथली सम्मरी कैलकुलेट करना असफल: $e';
    }
  }
} 