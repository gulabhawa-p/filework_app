// lib/screens/worker_dashboard.dart
// यह फाइल वर्कर डैशबोर्ड स्क्रीन को परिभाषित करती है

import 'package:flutter/material.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('वर्कर डैशबोर्ड'),
      ),
      body: const Center(
        child: Text('वर्कर डैशबोर्ड स्क्रीन - निर्माणाधीन'),
      ),
    );
  }
} 