import 'dart:async';
import 'dart:isolate';
import 'dart:math';

class PressureService {
  static Isolate? _isolate;
  static ReceivePort? _receivePort;

  static Future<void> start(void Function(double) onPressureUpdate) async {
    _receivePort = ReceivePort();
    _receivePort!.listen((message) {
      if (message is double) {
        onPressureUpdate(message);
      }
    });

    _isolate = await Isolate.spawn<_IsolateMessage>(
      _pressureIsolateEntry,
      _IsolateMessage(_receivePort!.sendPort),
    );
  }

  static void stop() {
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }

  static void _pressureIsolateEntry(_IsolateMessage message) {
    final sendPort = message.sendPort;
    final random = Random();

    Timer.periodic(const Duration(seconds: 10), (timer) {
      final pressure = 950 + random.nextDouble() * 100;
      sendPort.send(pressure);
    });
  }
}

class _IsolateMessage {
  final SendPort sendPort;
  _IsolateMessage(this.sendPort);
}
