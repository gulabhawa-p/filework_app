// lib/screens/login_screen.dart
// यह फाइल लॉगिन स्क्रीन को परिभाषित करती है, जिसमें यूजर्स अपने यूजरनेम और पासवर्ड से लॉगिन कर सकते हैं

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/utils.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // कंट्रोलर्स और स्टेट वेरिएबल्स
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // स्क्रीन की हाईट और विड्थ गेट करें
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  
  // ऑथ सर्विस का इंस्टेंस
  late final AuthService _authService;
  
  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // लॉगिन फंक्शन
  Future<void> _login() async {
    // फॉर्म वेलिडेशन
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // इनपुट से यूजरनेम और पासवर्ड प्राप्त करें
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // ऑथ सर्विस से लॉगिन फंक्शन कॉल करें
      final userModel = await _authService.loginWithUsernamePassword(
        username,
        password,
      );
      
      if (!mounted) return;
      
      // यूजर प्रोवाइडर में यूजर डेटा सेट करें
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userModel);
      
      // रोल के अनुसार डैशबोर्ड पर रीडायरेक्ट करें
      _navigateToRoleBasedScreen(userModel.role);
      
      // सक्सेस मैसेज दिखाएं
      Helpers.showToast(
        '${AppConstants.loginSuccess} ${Helpers.capitalize(userModel.role)} के रूप में',
        isError: false,
      );
    } catch (e) {
      // एरर मैसेज दिखाएं
      Helpers.showToast(
        e.toString(),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // रोल के अनुसार स्क्रीन पर नेविगेट करें
  void _navigateToRoleBasedScreen(String role) {
    switch (role) {
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
        // अगर कोई रोल मैच नहीं होता, तो डिफॉल्ट स्क्रीन पर जाएं
        Navigator.pushReplacementNamed(context, '/worker_dashboard');
    }
  }
  
  // पासवर्ड भूल गए हैंडलर
  void _forgotPassword() {
    Helpers.showToast('पासवर्ड रीसेट के लिए अपने एडमिन से संपर्क करें', isError: false);
  }

  @override
  Widget build(BuildContext context) {
    // थीम डेटा प्राप्त करें (लाइट या डार्क मोड)
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDarkMode 
            ? SystemUiOverlayStyle.light 
            : SystemUiOverlayStyle.dark,
        child: Container(
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
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // लोगो और एप्प नाम
                        Column(
                          children: [
                            // लोगो आइकन
                            Icon(
                              Icons.article_rounded,
                              size: 80,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(height: 16),
                            // एप्प नाम
                            Text(
                              AppConstants.appName,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : AppConstants.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // टैगलाइन
                            Text(
                              'फाइल निर्माता के लिए ऐप',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // यूजरनेम फील्ड
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'यूजरनेम',
                            hintText: 'अपना यूजरनेम दर्ज करें',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: isDarkMode 
                                ? Colors.grey[800] 
                                : Colors.white,
                          ),
                          validator: Validators.validateUsername,
                          textInputAction: TextInputAction.next,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // पासवर्ड फील्ड
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'पासवर्ड',
                            hintText: 'अपना पासवर्ड दर्ज करें',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: isDarkMode 
                                ? Colors.grey[800] 
                                : Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword 
                                    ? Icons.visibility_off 
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: Validators.validatePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // पासवर्ड भूल गए लिंक
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _forgotPassword,
                            child: Text(
                              'पासवर्ड भूल गए?',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // लॉगिन बटन
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'लॉग इन करें',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 50),
                        
                        // कॉपीराइट टेक्स्ट
                        Center(
                          child: Text(
                            '© ${DateTime.now().year} ${AppConstants.appName}',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white60 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 