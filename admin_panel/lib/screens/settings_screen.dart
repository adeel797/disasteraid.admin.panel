import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utilities/admin_log_pdf.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _changePassword(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final newPassword = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAF9F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Color(0xFF0B0B0C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New Password',
            labelStyle: TextStyle(color: Color(0xFF0B0B0C)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0B0B0C)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0B0B0C), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          style: const TextStyle(color: Color(0xFF0B0B0C)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF0B0B0C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text(
              'Change',
              style: TextStyle(
                color: Color(0xFF0B0B0C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
    if (newPassword != null && newPassword.isNotEmpty) {
      try {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password updated successfully',
              style: TextStyle(color: Color(0xFFFAF9F6)),
            ),
            backgroundColor: Color(0xFF0B0B0C),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating password: $e',
              style: const TextStyle(color: Color(0xFFFAF9F6)),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleSettingTap(BuildContext context, String setting) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$setting tapped - Implement functionality here',
          style: const TextStyle(color: Color(0xFFFAF9F6)),
        ),
        backgroundColor: const Color(0xFF0B0B0C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate crossAxisCount based on screen width
    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4; // Large screens (e.g., desktop)
    } else if (screenWidth >= 800) {
      crossAxisCount = 3; // Medium screens (e.g., tablet)
    } else if (screenWidth >= 500) {
      crossAxisCount = 2; // Small screens (e.g., phone landscape)
    } else {
      crossAxisCount = 1; // Very small screens (e.g., phone portrait)
    }

    // Adjust font and icon sizes based on screen width
    final fontSize = screenWidth < 500 ? 12.0 : 14.0;
    final iconSize = screenWidth < 500 ? 30.0 : 40.0;

    final List<Map<String, dynamic>> settings = [
      {'name': 'Change Password', 'icon': Icons.lock, 'action': () => _changePassword(context)},
      // {'name': 'Update Admin Profile', 'icon': Icons.person, 'action': () => _handleSettingTap(context, 'Update Admin Profile')},
      // {'name': 'Manage Notification', 'icon': Icons.notifications, 'action': () => _handleSettingTap(context, 'Manage Notification Preferences')},
      // {'name': 'Configure User', 'icon': Icons.security, 'action': () => _handleSettingTap(context, 'Configure User Permissions')},
      // {'name': 'System Theme Settings', 'icon': Icons.color_lens, 'action': () => _handleSettingTap(context, 'System Theme Settings')},
      // {'name': 'Backup Database', 'icon': Icons.backup, 'action': () => _handleSettingTap(context, 'Backup Database')},
      // {'name': 'View Audit Logs', 'icon': Icons.history, 'action': () => _handleSettingTap(context, 'View Audit Logs')},
      // {'name': 'Manage Account Security', 'icon': Icons.lock_outline, 'action': () => _handleSettingTap(context, 'Manage Account Security')},
       {'name': 'Download Logs', 'icon': Icons.download, 'action': () => downloadAdminLogs(context)},
    ];

    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: screenWidth < 500 ? 2.5 : 2.0, // Adjust aspect ratio for smaller screens
        ),
        itemCount: settings.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFFFAF9F6),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: settings[index]['action'],
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Prevent Column from taking extra space
                children: [
                  Icon(
                    settings[index]['icon'],
                    color: const Color(0xFF0B0B0C),
                    size: iconSize,
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      settings[index]['name'],
                      style: TextStyle(
                        color: const Color(0xFF0B0B0C),
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}