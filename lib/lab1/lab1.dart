import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Emotional Damage 😲';
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: EmotionInputScreen(title: appTitle),
    );
  }
}

class EmotionInputScreen extends StatefulWidget {
  const EmotionInputScreen({required this.title, super.key});
  final String title;

  @override
  State<EmotionInputScreen> createState() => _EmotionInputScreenState();
}

class _EmotionInputScreenState extends State<EmotionInputScreen> {
  String _emoji = '🙂';
  int _selectedIndex = 0;

  final TextEditingController _controller = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setEmoji() {
    setState(() {
      switch (_controller.text.toLowerCase()) {
        case 'happy':
        case 'joy':
          _emoji = '😃';
          break;
        case 'sad':
        case 'unhappy':
          _emoji = '😢';
          break;
        case 'angry':
        case 'mad':
          _emoji = '😡';
          break;
        case 'love':
        case 'heart':
          _emoji = '❤️';
          break;
        case 'surprised':
        case 'shock':
          _emoji = '😲';
          break;
        default:
          Fluttertoast.showToast(
            msg: 'Emotion not recognized!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          _emoji = '🙂';
      }
    });
  }

  void _logout() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: List.generate(10, (row) =>
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(8, (col) =>
                          Text(
                            _emoji,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black26,
                            ),
                          ),
                      ),
                    ),
                  ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Text(
                _emoji,
                style: const TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your emotion',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _setEmoji,
                      child: const Text('Confirm Emotion'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _emoji,
                style: const TextStyle(fontSize: 50),
              ),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Under development')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
