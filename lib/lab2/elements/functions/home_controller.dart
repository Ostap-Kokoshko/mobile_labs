import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/lab2/elements/functions/home_widgets.dart';

class HomeController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final ValueNotifier<double> temperature = ValueNotifier(0);
  final ValueNotifier<double> humidity = ValueNotifier(0);
  final ValueNotifier<bool> isLockActive = ValueNotifier(false);
  final ValueNotifier<bool> isSmokeDetected = ValueNotifier(false);

  String lockKey = 'isLockActive';
  String smokeKey = 'isSmokeDetected';
  String logInKey = 'isLoggedIn';

  HomeController() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final lockStatus = await _secureStorage.read(key: lockKey);
    final smokeStatus = await _secureStorage.read(key: smokeKey);

    if (lockStatus != null) isLockActive.value = lockStatus == 'true';
    if (smokeStatus != null) isSmokeDetected.value = smokeStatus == 'true';
  }

  Future<void> _savePreference(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  void toggleLock() {
    isLockActive.value = !isLockActive.value;
    _savePreference(lockKey, isLockActive.value);
  }

  void toggleSmoke() {
    isSmokeDetected.value = !isSmokeDetected.value;
    _savePreference(smokeKey, isSmokeDetected.value);
  }

  void updateTemperature(double newValue) {
    temperature.value = newValue;
  }

  void updateHumidity(double newValue) {
    humidity.value = newValue;
  }

  Future<void> logout(BuildContext context) async {
    await _secureStorage.delete(key: logInKey);
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  Widget buildInfoCard(
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
          ValueListenableBuilder<double>(
            valueListenable: temperature,
            builder: (_, value, __) {
              return InfoRow(
                icon: Icons.thermostat_outlined,
                label: 'Температура:',
                value: '${value.toStringAsFixed(1)}°C',
                iconColor: Colors.orange,
              );
            },
          ),
          const SizedBox(height: 15),
          ValueListenableBuilder<double>(
            valueListenable: humidity,
            builder: (_, value, __) {
              return InfoRow(
                icon: Icons.water_drop_outlined,
                label: 'Вологість:',
                value: '${value.toStringAsFixed(1)}%',
                iconColor: Colors.blue,
              );
            },
          ),
          const SizedBox(height: 15),
          ValueListenableBuilder<bool>(
            valueListenable: isLockActive,
            builder: (_, value, __) {
              return ToggleRow(
                icon: Icons.lock,
                label: 'Замок:',
                value: value,
                activeText: 'Включений',
                inactiveText: 'Вимкнений',
                activeColor: Colors.green,
                inactiveColor: Colors.red,
                onToggle: onToggleLock,
              );
            },
          ),
          const SizedBox(height: 15),
          ValueListenableBuilder<bool>(
            valueListenable: isSmokeDetected,
            builder: (_, value, __) {
              return ToggleRow(
                icon: Icons.smoke_free,
                label: 'Дим:',
                value: value,
                activeText: 'Наявний',
                inactiveText: 'Відсутній',
                activeColor: Colors.green,
                inactiveColor: Colors.red,
                onToggle: onToggleSmoke,
              );
            },
          ),
        ],
      ),
    );
  }
}
