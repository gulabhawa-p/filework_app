// lib/utils/helpers.dart
// यह फाइल एप्लिकेशन में उपयोग होने वाले विभिन्न हेल्पर फंक्शन्स को प्रदान करती है

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'constants.dart';

class Helpers {
  // डेट को फॉर्मेट करने का फंक्शन
  static String formatDate(DateTime? date, {String format = 'dd-MM-yyyy'}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }
  
  // अमाउंट को फॉर्मेट करने का फंक्शन
  static String formatAmount(double amount, {String symbol = '₹'}) {
    return '$symbol ${amount.toStringAsFixed(2)}';
  }
  
  // अमाउंट को इंडियन फॉर्मेट में फॉर्मेट करने का फंक्शन (कॉमा सेपरेटेड)
  static String formatIndianRupee(double amount) {
    final indianRupeeFormat = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 2,
      symbol: '₹',
    );
    return indianRupeeFormat.format(amount);
  }
  
  // मंथ नंबर से मंथ नाम
  static String getMonthName(int month) {
    switch (month) {
      case 1: return 'जनवरी';
      case 2: return 'फरवरी';
      case 3: return 'मार्च';
      case 4: return 'अप्रैल';
      case 5: return 'मई';
      case 6: return 'जून';
      case 7: return 'जुलाई';
      case 8: return 'अगस्त';
      case 9: return 'सितंबर';
      case 10: return 'अक्टूबर';
      case 11: return 'नवंबर';
      case 12: return 'दिसंबर';
      default: return '';
    }
  }
  
  // टोस्ट मैसेज दिखाने का फंक्शन
  static void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: isError ? AppConstants.errorColor : AppConstants.successColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  
  // लोडिंग डायलॉग दिखाने का फंक्शन
  static void showLoadingDialog(BuildContext context, {String message = 'लोड हो रहा है...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16.0),
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // कन्फर्मेशन डायलॉग दिखाने का फंक्शन
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'हाँ',
    String cancelText = 'नहीं',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
  
  // कैपिटलाइ़ करने का फंक्शन (पहला अक्षर कैपिटल)
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  // फोन नंबर को फॉर्मेट करने का फंक्शन
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) return phoneNumber;
    return '${phoneNumber.substring(0, 5)}-${phoneNumber.substring(5)}';
  }
  
  // ग्रेडिएंट कलर बैकग्राउंड बनाने का फंक्शन
  static BoxDecoration gradientDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1976D2),
          Color(0xFF64B5F6),
        ],
      ),
    );
  }
  
  // शेडो के साथ कार्ड डेकोरेशन
  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  // रेन्डम आईडी जनरेट करने का फंक्शन
  static String generateId() {
    final now = DateTime.now();
    final random = now.microsecondsSinceEpoch.toString();
    return 'id_${now.millisecondsSinceEpoch}_$random';
  }
} 