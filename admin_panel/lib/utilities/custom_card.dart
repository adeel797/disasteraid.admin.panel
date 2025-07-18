import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String fullNameText;
  final String userNameText;
  final String emailText;
  final bool isEmailVerified;
  final VoidCallback press;

  const CustomCard({
    super.key,
    required this.fullNameText,
    required this.userNameText,
    required this.emailText,
    required this.isEmailVerified,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive font and icon sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSizeBase = screenWidth < 500 ? 12.0 : 14.0;
    final titleFontSize = screenWidth < 500 ? 14.0 : 16.0;
    final iconSize = screenWidth < 500 ? 20.0 : 24.0;

    return Card(
      color: const Color(0xFFFAF9F6),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Reduced padding for better space usage
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevent Column from taking extra space
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Flexible(
                      child: Text(
                        "Name: $fullNameText",
                        style: TextStyle(
                          color: const Color(0xFF0B0B0C),
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(
                    isEmailVerified ? Icons.check_circle : Icons.cancel,
                    color: isEmailVerified ? Colors.green : Colors.red,
                    size: iconSize,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  "Username: $userNameText",
                  style: TextStyle(
                    color: const Color(0xFF0B0B0C),
                    fontSize: fontSizeBase,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  "Email: $emailText",
                  style: TextStyle(
                    color: const Color(0xFF0B0B0C),
                    fontSize: fontSizeBase - 2, // Slightly smaller for email
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}