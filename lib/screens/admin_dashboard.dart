import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../models/location_model.dart';
import '../services/firestore_service.dart';
import '../routes/app_routes.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _mapEnabled = false;
  bool _detailMapEnabled = false;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFFF8383),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Switch to user dashboard if admin also has user role
          if (authController.currentUser?.isUser ?? false)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.user);
                },
                tooltip: 'Switch to User Dashboard',
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
                              Icons.admin_panel_settings,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Welcome, Admin!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You have full access to the system',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats Grid
                    if (isWideScreen)
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.people,
                              title: 'Total Users',
                              value: Obx(() => Text(
                                userController.allUsers.length.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8383),
                                ),
                              )),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.shopping_cart,
                              title: 'Orders',
                              value: const Text(
                                '567',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8383),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.attach_money,
                              title: 'Revenue',
                              value: const Text(
                                '\$12,345',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8383),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildStatCard(
                            context,
                            icon: Icons.people,
                            title: 'Total Users',
                            value: Obx(() => Text(
                              userController.allUsers.length.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8383),
                              ),
                            )),
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            context,
                            icon: Icons.shopping_cart,
                            title: 'Orders',
                            value: const Text(
                              '567',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8383),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            context,
                            icon: Icons.attach_money,
                            title: 'Revenue',
                            value: const Text(
                              '\$12,345',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8383),
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 24),

                    // Quick Actions and User Locations in a row for wide screens
                    if (isWideScreen)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildQuickActionsCard(context, userController, cardWidth),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildUserLocationsCard(context, userController, cardWidth),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildQuickActionsCard(context, userController, cardWidth),
                          const SizedBox(height: 16),
                          _buildUserLocationsCard(context, userController, cardWidth),
                        ],
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

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget value,
  }) {
    return Container(
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8383).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFFFF8383),
            ),
          ),
          const SizedBox(height: 16),
          value,
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF404040),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context, UserController userController, double cardWidth) {
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
          Text(
            'Quick Actions',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF404040),
                ),
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            context,
            icon: Icons.people,
            title: 'Manage Users',
            subtitle: 'View and manage user accounts',
            onTap: () {
              _showUserManagementDialog(context, userController);
            },
          ),
          const Divider(),
          _buildActionItem(
            context,
            icon: Icons.settings,
            title: 'System Settings',
            subtitle: 'Configure system parameters',
            onTap: () {
              _showUnderDevelopmentDialog('Settings');
            },
          ),
          const Divider(),
          _buildActionItem(
            context,
            icon: Icons.analytics,
            title: 'View Reports',
            subtitle: 'Generate and view reports',
            onTap: () {
              _showUnderDevelopmentDialog('Reports');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserLocationsCard(BuildContext context, UserController userController, double cardWidth) {
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
                'User Locations',
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
                  userController.loadAllUsers();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: _buildUserLocationMap(context, userController),
          ),
          const SizedBox(height: 16),
          _buildUserLocationList(context, userController),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8383).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF8383),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF404040),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF404040).withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFF404040).withOpacity(0.5),
            ),
          ],
        ),
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

  void _showUserManagementDialog(BuildContext context, UserController userController) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
                Icons.people,
                color: Color(0xFFFF8383),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Manage Users',
              style: TextStyle(
                color: Color(0xFF404040),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: Obx(() {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userController.allUsers.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No users found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: userController.allUsers.length,
              itemBuilder: (context, index) {
                final user = userController.allUsers[index];
                return _buildUserListItem(context, user, userController);
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Close',
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

  Widget _buildUserListItem(BuildContext context, UserModel user, UserController userController) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF404040),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Roles:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF404040),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Checkbox(
                            value: user.roles.contains('user'),
                            onChanged: (value) {
                              List<String> newRoles = List.from(user.roles);
                              if (value == true) {
                                if (!newRoles.contains('user')) newRoles.add('user');
                              } else {
                                newRoles.remove('user');
                              }
                              if (newRoles.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'User must have at least one role',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              userController.updateUserRoles(user.uid, newRoles);
                            },
                          ),
                          const Text('User'),
                          const SizedBox(width: 16),
                          Checkbox(
                            value: user.roles.contains('admin'),
                            onChanged: (value) {
                              List<String> newRoles = List.from(user.roles);
                              if (value == true) {
                                if (!newRoles.contains('admin')) newRoles.add('admin');
                              } else {
                                newRoles.remove('admin');
                              }
                              if (newRoles.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'User must have at least one role',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              userController.updateUserRoles(user.uid, newRoles);
                            },
                          ),
                          const Text('Admin'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF404040),
                        ),
                      ),
                      const SizedBox(height: 4),
                      DropdownButton<String>(
                        value: user.status,
                        items: const [
                          DropdownMenuItem(value: 'active', child: Text('Active')),
                          DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                          DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            userController.updateUserStatus(user.uid, value);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserLocationMap(BuildContext context, UserController userController) {
    final firestoreService = FirestoreService();

    return StreamBuilder<List<LocationModel>>(
      stream: firestoreService.getAllUserLocations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final locations = snapshot.data ?? [];

        if (locations.isEmpty) {
          return const Center(
            child: Text(
              'No user locations available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        try {
          // Calculate center point for map
          final avgLat = locations.map((l) => l.latitude).reduce((a, b) => a + b) / locations.length;
          final avgLng = locations.map((l) => l.longitude).reduce((a, b) => a + b) / locations.length;
          final center = LatLng(avgLat, avgLng);

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 10.0,
                  interactionOptions: _mapEnabled
                      ? const InteractionOptions()
                      : const InteractionOptions(flags: InteractiveFlag.none),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.flutter_application_2',
                  ),
                  MarkerLayer(
                    markers: locations.map((location) {
                      return Marker(
                        point: LatLng(location.latitude, location.longitude),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            _showUserLocationDetails(context, location, userController);
                          },
                          child: const Icon(
                            Icons.location_on,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
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
        } catch (e) {
          return Center(
            child: Text(
              'Error loading map: $e',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget _buildUserLocationList(BuildContext context, UserController userController) {
    final firestoreService = FirestoreService();

    return StreamBuilder<List<LocationModel>>(
      stream: firestoreService.getAllUserLocations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final locations = snapshot.data ?? [];

        if (locations.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              final userId = location.userId.length > 8 ? '${location.userId.substring(0, 8)}...' : location.userId;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Color(0xFFFF8383)),
                  title: Text('User ID: $userId'),
                  subtitle: Text(
                    'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}\n'
                    'Updated: ${_formatTimestamp(location.timestamp)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.visibility, color: Color(0xFFFF8383)),
                    onPressed: () {
                      _showUserLocationDetails(context, location, userController);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _showUserLocationDetails(BuildContext context, LocationModel location, UserController userController) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
                Icons.location_on,
                color: Color(0xFFFF8383),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'User Location Details',
              style: TextStyle(
                color: Color(0xFF404040),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('User ID', location.userId),
            const SizedBox(height: 8),
            _buildDetailRow('Latitude', location.latitude.toStringAsFixed(6)),
            const SizedBox(height: 8),
            _buildDetailRow('Longitude', location.longitude.toStringAsFixed(6)),
            const SizedBox(height: 8),
            _buildDetailRow('Last Updated', _formatTimestamp(location.timestamp)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(location.latitude, location.longitude),
                      initialZoom: 15.0,
                      interactionOptions: _detailMapEnabled
                          ? const InteractionOptions()
                          : const InteractionOptions(flags: InteractiveFlag.none),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.flutter_application_2',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(location.latitude, location.longitude),
                            width: 40,
                            height: 40,
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
                  if (!_detailMapEnabled)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _detailMapEnabled = true;
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
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Close',
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF404040),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF404040),
            ),
          ),
        ),
      ],
    );
  }
}
