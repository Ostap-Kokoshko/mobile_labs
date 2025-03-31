import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/lab2/elements/functions/home_widgets.dart';

class HomeController {
  double temperature = 22.5;
  double humidity = 60.2;
  bool isLockActive = false;
  bool isSmokeDetected = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  HomeController() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final String? lockStatus = await _secureStorage.read(key: 'isLockActive');
    final String? smokeStatus =
    await _secureStorage.read(key: 'isSmokeDetected');

    if (lockStatus != null) isLockActive = lockStatus == 'true';
    if (smokeStatus != null) isSmokeDetected = smokeStatus == 'true';
  }

  Future<void> _savePreference(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  void toggleLock() {
    isLockActive = !isLockActive;
    _savePreference('isLockActive', isLockActive);
  }

  void toggleSmoke() {
    isSmokeDetected = !isSmokeDetected;
    _savePreference('isSmokeDetected', isSmokeDetected);
  }

  Future<void> logout(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    await _secureStorage.delete(key: 'isLoggedIn');
  }

  Widget buildInfoCard(
      BuildContext context,
      VoidCallback onToggleLock,
      VoidCallback onToggleSmoke,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoRow(
            Icons.thermostat_outlined,
            'Температура:',
            '${temperature.toStringAsFixed(1)}°C',
            Colors.orange,
          ),
          const SizedBox(height: 15),
          buildInfoRow(
            Icons.water_drop_outlined,
            'Вологість:',
            '${humidity.toStringAsFixed(1)}%',
            Colors.blue,
          ),
          const SizedBox(height: 15),
          buildToggleRow(
            icon: Icons.lock,
            label: 'Замок:',
            value: isLockActive,
            activeText: 'Включений',
            inactiveText: 'Вимкнений',
            activeColor: Colors.green,
            inactiveColor: Colors.red,
            onToggle: onToggleLock,
          ),
          const SizedBox(height: 15),
          buildToggleRow(
            icon: Icons.smoke_free,
            label: 'Дим:',
            value: isSmokeDetected,
            activeText: 'Наявний',
            inactiveText: 'Відсутній',
            activeColor: Colors.green,
            inactiveColor: Colors.red,
            onToggle: onToggleSmoke,
          ),
        ],
      ),
    );
  }
}
