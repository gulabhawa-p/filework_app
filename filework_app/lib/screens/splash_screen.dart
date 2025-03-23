// lib/screens/splash_screen.dart
// यह फाइल स्प्लैश स्क्रीन को परिभाषित करती है, जो ऐप लोड होने पर दिखाई देती है

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // यूजर प्रोवाइडर के आधार पर अगली स्क्रीन पर जाएं
  Future<void> _navigateToNextScreen() async {
    // कम से कम 2.5 सेकंड का स्प्लैश दिखाएं
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    
    // यूजर प्रोवाइडर का चेक करें
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // अगर यूजर लोड हो रहा है, तो उसका इंतजार करें
    if (userProvider.isLoading) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return userProvider.isLoading;
      });
    }
    
    if (!mounted) return;
    
    // यूजर के लॉगिन स्टेटस के अनुसार नेविगेट करें
    if (userProvider.isLoggedIn) {
      // यूजर के रोल के अनुसार डैशबोर्ड पर जाएं
      final userRole = userProvider.user!.role;
      
      switch (userRole) {
        case AppConstants.roleAdmin:
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
          break;
        case AppConstants.roleSubAdmin:
          Navigator.pushReplacementNamed(context, '/sub_admin_dashboard');
          break;
        case AppConstants.roleWorker:
          Navigator.pushReplacementNamed(context, '/worker_dashboard');
          break;
        default:
          // अगर कोई रोल नहीं मिलता है, तो लॉगिन पेज पर रीडायरेक्ट करें
          Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // अगर यूजर लॉगिन नहीं है, तो लॉगिन पेज पर जाएं
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // थीम डेटा प्राप्त करें (लाइट या डार्क मोड)
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                  ]
                : [
                    const Color(0xFFE3F2FD), 
                    const Color(0xFFBBDEFB),
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ऐप आइकन और नाम
              Icon(
                Icons.article_rounded,
                size: 100,
                color: theme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : AppConstants.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'फाइल निर्माता के लिए ऐप',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 50),
              // लोडिंग इंडिकेटर
              CircularProgressIndicator(
                color: isDarkMode ? Colors.white : theme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'लोड हो रहा है...',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 