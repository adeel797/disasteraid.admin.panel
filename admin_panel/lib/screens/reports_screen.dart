import 'package:admin_panel/utilities/report_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utilities/colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Future<Map<String, dynamic>?> getUserData(String reporterId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(reporterId)
              .get();

      if (userDoc.exists) {
        return {
          'fullName': userDoc.data()?['fullName'] ?? 'Unknown',
          'accountType': userDoc.data()?['accountType'] ?? 'Unknown',
        };
      } else {
        print('User with reporterId $reporterId not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('reports')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.color1,
                size: 100,
              ),
            );
          }

          if (snapshot.hasError) {
            debugPrint('Snapshot Error: ${snapshot.error}');
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
                'No reports available',
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
              final reports = snapshot.data!.docs[index];
              final reason = reports['reason'] ?? 'Unknown';
              final reportedUserName = reports['reportedUserName'] ?? 'Unknown';
              final reportedUserId = reports['reportedUserId'] ?? 'Unknown';
              final reportedUserEmail =
                  reports['reportedUserEmail'] ?? 'Unknown';
              final reportedUserAccountType =
                  reports['reportedUserAccountType'] ?? 'Unknown';
              final timestamp = reports['timestamp'];
              final status = reports['status'];

              return GestureDetector(
                onTap: () async {
                  try {
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
                    await FirebaseFirestore.instance
                        .collection('reports')
                        .doc(reports.id)
                        .update({'status': 'read'});
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ReportDetailScreen(
                              reason: reason,
                              reportedUserName: reportedUserName,
                              reportedUserId: reportedUserId,
                              reportedUserEmail: reportedUserEmail,
                              reportedUserAccountType: reportedUserAccountType,
                              timestamp: timestamp,
                            ),
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error updating status: $e');
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Report reason: ${reason.toString().toUpperCase()}',
                          style: const TextStyle(
                            color: AppColors.color2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (status == 'unread') ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Container(
                              width: 10,
                              height: 10,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.color2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
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
