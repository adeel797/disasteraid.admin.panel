import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utilities/custom_card.dart';
import 'edit_user_screen.dart';

class UserListScreen extends StatelessWidget {
  final String accountType;
  const UserListScreen({super.key, required this.accountType});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate crossAxisCount based on screen width
    int crossAxisCount;
    if (screenWidth >= 1400) {
      crossAxisCount = 5; // Large screens (e.g., desktop)
    } else if (screenWidth >= 1000) {
      crossAxisCount = 4; // Medium-large screens
    } else if (screenWidth >= 800) {
      crossAxisCount = 3; // Medium screens (e.g., tablet)
    } else if (screenWidth >= 500) {
      crossAxisCount = 2; // Small screens (e.g., phone landscape)
    } else {
      crossAxisCount = 1; // Very small screens (e.g., phone portrait)
    }

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows gradient to extend behind AppBar
      appBar: AppBar(
        title: Text(
          getTitle(accountType),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white, // White for visibility against dark gradient
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0, // No shadow for a clean look
        iconTheme: const IconThemeData(color: Colors.white), // Ensure icons are visible
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0B0C), Color(0xFFFAF9F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0), // Reduced top padding
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('accountType', isEqualTo: accountType)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: const Color(0xFFFAF9F6),
                      size: screenWidth < 500 ? 100 : 150, // Scale loading animation
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading data',
                      style: TextStyle(
                        fontSize: screenWidth < 500 ? 14 : 16,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'No User Found.',
                        style: TextStyle(
                          fontSize: screenWidth < 500 ? 14 : 16,
                          color: const Color(0xFF0B0B0C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: screenWidth < 500 ? 2.5 : 2.0, // More height for smaller screens
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data!.docs[index];
                    return CustomCard(
                      fullNameText: user['fullName'] ?? user['email'],
                      userNameText: user['userName'],
                      emailText: user['email'],
                      isEmailVerified: user['emailVerified'],
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserScreen(userData: user),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(String accountType) {
    switch (accountType) {
      case 'affectee':
        return 'Affecties List';
      case 'donor':
        return 'Donors List';
      case 'volunteer':
        return 'Volunteers List';
      case 'ngo':
        return 'NGOs List';
      default:
        return 'User List';
    }
  }
}