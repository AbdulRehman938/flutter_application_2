import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFFF8383),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 600;
                final cardWidth = isWideScreen 
                    ? constraints.maxWidth * 0.8 
                    : constraints.maxWidth * 0.95;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Card
                    CustomCard(
                      width: cardWidth,
                      backgroundColor: const Color(0xFFFF8383),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.admin_panel_settings,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome, Admin!',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You have full access to the system',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
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
                              value: '1,234',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.shopping_cart,
                              title: 'Orders',
                              value: '567',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.attach_money,
                              title: 'Revenue',
                              value: '\$12,345',
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
                            value: '1,234',
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            context,
                            icon: Icons.shopping_cart,
                            title: 'Orders',
                            value: '567',
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            context,
                            icon: Icons.attach_money,
                            title: 'Revenue',
                            value: '\$12,345',
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Action Cards
                    CustomCard(
                      width: cardWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF404040),
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildActionItem(
                            context,
                            icon: Icons.person_add,
                            title: 'Add New User',
                            subtitle: 'Create a new user account',
                            onTap: () {
                              _showUnderDevelopmentDialog(context, 'Add User');
                            },
                          ),
                          const Divider(),
                          _buildActionItem(
                            context,
                            icon: Icons.settings,
                            title: 'System Settings',
                            subtitle: 'Configure system parameters',
                            onTap: () {
                              _showUnderDevelopmentDialog(context, 'Settings');
                            },
                          ),
                          const Divider(),
                          _buildActionItem(
                            context,
                            icon: Icons.analytics,
                            title: 'View Reports',
                            subtitle: 'Generate and view reports',
                            onTap: () {
                              _showUnderDevelopmentDialog(context, 'Reports');
                            },
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

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return CustomCard(
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: const Color(0xFFFF8383),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF8383),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF404040).withOpacity(0.7),
                ),
          ),
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

  void _showUnderDevelopmentDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                Navigator.of(context).pop();
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
        );
      },
    );
  }
}
