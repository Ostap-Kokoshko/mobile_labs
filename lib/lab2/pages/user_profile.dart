import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/buttons/delete_account_button.dart';
import 'package:mobile_labs/lab2/elements/buttons/profile_logout_button.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/edit_user_dialog.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/network_status_bar.dart';
import 'package:mobile_labs/lab2/elements/functions/profile_page_controller.dart';
import 'package:mobile_labs/lab2/elements/user_profile_info.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();
  String _email = '';
  String _login = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _controller.loadUserData();
    setState(() {
      _email = userData['email'] ?? '';
      _login = userData['login'] ?? '';
    });
  }

  Future<void> _saveUserData(String login, String email) async {
    setState(() {
      _login = login;
      _email = email;
    });
    await _controller.saveUserData(email, login);
  }

  void _editUserData() {
    showDialog<void>(
      context: context,
      builder: (_) => EditUserDialog(
        login: _login,
        email: _email,
        onSave: _saveUserData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth * 0.05;
    final avatarSize = screenWidth * 0.15;
    final iconSize = screenWidth * 0.12;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Профіль користувача',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _editUserData,
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
                    UserInfo(label: "Ім'я користувача:", value: _login),
                    UserInfo(label: 'Email:', value: _email),
                    const SizedBox(height: 20),
                    LogoutButton(screenWidth: screenWidth),
                    const SizedBox(height: 10),
                    DeleteAccountButton(
                      controller: _controller,
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
