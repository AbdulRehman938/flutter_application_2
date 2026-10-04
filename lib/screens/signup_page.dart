import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isUser = true;
  bool _isAdmin = false;

  final AuthController _authController = Get.put(AuthController());
  AnimationController? _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ),
    );

    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _handleSignup() {
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF8383),
        colorText: Colors.white,
      );
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF8383),
        colorText: Colors.white,
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF8383),
        colorText: Colors.white,
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF8383),
        colorText: Colors.white,
      );
      return;
    }

    if (!_isUser && !_isAdmin) {
      Get.snackbar(
        'Error',
        'Please select at least one account type',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF8383),
        colorText: Colors.white,
      );
      return;
    }

    // Build roles list
    List<String> roles = [];
    if (_isUser) roles.add('user');
    if (_isAdmin) roles.add('admin');

    _authController.clearError();
    _authController
        .signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
      displayName: _nameController.text.trim(),
      roles: roles,
    )
        .then((success) async {
      if (success) {
        // Reset form fields
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() {
          _isUser = true;
          _isAdmin = false;
        });

        // Sign out the user (they were auto-signed in after signup)
        await _authController.signOut();

        // Wait a moment for sign out to complete
        await Future.delayed(const Duration(milliseconds: 300));

        Get.snackbar(
          'Success',
          'Account created successfully! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to login page
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar(
          'Error',
          _authController.errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: Column(
              children: [
                // Top section with cover image
                if (!isTablet)
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Image.asset(
                            'assets/cover.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.5),
                                  Colors.white,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Content section
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 48.0 : 24.0,
                    vertical: isTablet ? 32.0 : 24.0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 500 : double.infinity,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Sign up title
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFFF8383), Color(0xFFFF6B6B)],
                              ).createShader(bounds),
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: isTablet ? 42 : 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                height: 4,
                                width: 80,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF8383), Color(0xFFFF6B6B)],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Name field
                            _buildInputField(
                              controller: _nameController,
                              icon: Icons.person_outline,
                              hintText: 'Full Name',
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),

                            // Email field
                            _buildInputField(
                              controller: _emailController,
                              icon: Icons.email_outlined,
                              hintText: 'Email',
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),

                            // Password field
                            _buildInputField(
                              controller: _passwordController,
                              icon: Icons.lock_outline,
                              hintText: 'Password',
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF404040),
                                ),
                                onPressed: _togglePasswordVisibility,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Confirm Password field
                            _buildInputField(
                              controller: _confirmPasswordController,
                              icon: Icons.lock_outline,
                              hintText: 'Confirm Password',
                              obscureText: _obscureConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF404040),
                                ),
                                onPressed: _toggleConfirmPasswordVisibility,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Role Selection
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select Account Type',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF404040),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Material(
                                    color: Colors.transparent,
                                    child: CheckboxListTile(
                                      title: const Text('User'),
                                      subtitle: const Text('Access user dashboard and features'),
                                      value: _isUser,
                                      onChanged: (value) {
                                        setState(() {
                                          _isUser = value ?? true;
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: CheckboxListTile(
                                      title: const Text('Admin'),
                                      subtitle: const Text('Access admin dashboard and manage users'),
                                      value: _isAdmin,
                                      onChanged: (value) {
                                        setState(() {
                                          _isAdmin = value ?? false;
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Sign up button
                            _buildGradientButton(
                              onPressed: _handleSignup,
                              text: 'Create Account',
                              isLoading: false,
                            ),
                            const SizedBox(height: 20),

                            // Sign in text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an Account? ',
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.login);
                                  },
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: Color(0xFFFF8383),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF404040)),
          prefixIcon: Icon(icon, color: const Color(0xFF404040)),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: const TextStyle(color: Color(0xFF404040)),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    required String text,
    required bool isLoading,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8383), Color(0xFFFF6B6B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8383).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
