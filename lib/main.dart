import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/lab2/elements/routes.dart';
import 'package:mobile_labs/lab2/service/internet_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const FlutterSecureStorage storage = FlutterSecureStorage();
  final isLoggedIn = await storage.read(key: 'isLoggedIn');

  runApp(MyApp(initialRoute: isLoggedIn == 'true' ? '/home' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Smart Lock';

    return ChangeNotifierProvider(
      create: (_) => NetworkProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: ThemeData.dark(),
        initialRoute: initialRoute,
        routes: appRoutes,
      ),
    );
  }
}
