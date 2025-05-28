import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/lab2/elements/buttons/delete_account_button.dart';
import 'package:mobile_labs/lab2/elements/buttons/profile_logout_button.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/edit_user_dialog.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/network_status_bar.dart';
import 'package:mobile_labs/lab2/elements/user_profile_info.dart';
import 'package:mobile_labs/lab2/pages/user_page/cubit/user_cubit.dart';
import 'package:mobile_labs/lab2/pages/user_page/cubit/user_state.dart';
import 'package:mobile_labs/lab2/storage/user_storage_secure.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _editUserData(BuildContext context, String login, String email) {
    showDialog<void>(
      context: context,
      builder: (_) => EditUserDialog(
        login: login,
        email: email,
        onSave: (newLogin, newEmail) {
          context.read<ProfileCubit>().saveUserData(newLogin, newEmail);
        },
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: const Text('Видалити акаунт'),
          content: const Text('Ви впевнені, що хочете видалити акаунт?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(alertContext).pop(),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(alertContext).pop();
                context.read<ProfileCubit>().deleteAccount();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Видалити'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(UserStorageSecure()),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final screenWidth = MediaQuery.of(context).size.width;
          final paddingValue = screenWidth * 0.05;
          final avatarSize = screenWidth * 0.15;
          final iconSize = screenWidth * 0.12;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                'Профіль користувача',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () =>
                      _editUserData(context, state.login, state.email),
                ),
              ],
            ),
            body: Column(
              children: [
                const NetworkStatusBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(paddingValue),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: avatarSize,
                              backgroundColor: Colors.orange,
                              child: Icon(
                                Icons.person,
                                size: iconSize,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          UserInfo(
                            label: "Ім'я користувача:",
                            value: state.login,
                          ),
                          UserInfo(label: 'Email:', value: state.email),
                          const SizedBox(height: 20),
                          LogoutButton(screenWidth: screenWidth),
                          const SizedBox(height: 10),
                          DeleteAccountButton(
                            screenWidth: screenWidth,
                            onDelete: () => _confirmDeleteAccount(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
