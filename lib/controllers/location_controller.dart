import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import '../services/firestore_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();
  final FirestoreService _firestoreService = FirestoreService();

  // Reactive variables
  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Get current location and save to Firestore
  Future<void> fetchAndSaveLocation(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('Location: Starting location fetch...');

      // Check if location service is enabled
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      print('Location: Service enabled = $serviceEnabled');
      if (!serviceEnabled) {
        errorMessage.value = 'Location services are disabled. Please enable them.';
        print('Location Error: Location services are disabled');
        isLoading.value = false;
        return;
      }

      // Request permission
      print('Location: Requesting permission...');
      final permission = await _locationService.requestLocationPermission();
      print('Location: Permission status = $permission');
      if (permission == LocationPermission.denied) {
        errorMessage.value = 'Location permissions are denied. Please allow location access in your browser.';
        print('Location Error: Location permissions are denied');
        isLoading.value = false;
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value = 'Location permissions are permanently denied.';
        print('Location Error: Location permissions are permanently denied');
        isLoading.value = false;
        return;
      }

      // Get current position
      print('Location: Getting current position...');
      final position = await _locationService.getCurrentPosition();
      print('Location: Position retrieved - Lat=${position.latitude}, Lng=${position.longitude}');
      final latLng = LatLng(position.latitude, position.longitude);
      currentLocation.value = latLng;

      // Save to Firestore
      final locationModel = LocationModel(
        userId: userId,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
      await _firestoreService.saveUserLocation(locationModel);

      print('Location Saved: Lat=${position.latitude}, Lng=${position.longitude}');

      Get.snackbar(
        'Location Updated',
        'Your location has been saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Error fetching location: $e';
      print('Location Error: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch location: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load user's last known location from Firestore
  Future<void> loadUserLocation(String userId) async {
    try {
      final location = await _firestoreService.getUserLocation(userId);
      if (location != null) {
        currentLocation.value = LatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      // Silently handle error
    }
  }
}
