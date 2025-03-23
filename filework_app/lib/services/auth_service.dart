// lib/services/auth_service.dart
// यह फाइल फायरबेस ऑथेंटिकेशन के लिए सर्विस प्रदान करती है

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // वर्तमान यूजर गेट करना
  User? get currentUser => _auth.currentUser;
  
  // ऑथ स्टेट चेंज स्ट्रीम (लॉगिन/लॉगआउट इवेंट्स)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // यूजरनेम और पासवर्ड से लॉगिन करना
  Future<UserModel> loginWithUsernamePassword(String username, String password) async {
    try {
      // यूजरनेम से यूज़र को फायरस्टोर में ढूंढें
      final userDocs = await _firestore
          .collection(AppConstants.usersCollection)
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      
      // यूजर न मिलने पर एरर थ्रो करें
      if (userDocs.docs.isEmpty) {
        throw 'इस यूजरनेम से कोई अकाउंट नहीं मिला।';
      }
      
      // फायरस्टोर से यूज़र डेटा प्राप्त करें
      final userData = userDocs.docs.first.data();
      final userEmail = userData['email'] as String;
      
      // फायरबेस ऑथ के साथ लॉगिन
      await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: password,
      );
      
      // यूजर मॉडल रिटर्न करें
      return UserModel.fromJson(userData);
    } on FirebaseAuthException catch (e) {
      // फायरबेस ऑथ एरर्स हैंडल करें
      switch (e.code) {
        case 'user-not-found':
          throw 'इस ईमेल से कोई अकाउंट नहीं मिला।';
        case 'wrong-password':
          throw 'गलत पासवर्ड। कृपया पुनः प्रयास करें।';
        case 'user-disabled':
          throw 'यह अकाउंट डिसेबल कर दिया गया है।';
        case 'invalid-email':
          throw 'अमान्य ईमेल फॉर्मेट।';
        case 'too-many-requests':
          throw 'कई गलत प्रयासों के कारण अकाउंट अस्थायी रूप से ब्लॉक है। बाद में पुनः प्रयास करें।';
        default:
          throw 'लॉगिन असफल: ${e.message}';
      }
    } catch (e) {
      throw 'लॉगिन असफल: $e';
    }
  }
  
  // ईमेल और पासवर्ड से लॉगिन
  Future<UserModel> loginWithEmailPassword(String email, String password) async {
    try {
      // फायरबेस ऑथ के साथ लॉगिन
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // लॉगिन के बाद यूजर डेटा फेच करें
      return await fetchCurrentUser();
    } on FirebaseAuthException catch (e) {
      // फायरबेस ऑथ एरर्स हैंडल करें
      switch (e.code) {
        case 'user-not-found':
          throw 'इस ईमेल से कोई अकाउंट नहीं मिला।';
        case 'wrong-password':
          throw 'गलत पासवर्ड। कृपया पुनः प्रयास करें।';
        case 'user-disabled':
          throw 'यह अकाउंट डिसेबल कर दिया गया है।';
        case 'invalid-email':
          throw 'अमान्य ईमेल फॉर्मेट।';
        case 'too-many-requests':
          throw 'कई गलत प्रयासों के कारण अकाउंट अस्थायी रूप से ब्लॉक है। बाद में पुनः प्रयास करें।';
        default:
          throw 'लॉगिन असफल: ${e.message}';
      }
    } catch (e) {
      throw 'लॉगिन असफल: $e';
    }
  }
  
  // वर्तमान लॉगिन यूजर का डेटा फेच करें
  Future<UserModel> fetchCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        throw 'यूजर लॉगिन नहीं है।';
      }
      
      // फायरस्टोर से यूजर डेटा फेच करें
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .get();
      
      if (!userDoc.exists || userDoc.data() == null) {
        throw 'यूजर डेटा नहीं मिला।';
      }
      
      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw 'यूजर डेटा फेच करना असफल: $e';
    }
  }
  
  // यूजर रजिस्टर करें
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    required String username,
    String assignedAdmin = '',
    double pieceRate = 0.0,
  }) async {
    try {
      // यूजरनेम चेक करें कि पहले से मौजूद तो नहीं है
      final usernameCheck = await _firestore
          .collection(AppConstants.usersCollection)
          .where('username', isEqualTo: username)
          .get();
      
      if (usernameCheck.docs.isNotEmpty) {
        throw 'यह यूजरनेम पहले से ही इस्तेमाल में है। कृपया दूसरा यूजरनेम चुनें।';
      }
      
      // ईमेल से नया यूजर क्रिएट करें
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final uid = userCredential.user!.uid;
      
      // एडमिन रोल के लिए, अगर assignedAdmin खाली है, तो उसको अपना ही uid दें
      if (role == AppConstants.roleAdmin && assignedAdmin.isEmpty) {
        assignedAdmin = uid;
      }
      
      // यूजर मॉडल क्रिएट करें
      final newUser = UserModel(
        uid: uid,
        name: name,
        username: username,
        email: email,
        phone: phone,
        role: role,
        pieceRate: pieceRate,
        assignedAdmin: assignedAdmin,
        createdAt: DateTime.now(),
      );
      
      // फायरस्टोर में यूजर डेटा सेव करें
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(newUser.toJson());
      
      return newUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'यह ईमेल पहले से ही इस्तेमाल में है। कृपया दूसरा ईमेल चुनें या लॉगिन करें।';
        case 'weak-password':
          throw 'पासवर्ड बहुत कमजोर है। कृपया मजबूत पासवर्ड चुनें।';
        case 'invalid-email':
          throw 'अमान्य ईमेल फॉर्मेट।';
        default:
          throw 'रजिस्ट्रेशन असफल: ${e.message}';
      }
    } catch (e) {
      throw 'रजिस्ट्रेशन असफल: $e';
    }
  }
  
  // लॉगआउट करें
  Future<void> logout() async {
    try {
      await _auth.signOut();
      
      // शेयर्ड प्रेफरेंसेज से यूजर डेटा भी हटाएं
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
    } catch (e) {
      throw 'लॉगआउट असफल: $e';
    }
  }
  
  // यूजर प्रोफाइल अपडेट करें
  Future<UserModel> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? profileImage,
    double? pieceRate,
  }) async {
    try {
      // अपडेट करने के लिए डेटा प्रिपेयर करें
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (profileImage != null) updates['profileImage'] = profileImage;
      if (pieceRate != null) updates['pieceRate'] = pieceRate;
      
      // अगर कोई अपडेट नहीं है तो वर्तमान यूजर रिटर्न करें
      if (updates.isEmpty) {
        return await fetchCurrentUser();
      }
      
      // फायरस्टोर में यूजर अपडेट करें
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update(updates);
      
      // अपडेटेड यूजर का डेटा फेच करें
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      
      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw 'प्रोफाइल अपडेट करना असफल: $e';
    }
  }
  
  // पासवर्ड रीसेट ईमेल भेजें
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'इस ईमेल से कोई अकाउंट नहीं मिला।';
        case 'invalid-email':
          throw 'अमान्य ईमेल फॉर्मेट।';
        default:
          throw 'पासवर्ड रीसेट ईमेल भेजना असफल: ${e.message}';
      }
    } catch (e) {
      throw 'पासवर्ड रीसेट ईमेल भेजना असफल: $e';
    }
  }
  
  // वर्कर्स की लिस्ट फेच करें (एडमिन के लिए)
  Future<List<UserModel>> fetchWorkers(String adminId) async {
    try {
      final workersSnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .where('role', isEqualTo: AppConstants.roleWorker)
          .where('assignedAdmin', isEqualTo: adminId)
          .get();
      
      return workersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'वर्कर्स फेच करना असफल: $e';
    }
  }
  
  // सब-एडमिन की लिस्ट फेच करें (मेन एडमिन के लिए)
  Future<List<UserModel>> fetchSubAdmins(String adminId) async {
    try {
      final subAdminsSnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .where('role', isEqualTo: AppConstants.roleSubAdmin)
          .where('assignedAdmin', isEqualTo: adminId)
          .get();
      
      return subAdminsSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'सब-एडमिन फेच करना असफल: $e';
    }
  }
  
  // यूजर को इनेक्टिव/एक्टिव करें
  Future<void> toggleUserStatus(String uid, bool isActive) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({'isActive': isActive});
    } catch (e) {
      throw 'यूजर स्टेटस अपडेट करना असफल: $e';
    }
  }
} 