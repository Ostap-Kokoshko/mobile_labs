import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/device_info_table.dart';
import 'package:mobile_labs/lab2/elements/settings_widgets/qr_scanner_dialog.dart';
import 'package:mobile_labs/lab2/pages/settings_page/cubit/settings_cubit.dart';
import 'package:mobile_labs/lab2/pages/settings_page/cubit/settings_state.dart';
import 'package:mobile_labs/lab2/service/mqtt_device_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = SettingsCubit(MqttService());
        cubit.connect(context);
        return cubit;
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();

          return Scaffold(
            appBar: AppBar(title: const Text('Налаштування')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    state.connected ? 'MQTT зʼєднано' : 'MQTT не зʼєднано',
                    style: TextStyle(
                      color: state.connected ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Сканувати QR для налаштування'),
                    onPressed: state.connected
                        ? () {
                      showQRScannerDialog(
                        context,
                        onScanned: cubit.setScannedData,
                      );
                    }
                        : null,
                  ),
                  ElevatedButton(
                    onPressed: cubit.requestDeviceInfo,
                    child: const Text('Глянути дані пристроя'),
                  ),
                  if (state.infoLoaded)
                    DeviceInfoTable(
                      serial: state.receivedSerial,
                      device: state.deviceId,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
