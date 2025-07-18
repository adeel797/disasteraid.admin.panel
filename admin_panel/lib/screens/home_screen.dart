import 'package:admin_panel/screens/account_activations_requests_screen.dart';
import 'package:admin_panel/screens/account_deletion_requests_screen.dart';
import 'package:admin_panel/screens/admin_logs_screen.dart';
import 'package:admin_panel/screens/feedbacks_management_screen.dart';
import 'package:admin_panel/screens/notifications_screen.dart';
import 'package:admin_panel/screens/posts_management_screen.dart';
import 'package:admin_panel/screens/reports_screen.dart';
import 'package:admin_panel/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/homepage_provider.dart';
import '../utilities/sidebar.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildPage(int index) {
    final pages = [
      const DashboardScreen(),
      PostsManagementScreen(),
      FeedbacksManagementScreen(),
      const AccountDeletionRequestsScreen(),
      const AccountActivationsRequestsScreen(),
      const ReportsScreen(),
      const AdminLogScreen(),
      const SettingsScreen(),
    ];
    return pages[index];
  }

  @override
  Widget build(BuildContext context) {
    final homepageProvider = Provider.of<HomePageProvider>(context);
    return Scaffold(
      body: Row(
        children: [
          // Sidebar with fixed width for consistency
          SizedBox(
            width: 350, // Fixed sidebar width
            child: Sidebar(),
          ),
          // Main content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B0B0C), Color(0xFFFAF9F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Subtle padding
                child: _buildPage(homepageProvider.currentIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
