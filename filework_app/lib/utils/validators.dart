// lib/utils/validators.dart
// यह फाइल फॉर्म फील्ड्स के लिए वेलिडेशन फंक्शन्स प्रदान करती है

class Validators {
  // यूजरनेम वेलिडेशन (अल्फान्यूमेरिक, 3-20 कैरेक्टर्स)
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'यूजरनेम अनिवार्य है';
    }
    if (value.length < 3) {
      return 'यूजरनेम कम से कम 3 अक्षर होना चाहिए';
    }
    if (value.length > 20) {
      return 'यूजरनेम 20 अक्षरों से अधिक नहीं होना चाहिए';
    }
    if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(value)) {
      return 'यूजरनेम में केवल अक्षर, संख्या, अंडरस्कोर और डॉट का उपयोग किया जा सकता है';
    }
    return null;
  }
  
  // ईमेल वेलिडेशन
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ईमेल अनिवार्य है';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'अमान्य ईमेल फॉर्मेट';
    }
    return null;
  }
  
  // पासवर्ड वेलिडेशन (कम से कम 6 अक्षर)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'पासवर्ड अनिवार्य है';
    }
    if (value.length < 6) {
      return 'पासवर्ड कम से कम 6 अक्षर होना चाहिए';
    }
    return null;
  }
  
  // नाम वेलिडेशन
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'नाम अनिवार्य है';
    }
    if (value.length < 2) {
      return 'नाम कम से कम 2 अक्षर होना चाहिए';
    }
    return null;
  }
  
  // फोन नंबर वेलिडेशन
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'फोन नंबर अनिवार्य है';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'फोन नंबर 10 अंकों का होना चाहिए';
    }
    return null;
  }
  
  // संख्या वेलिडेशन (पॉज़िटिव नंबर)
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'यह फील्ड अनिवार्य है';
    }
    
    final numberValue = int.tryParse(value);
    if (numberValue == null) {
      return 'मान्य संख्या दर्ज करें';
    }
    
    if (numberValue <= 0) {
      return 'संख्या 0 से अधिक होनी चाहिए';
    }
    
    return null;
  }
  
  // राशि वेलिडेशन
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'राशि अनिवार्य है';
    }
    
    final amountValue = double.tryParse(value);
    if (amountValue == null) {
      return 'मान्य राशि दर्ज करें';
    }
    
    if (amountValue <= 0) {
      return 'राशि 0 से अधिक होनी चाहिए';
    }
    
    return null;
  }
  
  // डेस्क्रिप्शन वेलिडेशन
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'विवरण अनिवार्य है';
    }
    if (value.length < 5) {
      return 'विवरण कम से कम 5 अक्षर होना चाहिए';
    }
    return null;
  }
  
  // रिक्वायर्ड फील्ड वेलिडेशन
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'यह फील्ड अनिवार्य है';
    }
    return null;
  }
} 