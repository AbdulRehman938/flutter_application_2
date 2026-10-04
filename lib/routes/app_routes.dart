import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/get_started_screen.dart';
import '../screens/login_page.dart';
import '../screens/signup_page.dart';
import '../screens/admin_dashboard.dart';
import '../screens/user_dashboard.dart';
import '../screens/home_screen.dart';
import '../screens/role_selection_screen.dart';

class AppRoutes {
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String admin = '/admin';
  static const String user = '/user';
  static const String home = '/home';
  static const String roleSelection = '/role-selection';

  static final routes = [
    GetPage(
      name: getStarted,
      page: () => const GetStartedScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: signup,
      page: () => const SignupPage(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: roleSelection,
      page: () => const RoleSelectionScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: admin,
      page: () => const AdminDashboard(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: user,
      page: () => const UserDashboard(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
  ];
}
