import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/post_feedback_provider.dart';
import '../services/post_feedback_service.dart';
import '../utilities/custom_card_post_feedback.dart';

class PostsManagementScreen extends StatelessWidget {
  final PostFeedbackService _service = PostFeedbackService();

  PostsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedbackProvider = Provider.of<PostFeedbackProvider>(context);
    // Get screen width for responsive crossAxisCount
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F6),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: DropdownButton<String>(
                value: feedbackProvider.selectedStatus,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0B0B0C)),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Color(0xFF0B0B0C), fontSize: 16, fontWeight: FontWeight.w500),
                underline: const SizedBox(),
                dropdownColor: const Color(0xFFFAF9F6),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    feedbackProvider.setSelectedStatus(newValue);
                  }
                },
                items: <String>['pending', 'approved', 'rejected'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      child: Text(
                        value[0].toUpperCase() + value.substring(1),
                        style: const TextStyle(
                          color: Color(0xFF0B0B0C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _buildPostList(context, feedbackProvider.selectedStatus, screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(BuildContext context, String status, double screenWidth) {
    // Calculate crossAxisCount based on screen width
    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4; // Large screens (e.g., desktop)
    } else if (screenWidth >= 800) {
      crossAxisCount = 3; // Medium screens (e.g., tablet)
    } else if (screenWidth >= 500) {
      crossAxisCount = 2; // Small screens (e.g., phone landscape)
    } else {
      crossAxisCount = 1; // Very small screens (e.g., phone portrait)
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('posts')
            .where('status', isEqualTo: status)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: const Color(0xFFFAF9F6),
                size: 100,
              ),
            );
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  'No $status posts',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0B0B0C),
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
              childAspectRatio: screenWidth < 500 ? 2.0 : 1.75, // Adjust aspect ratio for smaller screens
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final card = CardModel.fromJson(doc.data() as Map<String, dynamic>);
              return CustomCardPostFeedback(
                post: card,
                approve: () async {
                  await _service.approvePost(doc.reference);
                },
                reject: () async {
                  await _service.rejectPost(doc.reference);
                },
              );
            },
          );
        },
      ),
    );
  }
}