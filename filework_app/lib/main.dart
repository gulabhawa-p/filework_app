import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/sub_admin_dashboard.dart';
import 'screens/worker_dashboard.dart';
import 'providers/user_provider.dart';
import 'utils/theme_utils.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // फायरबेस इनिशियलाइज करें
  await Firebase.initializeApp();
  
  // शेयर्ड प्रेफरेंसेज से थीम प्रेफरेंस लोड करें
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool(AppConstants.themeModePref) ?? false;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // यहां अन्य प्रोवाइडर्स जोड़ें जब आवश्यक हो
      ],
      child: FileWorkApp(isDarkMode: isDarkMode),
    ),
  );
}

class FileWorkApp extends StatefulWidget {
  final bool isDarkMode;
  
  const FileWorkApp({super.key, required this.isDarkMode});

  @override
  State<FileWorkApp> createState() => _FileWorkAppState();
}

class _FileWorkAppState extends State<FileWorkApp> {
  bool _isDarkMode = false;
  
  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    
    // यूजर प्रोवाइडर से यूजर डेटा लोड करें
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUser();
    });
  }
  
  // थीम मोड स्विच करने का फंक्शन
  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    
    // शेयर्ड प्रेफरेंसेज में थीम प्रेफरेंस सेव करें
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.themeModePref, _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeUtils.getLightTheme(),
      darkTheme: ThemeUtils.getDarkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // इनिशियल रूट
      initialRoute: '/',
      
      // ऐप के रूट्स डिफाइन करें
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
        '/sub_admin_dashboard': (context) => const SubAdminDashboardScreen(),
        '/worker_dashboard': (context) => const WorkerDashboardScreen(),
      },
    );
  }
}
