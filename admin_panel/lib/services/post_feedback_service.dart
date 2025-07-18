import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_log_service.dart';

class PostFeedbackService {
  final AdminLogService _logService = AdminLogService();

  Future<void> approvePost(DocumentReference reference) async {
    try {
      await reference.update({'status': 'approved'});
      final action = 'approved post ${reference.id}';
      await _logService.logAction(action);
    } catch (e) {
      print('Error approving post: $e');
    }
  }

  Future<void> rejectPost(DocumentReference reference) async {
    try {
      await reference.update({'status': 'rejected'});
      final action = 'rejected post ${reference.id}';
      await _logService.logAction(action);
    } catch (e) {
      print('Error rejecting post: $e');
    }
  }

  Future<void> approveFeedback(DocumentReference reference) async {
    try {
      await reference.update({'status': 'approved'});
      final action = 'approved feedback ${reference.id}';
      await _logService.logAction(action);
    } catch (e) {
      print('Error approving feedback: $e');
    }
  }

  Future<void> rejectFeedback(DocumentReference reference) async {
    try {
      await reference.update({'status': 'rejected'});
      final action = 'rejected feedback ${reference.id}';
      await _logService.logAction(action);
    } catch (e) {
      print('Error rejecting feedback: $e');
    }
  }

  Future<void> approveAccountDeletion(String userId, DocumentReference notificationRef) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Update user's deletionRequestStatus and isAccountActive
      await firestore.collection('users').doc(userId).update({
        'accountStatus': 'InActive',
        'isAccountActive': false,
      });

      // Update notification status to rejected
      await notificationRef.update({
        'status': 'complete',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log the action
      final action = 'approved account deletion for user $userId';
      await _logService.logAction(action);
    } catch (e) {
      print('Error approving account deletion: $e');
      await notificationRef.update({
        'status': 'failed',
        'error': e.toString(),
      });
      throw e;
    }
  }

  Future<void> rejectAccountDeletion(String userId, DocumentReference notificationRef) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Update user's deletionRequestStatus and isAccountActive
      await firestore.collection('users').doc(userId).update({
        'accountStatus': 'Active',
        'isAccountActive': true,
      });

      // Update notification status to rejected
      await notificationRef.update({
        'status': 'complete',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log the action
      final action = 'rejected account deletion for user $userId';
      await _logService.logAction(action);
    } catch (e) {
      print('Error rejecting account deletion: $e');
      await notificationRef.update({
        'status': 'failed',
        'error': e.toString(),
      });
      throw e;
    }
  }

  Future<void> approveAccountReactivation(String userId, DocumentReference notificationRef) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Update user's deletionRequestStatus and isAccountActive
      await firestore.collection('users').doc(userId).update({
        'accountStatus': 'Active',
        'isAccountActive': true,
      });

      // Update notification status to rejected
      await notificationRef.update({
        'status': 'complete',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log the action
      final action = 'approved account deletion for user $userId';
      await _logService.logAction(action);
    } catch (e) {
      print('Error approving account deletion: $e');
      await notificationRef.update({
        'status': 'failed',
        'error': e.toString(),
      });
      throw e;
    }
  }

  Future<void> rejectAccountReactivation(String userId, DocumentReference notificationRef) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Update user's deletionRequestStatus and isAccountActive
      await firestore.collection('users').doc(userId).update({
        'accountStatus': 'InActive',
        'isAccountActive': false,
      });

      // Update notification status to rejected
      await notificationRef.update({
        'status': 'complete',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log the action
      final action = 'rejected account deletion for user $userId';
      await _logService.logAction(action);
    } catch (e) {
      print('Error rejecting account deletion: $e');
      await notificationRef.update({
        'status': 'failed',
        'error': e.toString(),
      });
      throw e;
    }
  }
}