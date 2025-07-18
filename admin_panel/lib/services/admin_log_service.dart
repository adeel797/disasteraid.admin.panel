import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminLogService {
  final List<String> adminEmails = [
    'adeelahmed0001786@gmail.com',
    'adeel213133@gmail.com',
    'hassanjaved2009@gmail.com',
  ];

  Future<void> logAction(String action) async {
    final adminUid = FirebaseAuth.instance.currentUser?.uid;
    if (adminUid != null) {
      try {
        final adminDoc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(adminUid)
            .get();

        if (adminDoc.exists) {
          final adminData = adminDoc.data()!;
          final adminName = adminData['name'] ?? 'Unknown';
          final adminEmail = adminData['email'] ?? 'Unknown';
          final now = Timestamp.now();

          // Log the action in Firestore
          await FirebaseFirestore.instance.collection('admin_logs').add({
            'admin_id': adminUid,
            'admin_name': adminName,
            'admin_email': adminEmail,
            'admin_action_performed': action,
            'action_performed_date_time': now,
          });

          // Add a notification
          // await FirebaseFirestore.instance.collection('notifications').add({
          //   'message': '$adminEmail $action',
          //   'timestamp': now,
          // });

          // Placeholder for email notification
          print('Sending email to $adminEmails about action: $action');
        } else {
          print('Admin document does not exist for UID: $adminUid');
        }
      } catch (e) {
        print('Error logging action: $e');
      }
    } else {
      print('No admin user is currently signed in.');
    }
  }
}