import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAdmin = false;
  User? _currentUser;

  // Getters for the state
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _isAdmin;
  User? get currentUser => _currentUser;

  AuthProvider() {
    // Listen to auth state changes to keep the provider in sync
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      if (user == null) {
        _isAdmin = false;
        _isLoading = false;
        _errorMessage = null;
      }
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      // Set loading state to true and clear previous errors
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update current user
      _currentUser = userCredential.user;

      // Check if the email exists in the 'admins' collection
      final adminDoc = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email.trim())
          .get();

      if (adminDoc.docs.isNotEmpty) {
        // User is an admin, update state
        _isAdmin = true;
      } else {
        // User is not an admin, sign out and throw an exception
        await _auth.signOut();
        _isAdmin = false;
        throw Exception('Access denied: User is not an admin');
      }
    } catch (e) {
      // Handle specific Firebase Auth errors and set error message
      String error = 'Login failed: ${e.toString()}';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            error = 'No user found with this email';
            break;
          case 'wrong-password':
            error = 'Incorrect password';
            break;
          case 'invalid-email':
            error = 'Invalid email format';
            break;
          case 'too-many-requests':
            error = 'Too many login attempts. Try again later';
            break;
          default:
            error = 'Login failed: ${e.message}';
        }
      }
      _errorMessage = error;
      _isAdmin = false;
      _currentUser = null;
      throw Exception(error);
    } finally {
      // Reset loading state
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.signOut();
      _isAdmin = false;
      _currentUser = null;
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if a user is currently logged in and is an admin
  Future<bool> checkAuthStatus() async {
    try {
      _currentUser = _auth.currentUser;
      if (_currentUser != null) {
        final adminDoc = await _firestore
            .collection('admins')
            .where('email', isEqualTo: _currentUser!.email)
            .get();
        _isAdmin = adminDoc.docs.isNotEmpty;
      } else {
        _isAdmin = false;
      }
      notifyListeners();
      return _isAdmin;
    } catch (e) {
      _errorMessage = 'Error checking auth status: ${e.toString()}';
      _isAdmin = false;
      notifyListeners();
      return false;
    }
  }
}