// lib/screens/sub_admin_dashboard.dart
// यह फाइल सब-एडमिन डैशबोर्ड स्क्रीन को परिभाषित करती है

import 'package:flutter/material.dart';

class SubAdminDashboardScreen extends StatefulWidget {
  const SubAdminDashboardScreen({super.key});

  @override
  State<SubAdminDashboardScreen> createState() => _SubAdminDashboardScreenState();
}

class _SubAdminDashboardScreenState extends State<SubAdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सब-एडमिन डैशबोर्ड'),
      ),
      body: const Center(
        child: Text('सब-एडमिन डैशबोर्ड स्क्रीन - निर्माणाधीन'),
      ),
    );
  }
} 