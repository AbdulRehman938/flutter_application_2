import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllUsers();
  }

  void loadAllUsers() {
    isLoading.value = true;
    _firestoreService.getAllUsers().listen(
      (users) {
        allUsers.value = users;
        isLoading.value = false;
      },
      onError: (error) {
        errorMessage.value = 'Error loading users: $error';
        isLoading.value = false;
      },
    );
  }

  Future<void> updateUserStatus(String uid, String status) async {
    try {
      await _firestoreService.updateUserStatus(uid, status);
      Get.snackbar(
        'Success',
        'User status updated to $status',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update status: $e';
      Get.snackbar(
        'Error',
        'Failed to update status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateUserRole(String uid, String role) async {
    try {
      // Update user role (single role for now, can be extended to multiple)
      await _firestoreService.updateUserRole(uid, role);
      Get.snackbar(
        'Success',
        'User role updated to $role',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update role: $e';
      Get.snackbar(
        'Error',
        'Failed to update role',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateUserRoles(String uid, List<String> roles) async {
    try {
      await _firestoreService.updateUserProfile(uid, {'roles': roles});
      Get.snackbar(
        'Success',
        'User roles updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to update roles: $e';
      Get.snackbar(
        'Error',
        'Failed to update roles',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestoreService.deleteUser(uid);
      Get.snackbar(
        'Success',
        'User deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to delete user: $e';
      Get.snackbar(
        'Error',
        'Failed to delete user',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}
