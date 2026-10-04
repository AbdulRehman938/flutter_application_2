import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/location_controller.dart';
import '../services/firestore_service.dart';
import '../routes/app_routes.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool _mapEnabled = false;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        backgroundColor: const Color(0xFFFF8383),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Switch to admin dashboard if user has admin role
          if (authController.currentUser?.isAdmin ?? false)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.admin_panel_settings),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.admin);
                },
                tooltip: 'Switch to Admin Dashboard',
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authController.signOut();
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF8383).withOpacity(0.15),
              const Color(0xFFFF8383).withOpacity(0.05),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 400;
                final cardWidth = isWideScreen
                    ? constraints.maxWidth * 0.45
                    : constraints.maxWidth * 0.95;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Card with gradient
                    Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8383), Color(0xFFFF6B6B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8383).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Welcome, User!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Access your personal dashboard',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Profile and Location in a row for wide screens
                    if (isWideScreen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildProfileCard(context, authController, cardWidth),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLocationCard(context, authController, cardWidth),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildProfileCard(context, authController, cardWidth),
                          const SizedBox(height: 16),
                          _buildLocationCard(context, authController, cardWidth),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Action Cards
                    if (isWideScreen)
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              context,
                              icon: Icons.history,
                              title: 'Order History',
                              subtitle: 'View past orders',
                              onTap: () {
                                _showUnderDevelopmentDialog('Order History');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              context,
                              icon: Icons.favorite,
                              title: 'Wishlist',
                              subtitle: 'View saved items',
                              onTap: () {
                                _showUnderDevelopmentDialog('Wishlist');
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              context,
                              icon: Icons.notifications,
                              title: 'Notifications',
                              subtitle: 'View alerts',
                              onTap: () {
                                _showUnderDevelopmentDialog('Notifications');
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildActionCard(
                            context,
                            icon: Icons.history,
                            title: 'Order History',
                            subtitle: 'View past orders',
                            onTap: () {
                              _showUnderDevelopmentDialog('Order History');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.favorite,
                            title: 'Wishlist',
                            subtitle: 'View saved items',
                            onTap: () {
                              _showUnderDevelopmentDialog('Wishlist');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.notifications,
                            title: 'Notifications',
                            subtitle: 'View alerts',
                            onTap: () {
                              _showUnderDevelopmentDialog('Notifications');
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 24),

                    // Recent Activity
                    Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Activity',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF404040),
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildActivityItem(
                            context,
                            icon: Icons.shopping_bag,
                            title: 'Order #12345',
                            subtitle: 'Placed 2 hours ago',
                            trailing: '\$99.99',
                          ),
                          const Divider(),
                          _buildActivityItem(
                            context,
                            icon: Icons.login,
                            title: 'Login',
                            subtitle: 'Logged in from Chrome',
                            trailing: 'Today',
                          ),
                          const Divider(),
                          _buildActivityItem(
                            context,
                            icon: Icons.edit,
                            title: 'Profile Update',
                            subtitle: 'Updated phone number',
                            trailing: 'Yesterday',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF8383),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF404040),
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF404040),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF8383).withOpacity(0.1),
                    const Color(0xFFFF6B6B).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: const Color(0xFFFF8383),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF404040),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF404040).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8383).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFFFF8383),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF404040),
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF404040).withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF404040).withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _showUnderDevelopmentDialog(String featureName) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8383).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.construction,
                color: Color(0xFFFF8383),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Under Development',
              style: TextStyle(
                color: Color(0xFF404040),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'The $featureName screen is currently under development. Please check back later.',
          style: const TextStyle(
            color: Color(0xFF404040),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFFFF8383),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMap(BuildContext context, AuthController authController) {
    final locationController = Get.put(LocationController());
    final user = authController.currentUser;
    final MapController mapController = MapController();

    if (user != null) {
      locationController.loadUserLocation(user.uid);
    }

    return Obx(() {
      final currentLocation = locationController.currentLocation.value;
      final isLoading = locationController.isLoading.value;

      // Auto-focus map when location changes
      if (currentLocation != null && !isLoading && _mapEnabled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapController.move(currentLocation, 15.0);
        });
      }

      return Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation ?? const LatLng(37.7749, -122.4194),
              initialZoom: 15.0,
              interactionOptions: _mapEnabled
                  ? const InteractionOptions()
                  : const InteractionOptions(flags: InteractiveFlag.none),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_application_2',
              ),
              if (currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (currentLocation == null && !isLoading)
            const Center(
              child: Text(
                'No location data available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          if (!_mapEnabled)
            GestureDetector(
              onTap: () {
                setState(() {
                  _mapEnabled = true;
                });
              },
              child: Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 48,
                        color: Color(0xFFFF8383),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to enable map',
                        style: TextStyle(
                          color: Color(0xFF404040),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildProfileCard(BuildContext context, AuthController authController, double cardWidth) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Information',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF404040),
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFFFF8383)),
                onPressed: () {
                  _showEditProfileDialog(context, authController);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => _buildInfoRow(
            context,
            icon: Icons.email,
            label: 'Email',
            value: authController.currentUser?.email ??
                'Not available',
          )),
          const Divider(),
          Obx(() => _buildInfoRow(
            context,
            icon: Icons.person,
            label: 'Name',
            value: authController.currentUser?.displayName ??
                'Not set',
          )),
          const Divider(),
          _buildInfoRow(
            context,
            icon: Icons.admin_panel_settings,
            label: 'Roles',
            value: authController.currentUser?.roles.join(', ') ?? 'user',
          ),
          const Divider(),
          _buildInfoRow(
            context,
            icon: Icons.verified_user,
            label: 'Status',
            value: authController.currentUser?.status ?? 'active',
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, AuthController authController, double cardWidth) {
    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Location',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF404040),
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFFFF8383)),
                onPressed: () {
                  final locationController = Get.find<LocationController>();
                  final user = authController.currentUser;
                  if (user != null) {
                    locationController.fetchAndSaveLocation(user.uid);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildLocationMap(context, authController),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthController authController) {
    final nameController = TextEditingController(
      text: authController.currentUser?.displayName ?? '',
    );

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF404040),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Display Name',
            hintText: 'Enter your name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF404040),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                // Update in Firestore
                final firestoreService = FirestoreService();
                await firestoreService.updateUserProfile(
                  authController.currentUser!.uid,
                  {'displayName': nameController.text.trim()},
                );
                // Reload user data
                await authController.refreshUserData();
                Get.back();
                Get.snackbar(
                  'Success',
                  'Profile updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8383),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
