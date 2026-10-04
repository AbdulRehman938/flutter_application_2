import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  User? get firebaseUser => _firebaseUser.value;
  UserModel? get currentUser => _currentUser.value;
  bool get isLoggedIn => _firebaseUser.value != null;
  bool get isAdmin => _currentUser.value?.isAdmin ?? false;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.value = _authService.currentUser;
    _firebaseUser.bindStream(_authService.authStateChanges);

    ever(_firebaseUser, (User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser.value = null;
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final userData = await _firestoreService.getUser(uid);
      if (userData != null) {
        _currentUser.value = userData;
      } else {
        // Create user document if it doesn't exist
        final newUser = UserModel(
          uid: uid,
          email: _firebaseUser.value?.email ?? '',
          createdAt: DateTime.now(),
          roles: ['user'], // Default to user
          status: 'active',
        );
        await _firestoreService.createUser(newUser);
        _currentUser.value = newUser;
      }
    } catch (e) {
      errorMessage.value = 'Error loading user data: $e';
    }
  }

  Future<void> refreshUserData() async {
    if (_firebaseUser.value != null) {
      await _loadUserData(_firebaseUser.value!.uid);
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _authService.signInWithEmailAndPassword(email, password);

      if (result != null) {
        await _loadUserData(result.user!.uid);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage.value = 'No user found with this email.';
        print('Auth Error: No user found with this email');
      } else if (e.code == 'wrong-password') {
        errorMessage.value = 'Wrong password provided.';
        print('Auth Error: Wrong password provided');
      } else if (e.code == 'invalid-email') {
        errorMessage.value = 'Invalid email address.';
        print('Auth Error: Invalid email address');
      } else {
        errorMessage.value = e.message ?? 'An error occurred.';
        print('Auth Error: ${e.message}');
      }
      return false;
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print('Auth Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void navigateBasedOnRole() {
    final user = _currentUser.value;
    
    // If user data is not loaded, default to user dashboard
    if (user == null) {
      Get.offAllNamed(AppRoutes.user);
      return;
    }

    // Check if user is active
    if (!user.isActive) {
      Get.snackbar(
        'Account Inactive',
        'Your account has been deactivated. Please contact support.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      signOut();
      return;
    }

    // If user has multiple roles, show role selection
    if (user.hasMultipleRoles) {
      Get.offAllNamed(AppRoutes.roleSelection);
    } else if (user.isAdmin) {
      Get.offAllNamed(AppRoutes.admin);
    } else {
      Get.offAllNamed(AppRoutes.user);
    }
  }

  Future<bool> signUpWithEmailAndPassword(
    String email,
    String password, {
    String? displayName,
    List<String>? roles,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _authService.signUpWithEmailAndPassword(email, password);

      if (result != null) {
        // Create user document with selected roles
        final newUser = UserModel(
          uid: result.user!.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
          roles: roles ?? ['user'], // Default to user if not specified
          status: 'active',
        );
        await _firestoreService.createUser(newUser);
        _currentUser.value = newUser;
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage.value = 'The password provided is too weak.';
        print('Auth Error: Weak password');
      } else if (e.code == 'email-already-in-use') {
        errorMessage.value = 'An account already exists with this email.';
        print('Auth Error: Email already in use');
      } else if (e.code == 'invalid-email') {
        errorMessage.value = 'Invalid email address.';
        print('Auth Error: Invalid email address');
      } else {
        errorMessage.value = e.message ?? 'An error occurred.';
        print('Auth Error: ${e.message}');
      }
      return false;
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print('Auth Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _authService.signInWithGoogle();
      
      if (result != null) {
        await _loadUserData(result.user!.uid);
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Google sign-in failed: $e';
      print('Google Sign-In Error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      errorMessage.value = 'Sign out failed: $e';
    }
  }

  Future<void> logout() async {
    await signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _authService.resetPassword(email);
      Get.snackbar(
        'Success',
        'Password reset email sent',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to send reset email: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}
