import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef MessageHandler = void Function(String topic, String payload);

class MqttService {
  final client = MqttServerClient.withPort(
    '28c5545e26094092b6785f4d24098c1f.s1.eu.hivemq.cloud',
    'flutter_client',
    8883,
  );

  bool connected = false;

  Future<void> connect(
    MessageHandler onMessage,
    VoidCallback onConnected,
    VoidCallback onDisconnected,
  ) async {
    client.secure = true;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.setProtocolV311();
    client.onDisconnected = () {
      connected = false;
      onDisconnected();
    };
    client.onConnected = () {
      connected = true;
      onConnected();
    };
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs('My_Cred', 'MyCred1234')
        .startClean();

    try {
      await client.connect();
      client.subscribe('device/response', MqttQos.atLeastOnce);
      client.subscribe('device/info_response', MqttQos.atLeastOnce);
      client.updates!.listen((events) {
        final recMess = events[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final topic = events[0].topic;
        onMessage(topic, payload);
      });
    } catch (e) {
      rethrow;
    }
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder()..addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void disconnect() {
    client.disconnect();
  }
}
