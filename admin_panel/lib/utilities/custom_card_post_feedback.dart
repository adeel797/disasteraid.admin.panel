import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/card_model.dart';
import '../screens/post_detail_screen.dart';

class CustomCardPostFeedback extends StatelessWidget {
  final CardModel post;
  final Future<void> Function() approve;
  final Future<void> Function() reject;

  const CustomCardPostFeedback({
    super.key,
    required this.post,
    required this.approve,
    required this.reject,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive font scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSizeBase = screenWidth < 500 ? 12.0 : 14.0; // Smaller fonts for smaller screens
    final titleFontSize = screenWidth < 500 ? 14.0 : 18.0;

    return Card(
      color: const Color(0xFFFAF9F6),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              post: post,
              approve: approve,
              reject: reject,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevent Column from taking unnecessary space
            children: [
              Flexible(
                child: Text(
                  post.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0B0B0C),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  'By: ${post.fullName}',
                  style: TextStyle(
                    fontSize: fontSizeBase,
                    color: const Color(0xFF0B0B0C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  'Account: ${post.accountType?.toUpperCase() ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: fontSizeBase,
                    color: const Color(0xFF0B0B0C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  'Created at: ${DateFormat('yyyy-MM-dd HH:mm').format(post.createdAt.toDate())}',
                  style: TextStyle(
                    fontSize: fontSizeBase,
                    color: const Color(0xFF0B0B0C),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  'Status: ${post.status ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: fontSizeBase,
                    color: post.status == 'approved'
                        ? Colors.green
                        : post.status == 'rejected'
                        ? Colors.red
                        : Colors.orange,
                  ),
                  maxLines: 1,
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