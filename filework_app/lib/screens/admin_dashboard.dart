// lib/screens/admin_dashboard.dart
// यह फाइल एडमिन डैशबोर्ड स्क्रीन को परिभाषित करती है

import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('एडमिन डैशबोर्ड'),
      ),
      body: const Center(
        child: Text('एडमिन डैशबोर्ड स्क्रीन - निर्माणाधीन'),
      ),
    );
  }
} 