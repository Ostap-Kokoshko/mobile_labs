import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/custom_drawer.dart';
import 'package:mobile_labs/lab2/elements/custom_fields/home_content.dart';
import 'package:mobile_labs/lab2/elements/functions/home_controller.dart';
import 'package:mobile_labs/lab2/service/internet_service.dart';
import 'package:mobile_labs/lab2/service/mqtt_initializer.dart';
import 'package:mobile_labs/lab2/service/mqtt_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = HomeController();
  late MQTTService _mqttService;

  @override
  void initState() {
    super.initState();
    _mqttService = initMQTT(_controller);
    _mqttService.connect();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final net = Provider.of<NetworkProvider>(context, listen: false);
      if (!net.isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Немає Інтернету. Дані можуть бути застарілими'),
          ),
        );
      }
    });

    Provider.of<NetworkProvider>(context, listen: false)
        .addListener(_handleNetworkChange);
  }

  void _handleNetworkChange() {
    final network = Provider.of<NetworkProvider>(context, listen: false);
    network.isConnected
        ? _mqttService.connect()
        : _mqttService.mqttDisconnect();
  }

  @override
  void dispose() {
    _mqttService.mqttDisconnect();
    Provider.of<NetworkProvider>(context, listen: false)
        .removeListener(_handleNetworkChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<NetworkProvider>(
        builder: (context, network, _) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600
                    ? MediaQuery.of(context).size.width * 0.2
                    : 20,
                vertical: 20,
              ),
              child: HomeContent(
                controller: _controller,
                hasConnection: network.isConnected,
                onToggleLock: _controller.toggleLock,
                onToggleSmoke: _controller.toggleSmoke,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
