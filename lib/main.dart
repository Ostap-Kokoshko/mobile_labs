import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Smart Lock';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData.dark(),
      initialRoute: '/registration',
      routes: appRoutes,
    );
  }
}
