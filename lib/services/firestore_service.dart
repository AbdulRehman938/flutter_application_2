import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/location_model.dart';

class FirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _locationsCollection =
      FirebaseFirestore.instance.collection('user_locations');

  // Create or update user document
  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Get user by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get user stream by UID
  Stream<UserModel?> getUserStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  // Update user status (admin can change this)
  Future<void> updateUserStatus(String uid, String status) async {
    try {
      await _usersCollection.doc(uid).update({'status': status});
    } catch (e) {
      rethrow;
    }
  }

  // Update user role (admin can change this) - converts to roles list
  Future<void> updateUserRole(String uid, String role) async {
    try {
      await _usersCollection.doc(uid).update({'roles': [role]});
    } catch (e) {
      rethrow;
    }
  }

  // Get all users (for admin dashboard)
  Stream<List<UserModel>> getAllUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Save or update user location
  Future<void> saveUserLocation(LocationModel location) async {
    try {
      // Use userId as document ID to always update the same document
      await _locationsCollection.doc(location.userId).set(location.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Get user's latest location
  Future<LocationModel?> getUserLocation(String userId) async {
    try {
      final doc = await _locationsCollection.doc(userId).get();
      if (doc.exists) {
        return LocationModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get user location stream
  Stream<LocationModel?> getUserLocationStream(String userId) {
    return _locationsCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return LocationModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Get all user locations (for admin dashboard)
  Stream<List<LocationModel>> getAllUserLocations() {
    return _locationsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return LocationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get user location by userId
  Future<LocationModel?> getUserLocationByUserId(String userId) async {
    try {
      final doc = await _locationsCollection.doc(userId).get();
      if (doc.exists) {
        return LocationModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
