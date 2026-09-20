import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
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
                            Icons.person,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome, User!',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Access your personal dashboard',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // User Info Card
                    CustomCard(
                      width: cardWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF404040),
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            context,
                            icon: Icons.email,
                            label: 'Email',
                            value: 'user@example.com',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            icon: Icons.phone,
                            label: 'Phone',
                            value: '+1 234 567 890',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            icon: Icons.location_on,
                            label: 'Location',
                            value: 'New York, USA',
                          ),
                        ],
                      ),
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
                                _showUnderDevelopmentDialog(context, 'Order History');
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
                                _showUnderDevelopmentDialog(context, 'Wishlist');
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
                                _showUnderDevelopmentDialog(context, 'Notifications');
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
                              _showUnderDevelopmentDialog(context, 'Order History');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.favorite,
                            title: 'Wishlist',
                            subtitle: 'View saved items',
                            onTap: () {
                              _showUnderDevelopmentDialog(context, 'Wishlist');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.notifications,
                            title: 'Notifications',
                            subtitle: 'View alerts',
                            onTap: () {
                              _showUnderDevelopmentDialog(context, 'Notifications');
                            },
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Activity
                    CustomCard(
                      width: cardWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Activity',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
      borderRadius: BorderRadius.circular(16),
      child: CustomCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8383).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: const Color(0xFFFF8383),
              ),
            ),
            const SizedBox(height: 12),
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
