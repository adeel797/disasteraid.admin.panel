import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/card_model.dart';
import '../utilities/colors.dart';

class PostDetailScreen extends StatelessWidget {
  final CardModel post;
  final Future<void> Function() approve;
  final Future<void> Function() reject;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.approve,
    required this.reject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.color2, AppColors.color1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.color1, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                surfaceTintColor: AppColors.color1,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: AppColors.color1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'By: ${post.fullName}',
                        style: const TextStyle(
                          fontSize: 20,
                          color:AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Phone: ${post.phoneNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.color2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Created: ${DateFormat('yyyy-MM-dd HH:mm').format(post.createdAt.toDate())}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.color2,
                        ),
                      ),
                      if (post.description != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Description: ${post.description!.isEmpty ? 'N/A' : post.description}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.color2,
                          ),
                        ),
                      ],
                      if (post.imageUrls != null && post.imageUrls!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: post.imageUrls!.length,
                            itemBuilder: (context, index) {
                              // Convert Google Drive URL to direct download link
                              String imageUrl = post.imageUrls![index].replaceFirst(
                                RegExp(r'^https://drive\.google\.com/uc\?id='),
                                'https://drive.google.com/uc?export=download&id=',
                              );
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Image.network(
                                  imageUrl,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      width: 200,
                                      color: Colors.grey,
                                      child: const Center(child: Text('Image failed to load')),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 16),
                        Text(
                          'No images',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.color2,
                          ),
                        ),
                      ],
                      if (post.itemQuantity != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Quantity: ${post.itemQuantity}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.color2,
                          ),
                        ),
                      ],
                      if (post.location != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Location: ${post.location}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.color2,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        'Status: ${post.status ?? 'Pending'}',
                        style: TextStyle(
                          fontSize: 18,
                          color: post.status == 'approved'
                              ? Colors.green.shade600
                              : post.status == 'rejected'
                              ? Colors.red.shade600
                              : Colors.orange.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (post.status == 'pending') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:
                                        (context) => Center(
                                      child: LoadingAnimationWidget.staggeredDotsWave(
                                        color: AppColors.color1,
                                        size: 150,
                                      ),
                                    ),
                                  );
                                  await approve();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Post approved successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error approving post: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: const Text('Approve', style: TextStyle(fontSize: 18)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:
                                        (context) => Center(
                                      child: LoadingAnimationWidget.staggeredDotsWave(
                                        color: AppColors.color1,
                                        size: 150,
                                      ),
                                    ),
                                  );
                                  await reject();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Post rejected successfully'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error rejecting post: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: const Text('Reject', style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ]
                    ],
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