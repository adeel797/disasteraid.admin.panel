
import 'package:cloud_firestore/cloud_firestore.dart';

enum FeedbackType { specific, general }

class CardModel {
  final String type; // 'post' or 'feedback'
  final String title;
  final String fullName;
  final String phoneNumber; // Contact
  final Timestamp createdAt;
  final String? description;
  final List<String>? imageUrls;
  final String? accountType; // New field
  final String? status; // Added status field

  // Feedback-specific fields
  final String? recipientName;
  final int? rating;
  final FeedbackType? feedbackType;

  // Post-specific fields
  final String? itemQuantity;
  final String? location;

  CardModel({
    required this.type,
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.createdAt,
    this.description,
    this.imageUrls,
    this.accountType,
    this.recipientName,
    this.rating,
    this.feedbackType,
    this.itemQuantity,
    this.location,
    this.status,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      type: json['type'] as String,
      title: json['title'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      createdAt: json['createdAt'] as Timestamp,
      description: json['description'] as String?,
      imageUrls: json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : null,
      accountType: json['accountType'] as String?,
      recipientName: json['recipientName'] as String?,
      rating: json['rating'] as int?,
      feedbackType: json['feedbackType'] != null
          ? FeedbackType.values.firstWhere(
            (e) => e.toString() == 'FeedbackType.${json['feedbackType']}',
        orElse: () => FeedbackType.general,
      )
          : null,
      itemQuantity: json['itemQuantity'] as String?,
      location: json['location'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'description': description,
      'imageUrls': imageUrls,
      'accountType': accountType,
      'recipientName': recipientName,
      'rating': rating,
      'feedbackType': feedbackType?.toString().split('.').last,
      'itemQuantity': itemQuantity,
      'location': location,
      'status': status,
    };
  }
}