// lib/services/product_service.dart
// यह फाइल प्रोडक्ट्स (फाइल प्रकारों) के मैनेजमेंट के लिए फंक्शन्स प्रदान करती है

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../utils/constants.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final uuid = const Uuid();
  
  // सभी प्रोडक्ट्स फेच करना
  Future<List<ProductModel>> fetchAllProducts({bool activeOnly = true}) async {
    try {
      Query query = _firestore.collection(AppConstants.productsCollection);
      
      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }
      
      final productsSnapshot = await query.get();
      
      return productsSnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'प्रोडक्ट्स फेच करना असफल: $e';
    }
  }
  
  // एक प्रोडक्ट फेच करना ID से
  Future<ProductModel?> fetchProductById(String id) async {
    try {
      final productDoc = await _firestore
          .collection(AppConstants.productsCollection)
          .doc(id)
          .get();
      
      if (!productDoc.exists || productDoc.data() == null) {
        return null;
      }
      
      return ProductModel.fromJson(productDoc.data()!);
    } catch (e) {
      throw 'प्रोडक्ट फेच करना असफल: $e';
    }
  }
  
  // नया प्रोडक्ट क्रिएट करना
  Future<ProductModel> createProduct({
    required String name,
    required String description,
    required double rate,
    required String createdBy,
    File? imageFile,
  }) async {
    try {
      // प्रोडक्ट ID जनरेट करें
      final id = uuid.v4();
      
      String imageUrl = '';
      
      // इमेज फाइल अपलोड करें, अगर है तो
      if (imageFile != null) {
        final ref = _storage
            .ref()
            .child(AppConstants.productImagesStorage)
            .child('$id.jpg');
        
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }
      
      // नया प्रोडक्ट मॉडल बनाएं
      final newProduct = ProductModel(
        id: id,
        name: name,
        description: description,
        rate: rate,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        imageUrl: imageUrl,
        isActive: true,
      );
      
      // फायरस्टोर में प्रोडक्ट सेव करें
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(id)
          .set(newProduct.toJson());
      
      return newProduct;
    } catch (e) {
      throw 'प्रोडक्ट क्रिएट करना असफल: $e';
    }
  }
  
  // प्रोडक्ट अपडेट करना
  Future<ProductModel> updateProduct({
    required String id,
    String? name,
    String? description,
    double? rate,
    File? imageFile,
    bool? isActive,
  }) async {
    try {
      // वर्तमान प्रोडक्ट फेच करें
      final productDoc = await _firestore
          .collection(AppConstants.productsCollection)
          .doc(id)
          .get();
      
      if (!productDoc.exists || productDoc.data() == null) {
        throw 'प्रोडक्ट नहीं मिला।';
      }
      
      final currentProduct = ProductModel.fromJson(productDoc.data()!);
      
      // अपडेट के लिए डेटा प्रिपेयर करें
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (rate != null) data['rate'] = rate;
      if (isActive != null) data['isActive'] = isActive;
      
      String imageUrl = currentProduct.imageUrl;
      
      // इमेज फाइल अपलोड करें, अगर है तो
      if (imageFile != null) {
        final ref = _storage
            .ref()
            .child(AppConstants.productImagesStorage)
            .child('$id.jpg');
        
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
        data['imageUrl'] = imageUrl;
      }
      
      // फायरस्टोर में प्रोडक्ट अपडेट करें
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(id)
          .update(data);
      
      // अपडेटेड प्रोडक्ट रिटर्न करें
      return currentProduct.copyWith(
        name: name,
        description: description,
        rate: rate,
        imageUrl: imageFile != null ? imageUrl : null,
        isActive: isActive,
      );
    } catch (e) {
      throw 'प्रोडक्ट अपडेट करना असफल: $e';
    }
  }
  
  // प्रोडक्ट को एक्टिव/इनएक्टिव करना
  Future<void> toggleProductStatus(String id, bool isActive) async {
    try {
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(id)
          .update({'isActive': isActive});
    } catch (e) {
      throw 'प्रोडक्ट स्टेटस अपडेट करना असफल: $e';
    }
  }
  
  // प्रोडक्ट डिलीट करना
  Future<void> deleteProduct(String id) async {
    try {
      // फायरस्टोर से प्रोडक्ट डिलीट करें
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(id)
          .delete();
      
      // स्टोरेज से इमेज डिलीट करें
      try {
        await _storage
            .ref()
            .child(AppConstants.productImagesStorage)
            .child('$id.jpg')
            .delete();
      } catch (e) {
        // इमेज न मिलने पर एरर को इग्नोर करें
      }
    } catch (e) {
      throw 'प्रोडक्ट डिलीट करना असफल: $e';
    }
  }
} 