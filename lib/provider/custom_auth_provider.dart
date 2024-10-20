import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CustomAuthProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  String? _currentUserId;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;

  CustomAuthProvider() {
    checkSession();
  }

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('userId');
    print("Stored userId : $storedUserId");
    if (storedUserId != null) {
      await _loadUserData(storedUserId);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        _currentUserId = userId;
        _currentUser = userDoc.data() as Map<String, dynamic>;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<bool> signIn(String username, String password) async {
    try {
      final userDoc = await _firestore.collection('users').doc(username).get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final hashedPassword = _hashPassword(password);

      if (userData['password'] != hashedPassword) {
        throw Exception('Incorrect password');
      }

      if (userData['isAdmin'] != true) {
        throw Exception('Only admins can log in to the website');
      }

      _currentUserId = username;
      _currentUser = userData;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', username);
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
      // return false;
    }
  }

  Future<bool> createAccount({
    required String username,
    required String password,
    required String email,
    required String name,
    required String phone,
    required bool isAdmin,
  }) async {
    try {
      final userDoc = await _firestore.collection('users').doc(username).get();

      if (userDoc.exists) {
        throw Exception('Username already exists');
      }

      final hashedPassword = _hashPassword(password);

      await _firestore.collection('users').doc(username).set({
        'username': username,
        'password': hashedPassword,
        'email': email,
        'name': name,
        'phone': phone,
        'isAdmin': isAdmin,
      });

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      final HttpsCallable callable =
          _functions.httpsCallable('requestPasswordReset');
      final result = await callable.call({'email': email});

      if (result.data['success']) {
        return true;
      } else {
        throw Exception(result.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('resetPassword');
      final result = await callable.call({
        'token': token,
        'newPassword': newPassword,
      });

      if (result.data['success']) {
        return true;
      } else {
        throw Exception(result.data['message']);
      }
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    _currentUserId = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
    if (context.mounted) {
      context.go('/signin');
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    print(digest.toString());
    return digest.toString();
  }
}
