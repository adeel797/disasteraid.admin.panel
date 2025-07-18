import 'package:flutter/material.dart';

class PostFeedbackProvider extends ChangeNotifier {
  String _selectedStatus = 'pending';

  String get selectedStatus => _selectedStatus;

  void setSelectedStatus(String newValue) {
    _selectedStatus = newValue;
    notifyListeners();
  }
}