import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/buttons/delete_account_button.dart';
import 'package:mobile_labs/lab2/elements/buttons/profile_logout_button.dart';
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

  Future<void> _saveUserData() async {
    await _controller.saveUserData(_email, _login);
    setState(() {});
  }

  void _editUserData() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
        TextEditingController(text: _login);
        final TextEditingController emailController =
        TextEditingController(text: _email);
        return AlertDialog(
          title: const Text('Редагувати профіль'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:
                const InputDecoration(labelText: 'Ім\'я користувача'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _login = nameController.text;
                  _email = emailController.text;
                });
                _saveUserData();
                Navigator.pop(context);
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _editUserData,
          ),
        ],
      ),
      body: SingleChildScrollView(
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
    );
  }
}
