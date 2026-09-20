import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top section with cover image (showing only bottom half)
          Expanded(
            flex: 4,
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
          // Bottom white section with content
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Welcome text
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404040),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description text
                  const Text(
                    'Lorem ipsum dolor sit amet consectetur. Egestas dolor amet malesuada laoreet.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF404040),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Continue button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF404040),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8383),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
