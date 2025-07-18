import 'package:admin_panel/screens/login_screen.dart';
import 'package:admin_panel/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../providers/homepage_provider.dart';

class Sidebar extends StatelessWidget {
  Sidebar({super.key});

  final List<String> _menuItems = [
    'Dashboard',
    'Posts Management',
    'Feedback Management',
    'Deletion Requests',
    'Reactivation Requests',
    'Reports',
    'Admins Log',
    'Settings',
    'Logout',
  ];

  final List<Widget> _menuIcons = [
    Icon(Icons.dashboard, color: AppColors.color2),
    Icon(Icons.post_add, color: AppColors.color2),
    Icon(Icons.feedback, color: AppColors.color2),
    Image.asset(
      'assets/images/account_deletion.png',
      width: 24,
      height: 24,
      color: AppColors.color2,
    ),
    Image.asset(
      'assets/images/account_reactive.png',
      width: 24,
      height: 24,
      color: AppColors.color2,
    ),
    Icon(Icons.report, color: AppColors.color2),
    Icon(Icons.history, color: AppColors.color2),
    Icon(Icons.settings, color: AppColors.color2),
    Icon(Icons.logout, color: AppColors.color2),
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAF9F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              color: Color(0xFF0B0B0C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Color(0xFF0B0B0C), fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF0B0B0C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Color(0xFFFAF9F6),
                          size: 150,
                        ),
                      ),
                );
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to log out: $e'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B0B0C), Color(0xFFFAF9F6)],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final isSelected =
                    index ==
                        Provider.of<HomePageProvider>(context).currentIndex &&
                    _menuItems[index] != 'Logout';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 16.0,
                  ),
                  child: Material(
                    color:
                        isSelected
                            ? const Color(0xFFFAF9F6)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    elevation: isSelected ? 4 : 0,
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.transparent
                                  : const Color(0xFFFAF9F6),
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: _menuIcons[index]),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _menuItems[index],
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? const Color(0xFF0B0B0C)
                                      : const Color(0xFFFAF9F6),
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          if (_menuItems[index] == 'Reports') ...[
                            StreamBuilder<QuerySnapshot>(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('reports')
                                      .where('status', isEqualTo: 'unread')
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }
                                if (snapshot.hasError) {
                                  debugPrint(
                                    'Error fetching unread count: ${snapshot.error}',
                                  );
                                  return const SizedBox.shrink();
                                }
                                final unreadCount =
                                    snapshot.data?.docs.length ?? 0;
                                if (unreadCount > 0) {
                                  return Container(
                                    width: 25,
                                    height:25,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.color2,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      unreadCount.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.color1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                          if (_menuItems[index] == 'Deletion Requests') ...[
                            StreamBuilder<QuerySnapshot>(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('notifications')
                                      .where('type', isEqualTo: 'account_deletion_request',)
                                      .where('status', isEqualTo: 'pending')
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }
                                if (snapshot.hasError) {
                                  debugPrint(
                                    'Error fetching unread count: ${snapshot.error}',
                                  );
                                  return const SizedBox.shrink();
                                }
                                final unreadCount =
                                    snapshot.data?.docs.length ?? 0;
                                if (unreadCount > 0) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.color2,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                          if (_menuItems[index] == 'Reactivation Requests') ...[
                            StreamBuilder<QuerySnapshot>(
                              stream:
                              FirebaseFirestore.instance
                                  .collection('notifications')
                                  .where('type', isEqualTo: 'account_reactivation_request',)
                                  .where('status', isEqualTo: 'pending')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }
                                if (snapshot.hasError) {
                                  debugPrint(
                                    'Error fetching unread count: ${snapshot.error}',
                                  );
                                  return const SizedBox.shrink();
                                }
                                final unreadCount =
                                    snapshot.data?.docs.length ?? 0;
                                if (unreadCount > 0) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.color2,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ],
                      ),
                      onTap: () {
                        if (_menuItems[index] == 'Logout') {
                          _showLogoutDialog(context);
                        } else {
                          Provider.of<HomePageProvider>(
                            context,
                            listen: false,
                          ).setPage(index);
                        }
                      },
                      hoverColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
