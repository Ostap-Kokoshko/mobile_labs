import 'package:mobile_labs/lab2/elements/functions/home_controller.dart';
import 'package:mobile_labs/lab2/service/mqtt_service.dart';

MQTTService initMQTT(HomeController controller) {
  return MQTTService(
    username: 'My_Cred',
    password: 'MyCred1234',
    mqttBroker: '28c5545e26094092b6785f4d24098c1f.s1.eu.hivemq.cloud',
    topics: ['home/temperature', 'home/humidity'],
    onMessageReceived: (topic, message) {
      final double? value = double.tryParse(message.trim());
      if (value == null) return;

      switch (topic) {
        case 'home/temperature':
          controller.updateTemperature(value);
          break;
        case 'home/humidity':
          controller.updateHumidity(value);
          break;
      }
    },
  );
}
