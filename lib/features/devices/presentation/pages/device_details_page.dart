import 'package:flutter/material.dart';
import '../widgets/device_details_panel.dart';
import '../models/device.model.dart';

class DeviceDetailsPage extends StatelessWidget {
  static const String route = '/device_details';
  final DeviceModel device;
  final String docId;
  final VoidCallback onDeleted;

  const DeviceDetailsPage({
    super.key,
    required this.device,
    required this.docId,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DeviceDetailsPanel(
            device: device,
            docId: docId,
            onDeleted: onDeleted,
          ),
        ),
      ),
    );
  }
}
