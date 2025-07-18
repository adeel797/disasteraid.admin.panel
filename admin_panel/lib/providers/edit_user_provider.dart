import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/services/admin_log_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditUserProvider extends ChangeNotifier {
  final TextEditingController emailController;
  final TextEditingController userNameController;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  String? accountType;
  bool isLoading = false;
  final AdminLogService _logService = AdminLogService();

  EditUserProvider({
    required QueryDocumentSnapshot userData,
  })  : emailController = TextEditingController(text: userData['email']),
        userNameController = TextEditingController(text: userData['userName']),
        fullNameController = TextEditingController(text: userData['fullName']),
        phoneController = TextEditingController(text: userData['phone']),
        dobController = TextEditingController(text: userData['dob']),
        accountType = userData['accountType'];

  Future<void> updateUser(BuildContext context, String uid, String fullName) async {
    // Show loading dialog
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
      isLoading = true;
      notifyListeners();

      // Update user in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'email': emailController.text,
        'userName': userNameController.text,
        'fullName': fullNameController.text,
        'phone': phoneController.text,
        'dob': dobController.text,
        'accountType': accountType,
      });

      // Log the action with fullName
      await _logService.logAction('edited user: $fullName');

      // Close loading dialog
      Navigator.of(context).pop();

      // Navigate back
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('User updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateAccountType(String? value) {
    accountType = value;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }
}