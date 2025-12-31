import 'package:flutter/material.dart';
import '../models/device.model.dart';
import 'package:flicky/helpers/device_icon_mapper.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DeviceRowItem extends StatelessWidget {
  final DeviceModel device;
  final String docId;
  final void Function(DeviceModel device, String docId)? onTapDevice;

  const DeviceRowItem({
    super.key,
    required this.device,
    required this.docId,
    this.onTapDevice,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = device.isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: selectedColor.withOpacity(0.15),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (onTapDevice != null) onTapDevice!(device, docId);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  getDeviceIcon(device.iconOption),
                  size: 28,
                  color: selectedColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    device.label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedColor,
                    ),
                  ),
                ),
                if (device.isSelected)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0),
    );
  }
}
