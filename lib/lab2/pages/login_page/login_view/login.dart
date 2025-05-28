import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/lab2/elements/background.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/custom_text_field.dart';
import 'package:mobile_labs/lab2/pages/login_page/cubit/login_cubit.dart';
import 'package:mobile_labs/lab2/pages/login_page/cubit/login_state.dart';
import 'package:mobile_labs/lab2/service/internet_service.dart';
import 'package:mobile_labs/lab2/validation/login_validation.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Background(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? size.width * 0.2 : 20,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    final cubit = context.read<LoginCubit>();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Увійдіть у свій акаунт',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          labelText: 'Логін',
                          controller: usernameController,
                          validator: (value) =>
                              LoginValidation.validateLogin(value!),
                          onChanged: cubit.updateLogin,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          labelText: 'Пароль',
                          obscureText: true,
                          controller:passwordController,
                          validator: (value) =>
                              LoginValidation.validatePassword(value!),
                          onChanged: cubit.updatePassword,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final network = Provider.of<NetworkProvider>(
                              context,
                              listen: false,
                            );
                            if (!network.isConnected) {
                              _showError(
                                context,
                                'Немає підключення до Інтернету',
                              );
                              return;
                            }

                            if (_formKey.currentState!.validate()) {
                              cubit.submitLogin(
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                ),
                                (msg) => _showError(context, msg),
                              );
                            }
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
                            'Увійти',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/registration');
                          },
                          child: const Text(
                            'Не маєте акаунта? Зареєструватися',
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
