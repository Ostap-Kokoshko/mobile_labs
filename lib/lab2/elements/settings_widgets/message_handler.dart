import 'dart:convert';
import 'package:flutter/material.dart';

typedef SetDeviceInfo = void Function(String?, String?, bool);
typedef ShowSerialEditor = void Function();
typedef ShowError = void Function(String);

void handleMqttMessage({
  required BuildContext context,
  required String topic,
  required String payload,
  required SetDeviceInfo setDeviceInfo,
  required ShowSerialEditor showSerialEditor,
  required ShowError showError,
}) {
  try {
    final decoded = jsonDecode(payload);

    if (topic == 'device/info_response') {
      setDeviceInfo(
        decoded['serial'] as String?,
        decoded['device'] as String?,
        true,
      );
    } else if (decoded is Map) {
      if (decoded['status'] == 'success') {
        showSerialEditor();
      } else if (decoded['serial'] != null && decoded['device'] != null) {
        setDeviceInfo(
          decoded['serial'] as String,
          decoded['device'] as String,
          true,
        );
      } else {
        showError('Невірні креденшинали');
      }
    }
  } catch (e) {
    debugPrint('Помилка декоду JSON: $e');
  }
}
