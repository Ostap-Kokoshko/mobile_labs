import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/service/internet_service.dart';
import 'package:provider/provider.dart';

class NetworkStatusBar extends StatelessWidget {
  const NetworkStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (context, networkProvider, _) {
        return Container(
          width: double.infinity,
          color: networkProvider.isConnected ? Colors.green : Colors.red,
          padding: const EdgeInsets.all(8),
          child: Text(
            networkProvider.isConnected
                ? 'Підключення до інтернету встановлено'
                : 'Немає підключення до інтернету',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
