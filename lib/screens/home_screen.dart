import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocationController _locationController;
  AuthController? _authController;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _locationController = Get.put(LocationController());
    try {
      _authController = Get.find<AuthController>();
      // Load user's last known location
      final user = _authController?.firebaseUser;
      if (user != null) {
        _locationController.loadUserLocation(user.uid);
      }
    } catch (e) {
      // AuthController not found yet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authController?.logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        final currentLocation = _locationController.currentLocation.value;
        final isLoading = _locationController.isLoading.value;

        // Auto-focus map when location changes
        if (currentLocation != null && !isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mapController.move(currentLocation, 15.0);
          });
        }

        return Stack(
          children: [
            // OpenStreetMap
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation ?? const LatLng(37.7749, -122.4194),
                initialZoom: 15.0,
                onTap: (tapPosition, point) {
                  // Handle tap
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flutter_application_2',
                ),
                // Marker for current location
                if (currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation,
                        width: 100,
                        height: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'You are here',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            // Loading indicator
            if (isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            // Zoom controls
            Positioned(
              right: 16,
              top: 16,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'zoom_in',
                    onPressed: () {
                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom + 1,
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'zoom_out',
                    onPressed: () {
                      _mapController.move(
                        _mapController.camera.center,
                        _mapController.camera.zoom - 1,
                      );
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      // FAB for location button
      floatingActionButton: Obx(() {
        final user = _authController?.firebaseUser;
        final isLoading = _locationController.isLoading.value;
        return FloatingActionButton(
          onPressed: isLoading
              ? null
              : (user != null)
                  ? () {
                      _locationController.fetchAndSaveLocation(user.uid);
                    }
                  : null,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.my_location),
        );
      }),
    );
  }
}
