import 'package:admin_panel/screens/forget_password_screen.dart';
import 'package:flutter/material.dart';

class ForgetPasswordBtn extends StatelessWidget {
  const ForgetPasswordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgetPasswordScreen())),
        child: Text(
          'Forget password?',
          style: TextStyle(color:  Color(0xFF0B0B0C)),
        ),
      ),
    );
  }
}