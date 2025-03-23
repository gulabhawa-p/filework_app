// lib/providers/user_provider.dart
// यह फाइल यूजर डेटा को मैनेज करने के लिए प्रोवाइडर को परिभाषित करती है

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;
  
  // गेटर्स
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  
  // यूजर सेट करें और शेयर्ड प्रेफरेंसेज में सेव करें
  Future<void> setUser(UserModel user) async {
    _user = user;
    
    // शेयर्ड प्रेफरेंसेज में यूजर डेटा सेव करें
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(user.toJson());
    await prefs.setString('user_data', userData);
    
    _isLoading = false;
    notifyListeners();
  }
  
  // शेयर्ड प्रेफरेंसेज से यूजर डेटा लोड करें
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        final decodedData = json.decode(userData) as Map<String, dynamic>;
        _user = UserModel.fromJson(decodedData);
      }
    } catch (e) {
      // यूजर डेटा लोड करने में एरर होने पर यूजर को null सेट करें
      _user = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // यूजर को अपडेट करें
  Future<void> updateUser(UserModel user) async {
    await setUser(user);
  }
  
  // लॉगआउट करें
  Future<void> clearUser() async {
    _user = null;
    _isLoading = false;
    
    // शेयर्ड प्रेफरेंसेज से यूजर डेटा हटाएं
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    
    notifyListeners();
  }
  
  // यूजर रोल चेक करें
  bool isAdmin() {
    return _user?.role == 'admin';
  }
  
  bool isSubAdmin() {
    return _user?.role == 'sub_admin';
  }
  
  bool isWorker() {
    return _user?.role == 'worker';
  }
} 