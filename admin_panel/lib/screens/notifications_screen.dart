import 'package:admin_panel/utilities/account_deletion_handle.dart';
import 'package:admin_panel/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('createdAt', descending: true) // Changed from 'timestamp' to 'createdAt'
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.color1,
                size: 100,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: AppColors.color1,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No notifications available',
                style: TextStyle(
                  color: AppColors.color1,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data!.docs[index];
              final userName = notification['userName'] ?? 'Unknown';
              final userEmail = notification['userEmail'] ?? 'No Email';
              final type = notification['type'] ?? 'Unknown';
              final userId = notification['userId'] ?? '';
              final reason = notification['reason'] ?? 'No reason provided';
              final status = notification['status'] ?? 'pending';
              final dateTime = notification['createdAt'] ?? '';

              return InkWell(
                onTap:() => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountDeletionHandle(
                      userId: userId,
                      type: type,
                      userName: userName,
                      userEmail: userEmail,
                      userReason: reason,
                      status: status,
                      createdAt: dateTime,
                      notificationRef: notification.reference,
                    ),
                  ),
                ), // Disable tap if status is not pending
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.toString().toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.color2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'User ID: $userId',
                          style: const TextStyle(color: AppColors.color2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}