import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/background.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/custom_text_field.dart';
import 'package:mobile_labs/lab2/elements/functions/registration_controller.dart';
import 'package:mobile_labs/lab2/service/internet_service.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final RegistrationController _controller = RegistrationController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return Scaffold(
      body: Background(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? size.width * 0.2 : 20,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Створіть акаунт',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _controller.loginController,
                    labelText: 'Логін',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _controller.emailController,
                    labelText: 'Email',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _controller.passwordController,
                    labelText: 'Пароль',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final network =
                      Provider.of<NetworkProvider>(context, listen: false);
                      if (!network.isConnected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Немає підключення до Інтернету'),
                          ),
                        );
                        return;
                      }

                      _controller.register(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: isTablet ? 60 : 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Зареєструватися',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      'Вже є акаунт? Увійти',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
