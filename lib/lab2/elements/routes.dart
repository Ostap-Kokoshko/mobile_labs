import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/pages/home_page/main_control_page.dart';
import 'package:mobile_labs/lab2/pages/login_page/login_view/login.dart';
import 'package:mobile_labs/lab2/pages/registration_page/registration_view/registration.dart';
import 'package:mobile_labs/lab2/pages/settings_page/settings_view/settings_page.dart';
import 'package:mobile_labs/lab2/pages/user_page/user_view/user_profile.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/registration': (context) => const RegistrationPage(),
  '/': (context) => LoginPage(),
  '/home': (context) => const HomePage(),
  '/profile': (context) => const ProfilePage(),
  '/settings': (context) => const SettingsPage(),
};
