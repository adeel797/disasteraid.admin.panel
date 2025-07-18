import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'colors.dart';

class ReportDetailScreen extends StatelessWidget {
  final String reason;
  final String reportedUserName;
  final String reportedUserId;
  final String reportedUserEmail;
  final String reportedUserAccountType;
  final Timestamp timestamp;
  const ReportDetailScreen({
    super.key,
    required this.reason,
    required this.reportedUserName,
    required this.reportedUserId,
    required this.reportedUserEmail,
    required this.reportedUserAccountType,
    required this.timestamp,
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
                        reason.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Reported user id: $reportedUserId',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Reported user name: $reportedUserName',
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Reported user e-mail: $reportedUserEmail',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Reported user account type: $reportedUserAccountType',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Created: ${DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.color2,
                        ),
                      ),
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
