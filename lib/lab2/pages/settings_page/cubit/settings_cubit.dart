import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/alerts.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/message_handler.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/serial_editor_dialog.dart';
import 'package:mobile_labs/lab2/pages/settings_page/cubit/settings_state.dart';
import 'package:mobile_labs/lab2/service/mqtt_device_service.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final MqttService mqtt;

  SettingsCubit(this.mqtt) : super(SettingsState.initial());

  void connect(BuildContext context) async {
    await mqtt.connect(
          (topic, payload) => _handleMessage(context, topic, payload),
          () => emit(state.copyWith(connected: true)),
          () => emit(state.copyWith(connected: false)),
    );
  }

  void _handleMessage(BuildContext context, String topic, String payload) {
    debugPrint('MQTT отримано: $payload');
    handleMqttMessage(
      context: context,
      topic: topic,
      payload: payload,
      setDeviceInfo: (serial, device, loaded) {
        emit(state.copyWith(
          receivedSerial: serial,
          deviceId: device,
          infoLoaded: loaded,
        ),);
      },
      showSerialEditor: () => showSerialEditorDialog(
        context,
        onSubmitted: sendToHardware,
      ),
      showError: (msg) => showErrorDialog(context, msg),
    );
  }

  void sendCredentials() {
    mqtt.publish('device/request', '{"user":"My_Cred","pass":"MyCred1234"}');
  }

  void requestDeviceInfo() {
    mqtt.publish('device/info_request', '{"request":"info"}');
  }

  void setScannedData(String data) {
    emit(state.copyWith(scannedData: data));
    sendCredentials();
  }

  void sendToHardware(String serial) {
    mqtt.publish('device/set_serial', '{"serial":"$serial"}');
  }

  void disconnect() {
    mqtt.disconnect();
  }
}
