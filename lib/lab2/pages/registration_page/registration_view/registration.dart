import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/lab2/elements/background.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/custom_text_field.dart';
import 'package:mobile_labs/lab2/pages/registration_page/cubit/registration_cubit.dart';
import 'package:mobile_labs/lab2/pages/registration_page/cubit/registration_state.dart';
import 'package:mobile_labs/lab2/service/internet_service.dart';
import 'package:mobile_labs/lab2/storage/user_storage_secure.dart';
import 'package:mobile_labs/lab2/validation/registration_validation.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  void _register(BuildContext context, RegistrationState state) async {
    final String? emailError =
        RegistrationValidation.validateEmail(state.email);
    final String? loginError =
        RegistrationValidation.validateLogin(state.login);
    final String? passwordError =
        RegistrationValidation.validatePassword(state.password);

    if (emailError != null || loginError != null || passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError ?? loginError ?? passwordError!)),
      );
      return;
    }

    final storage = UserStorageSecure();
    await storage.saveUserData(state.email, state.login, state.password);
    await storage.saveUserLoginStatus(true);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return BlocProvider(
      create: (_) => RegistrationCubit(),
      child: Scaffold(
        body: Background(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? size.width * 0.2 : 20,
                  vertical: 20,
                ),
                child: BlocBuilder<RegistrationCubit, RegistrationState>(
                  builder: (context, state) {
                    return Column(
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
                          labelText: 'Логін',
                          controller: TextEditingController(text: state.login)
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: state.login.length),
                            ),
                          onChanged: (value) => context
                              .read<RegistrationCubit>()
                              .updateLogin(value),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Email',
                          controller: TextEditingController(text: state.email)
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: state.email.length),
                            ),
                          onChanged: (value) => context
                              .read<RegistrationCubit>()
                              .updateEmail(value),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Пароль',
                          obscureText: true,
                          controller:
                              TextEditingController(text: state.password)
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: state.password.length),
                                ),
                          onChanged: (value) => context
                              .read<RegistrationCubit>()
                              .updatePassword(value),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final network = Provider.of<NetworkProvider>(
                              context,
                              listen: false,
                            );
                            if (!network.isConnected) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Немає підключення до Інтернету'),
                                ),
                              );
                              return;
                            }
                            _register(context, state);
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
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
