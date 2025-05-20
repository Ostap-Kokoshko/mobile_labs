import 'package:flutter/material.dart';

class DeviceInfoTable extends StatelessWidget {
  final String? serial;
  final String? device;

  const DeviceInfoTable({
    required this.serial,
    required this.device,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(1.1),
            1: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Серійний номер'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(serial ?? '-'),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Імʼя пристрою'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(device ?? '-'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
