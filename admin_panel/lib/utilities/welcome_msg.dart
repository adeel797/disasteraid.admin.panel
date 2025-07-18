import 'package:flutter/material.dart';

class WelcomeMsg extends StatelessWidget {
  final String msg;
  const WelcomeMsg({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hello!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color:  Color(0xFF0B0B0C),
          ),
        ),
        SizedBox(height: 8),
        Text(
          msg,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}