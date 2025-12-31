import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.model.dart';
import 'package:flicky/helpers/device_icon_mapper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/device_list_state.dart';

class DeviceDetailsPanel extends StatefulWidget {
  final DeviceModel device;
  final String docId;
  final VoidCallback onDeleted; // Callback to notify deletion

  const DeviceDetailsPanel({
    super.key,
    required this.device,
    required this.docId,
    required this.onDeleted,
  });

  @override
  State<DeviceDetailsPanel> createState() => _DeviceDetailsPanelState();
}

class _DeviceDetailsPanelState extends State<DeviceDetailsPanel> {
  late DeviceModel device;

  @override
  void initState() {
    super.initState();
    device = widget.device;
  }

  Future<void> toggleDevice() async {
    final newValue = !device.isSelected;

    setState(() {
      device = device.copyWith(isSelected: newValue);
    });

    await context
        .read<DeviceListState>()
        .updateDeviceStatus(widget.docId, newValue);
  }

  Future<void> deleteDevice() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Device"),
        content: Text("Are you sure you want to delete '${device.label}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<DeviceListState>().deleteDevice(widget.docId);
      widget.onDeleted(); // Notify parent to remove from list
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = device.isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Room Name at top
                if (device.roomName.isNotEmpty)
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      device.roomName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700),
                    ).animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: -0.2, end: 0, duration: 300.ms),
                  ),

                // Device Icon
                Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                    getDeviceIcon(device.iconOption),
                    size: 100,
                    color: color,
                  ),
                ).animate()
                    .scaleXY(begin: 0.8, end: 1.0, duration: 500.ms)
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 16),

                // Device Label
                Text(
                  device.label,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: color, fontWeight: FontWeight.bold),
                ).animate()
                    .slideY(begin: 0.5, end: 0, duration: 400.ms)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 42),

                // Toggle Button
                GestureDetector(
                  onTap: toggleDevice,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 80,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: device.isSelected ? color : Colors.grey.shade300,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: device.isSelected
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate()
                      .scaleXY(begin: 0.9, end: 1.0, duration: 400.ms),
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: deleteDevice,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Delete Device',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
