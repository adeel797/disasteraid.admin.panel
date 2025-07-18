import 'package:admin_panel/services/post_feedback_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'colors.dart';

class AccountDeletionHandle extends StatelessWidget {
  final String userId;
  final String type;
  final String userName;
  final String userEmail;
  final String userReason;
  final String status;
  final Timestamp createdAt;
  final DocumentReference notificationRef;
  const AccountDeletionHandle({
    super.key,
    required this.userId,
    required this.type,
    required this.userName,
    required this.userEmail,
    required this.userReason,
    required this.status,
    required this.createdAt,
    required this.notificationRef,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.color2, AppColors.color1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.color1,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                surfaceTintColor: AppColors.color1,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: AppColors.color1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'By: $userName',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'E-mail: $userEmail',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Reason: $userReason',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Created: ${DateFormat('yyyy-MM-dd HH:mm').format(createdAt.toDate())}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Status: ${status ?? 'pending'}',
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              status == 'complete'
                                  ? Colors.green
                                  : status == 'pending'
                                  ? Colors.orange
                                  : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (status == 'pending') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:
                                        (context) => Center(
                                          child:
                                              LoadingAnimationWidget.staggeredDotsWave(
                                                color: AppColors.color1,
                                                size: 150,
                                              ),
                                        ),
                                  );
                                  type == 'account_deletion_request'
                                      ? await PostFeedbackService()
                                          .approveAccountDeletion(
                                            userId,
                                            notificationRef,
                                          )
                                      : await PostFeedbackService()
                                          .approveAccountReactivation(
                                            userId,
                                            notificationRef,
                                          );
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Account deletion request approved successfully',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error approving post: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Approve',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:
                                        (context) => Center(
                                          child:
                                              LoadingAnimationWidget.staggeredDotsWave(
                                                color: AppColors.color1,
                                                size: 150,
                                              ),
                                        ),
                                  );
                                  type == 'account_deletion_request'
                                      ? await PostFeedbackService()
                                      .rejectAccountDeletion(
                                    userId,
                                    notificationRef,
                                  )
                                      : await PostFeedbackService()
                                      .rejectAccountReactivation(
                                    userId,
                                    notificationRef,
                                  );
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Account deletion request rejected successfully',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error rejecting post: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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
