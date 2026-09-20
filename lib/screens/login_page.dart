import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Demo credentials - In production, these should be validated against a backend
  static const String adminEmail = 'admin';
  static const String adminPassword = 'admin123';
  static const String userEmail = 'user';
  static const String userPassword = 'user123';

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Color(0xFFFF8383),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Check credentials and route accordingly
      if (email == adminEmail && password == adminPassword) {
        Navigator.pushReplacementNamed(context, '/admin');
      } else if (email == userEmail && password == userPassword) {
        Navigator.pushReplacementNamed(context, '/user');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top section with cover image (showing only bottom half)
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Cover image positioned at top
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
              ],
            ),
          ),
          // Bottom white section with form content
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Sign in title with underline
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF404040),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 3,
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF8383),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    
                    // Email field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF404040),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: 'userName',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF404040),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color(0xFFE0E0E0),
                          thickness: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Password field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF404040),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: const InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF404040),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: const Color(0xFF404040),
                              ),
                              onPressed: _togglePasswordVisibility,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color(0xFFE0E0E0),
                          thickness: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Remember me and Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFFFF8383),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Remember Me',
                              style: TextStyle(
                                color: Color(0xFF404040),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _showUnderDevelopmentDialog(context, 'Forgot Password');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFFFF8383),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    
                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8383),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Demo credentials
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8383).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Demo Credentials:',
                            style: TextStyle(
                              color: Color(0xFF404040),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Admin: admin / admin123',
                            style: TextStyle(
                              color: const Color(0xFF404040).withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'User: user / user123',
                            style: TextStyle(
                              color: const Color(0xFF404040).withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Sign up text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an Account? ",
                          style: TextStyle(
                            color: Color(0xFF404040),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showUnderDevelopmentDialog(context, 'Sign up');
                          },
                          child: const Text(
                            'Sign up',
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
        ],
      ),
    );
  }
}
