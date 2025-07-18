import 'package:admin_panel/screens/home_screen.dart';
import 'package:admin_panel/utilities/colors.dart';
import 'package:admin_panel/utilities/forget_password_btn.dart';
import 'package:admin_panel/utilities/login_btn.dart';
import 'package:admin_panel/utilities/welcome_msg.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utilities/custom_text_field.dart';
import '../utilities/logo_widget.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  // Separate login function
  Future<void> _handleLogin(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
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
        await authProvider.login(emailController.text, passwordController.text);
        Navigator.pop(context); // Close the loading dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        Navigator.pop(context); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? e.toString())),
        );
      } finally {
        emailController.clear();
        passwordController.clear();
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Color(0xFF0B0B0C), Color(0xFFFAF9F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: 500,
                child: Card(
                  color: AppColors.color1,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LogoWidget(),
                            SizedBox(height: 16),
                            WelcomeMsg(msg: 'Sign in to your account',),
                            SizedBox(height: 24),
                            CustomTextField(
                              controller: emailController,
                              hintText: 'E-mail',
                              isPassword: false,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              isPassword: true,
                            ),
                            SizedBox(height: 16),
                            ForgetPasswordBtn(),
                            SizedBox(height: 16),
                            LoginBtn(
                              onPressed:
                                  () => _handleLogin(context, authProvider),
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
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
