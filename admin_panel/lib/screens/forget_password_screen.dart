import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../utilities/custom_text_field.dart';
import '../utilities/login_btn.dart';
import '../utilities/logo_widget.dart';
import '../utilities/welcome_msg.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    void sendResetPasswordLink() async {
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
      final email = emailController.text.trim();

      if (email.isEmpty) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter your email.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Navigator.pop(context);
        emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset link sent to $email!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to LoginScreen after a short delay to show SnackBar
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          default:
            errorMessage = 'Error: ${e.message ?? "Failed to send reset link."}';
        }
        emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        Navigator.pop(context);
        emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Color(0xFFFAF9F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Reset Password',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: 500,
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LogoWidget(),
                        SizedBox(height: 16),
                        WelcomeMsg(msg: 'Enter email to reset password',),
                        SizedBox(height: 24),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'E-mail',
                          isPassword: false,
                        ),
                        SizedBox(height: 16),
                        LoginBtn(
                          onPressed: sendResetPasswordLink,
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
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