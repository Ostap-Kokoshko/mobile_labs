import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/custom_drawer.dart';
import 'package:mobile_labs/lab2/elements/functions/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'SMART LOCK',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? screenSize.width * 0.2 : 20,
              vertical: 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Ласкаво просимо до\nSMART LOCK',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                ValueListenableBuilder(
                  valueListenable: _controller.temperature,
                  builder: (_, __, ___) {
                    return ValueListenableBuilder(
                      valueListenable: _controller.humidity,
                      builder: (_, __, ___) {
                        return ValueListenableBuilder(
                          valueListenable: _controller.isLockActive,
                          builder: (_, __, ___) {
                            return ValueListenableBuilder(
                              valueListenable: _controller.isSmokeDetected,
                              builder: (_, __, ___) {
                                return _controller.buildInfoCard(
                                  _toggleLock,
                                  _toggleSmoke,
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: isTablet ? 50 : 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Перейти до профілю',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _controller.logout(context),
                  child: const Text(
                    'Вийти',
                    style: TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleLock() {
    _controller.toggleLock();
  }

  void _toggleSmoke() {
    _controller.toggleSmoke();
  }
}
