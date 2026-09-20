import 'package:flutter/material.dart';
import 'screens/get_started_screen.dart';
import 'screens/login_page.dart';
import 'screens/admin_dashboard.dart';
import 'screens/user_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/get-started',
      routes: {
        '/get-started': (context) => const GetStartedScreen(),
        '/login': (context) => const LoginPage(),
        '/admin': (context) => const AdminDashboard(),
        '/user': (context) => const UserDashboard(),
      },
    );
  }
}
