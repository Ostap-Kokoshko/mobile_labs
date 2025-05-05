import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/alerts.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/device_info_table.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/message_handler.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/qr_scanner_dialog.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/serial_editor_dialog.dart';
import 'package:mobile_labs/lab2/service/mqtt_device_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final mqtt = MqttService();
  bool connected = false;
  String serialNumber = '';
  String scannedData = '';
  String? receivedSerial;
  String? deviceId;
  bool infoLoaded = false;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    await mqtt.connect(_handleMessage, () {
      setState(() => connected = true);
    }, () {
      setState(() => connected = false);
    }).catchError((Object e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(context, 'Не вдалося підключитися до MQTT: $e');
      });
    });
  }

  void _handleMessage(String topic, String payload) {
    debugPrint('MQTT отримано: $payload');
    handleMqttMessage(
      context: context,
      topic: topic,
      payload: payload,
      setDeviceInfo: (serial, device, loaded) {
        setState(() {
          receivedSerial = serial;
          deviceId = device;
          infoLoaded = loaded;
        });
      },
      showSerialEditor: _showSerialEditor,
      showError: (msg) => showErrorDialog(context, msg),
    );
  }

  void _requestDeviceInfo() {
    mqtt.publish('device/info_request', '{"request":"info"}');
  }

  void _openQRScanner() {
    showQRScannerDialog(
      context,
      onScanned: (data) {
        setState(() => scannedData = data);
        _sendCredentials();
      },
    );
  }

  void _sendCredentials() {
    mqtt.publish('device/request', '{"user":"My_Cred","pass":"MyCred1234"}');
  }

  void _sendToHardware(String serial) {
    mqtt.publish('device/set_serial', '{"serial":"$serial"}');
    showSuccessDialog(context, "Серійник '$serial' надіслано");
  }

  void _showSerialEditor() {
    showSerialEditorDialog(context, onSubmitted: _sendToHardware);
  }

  @override
  void dispose() {
    mqtt.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              connected ? 'MQTT зʼєднано' : 'MQTT не зʼєднано',
              style: TextStyle(color: connected ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code),
              label: const Text('Сканувати QR для налаштування'),
              onPressed: connected ? _openQRScanner : null,
            ),
            ElevatedButton(
              onPressed: _requestDeviceInfo,
              child: const Text('Глянути дані пристроя'),
            ),
            if (infoLoaded)
              DeviceInfoTable(
                serial: receivedSerial,
                device: deviceId,
              ),
          ],
        ),
      ),
    );
  }
}
