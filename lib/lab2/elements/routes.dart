import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/pages/login.dart';
import 'package:mobile_labs/lab2/pages/main_control_page.dart';
import 'package:mobile_labs/lab2/pages/registration.dart';
import 'package:mobile_labs/lab2/pages/user_profile.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/registration': (context) => const RegistrationPage(),
  '/': (context) => const LoginPage(),
  '/home': (context) => const HomePage(),
  '/profile': (context) => const ProfilePage(),
};
