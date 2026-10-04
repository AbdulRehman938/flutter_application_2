import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final user = authController.currentUser;

    if (user == null) {
      // Redirect to login if no user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.login);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF8383).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8383), Color(0xFFFF6B6B)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      'Select Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF404040),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Welcome, ${user.displayName ?? user.email}!\nYou have access to multiple dashboards.',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF404040).withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // User Dashboard Card
                    if (user.isUser)
                      _buildRoleCard(
                        context,
                        icon: Icons.person,
                        title: 'User Dashboard',
                        subtitle: 'Access user features and profile',
                        color: const Color(0xFF4CAF50),
                        onTap: () {
                          Get.offAllNamed(AppRoutes.user);
                        },
                      ),

                    if (user.isUser && user.isAdmin)
                      const SizedBox(height: 16),

                    // Admin Dashboard Card
                    if (user.isAdmin)
                      _buildRoleCard(
                        context,
                        icon: Icons.admin_panel_settings,
                        title: 'Admin Dashboard',
                        subtitle: 'Manage users and view analytics',
                        color: const Color(0xFFFF8383),
                        onTap: () {
                          Get.offAllNamed(AppRoutes.admin);
                        },
                      ),

                    const SizedBox(height: 24),

                    // Logout button
                    TextButton(
                      onPressed: () {
                        authController.logout();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFF404040),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
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
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF404040).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF404040).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
