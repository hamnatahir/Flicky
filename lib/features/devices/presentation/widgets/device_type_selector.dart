// lib/features/devices/presentation/widgets/device_type_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.model.dart';
import '../providers/add_device_providers.dart';
import 'package:flicky/helpers/device_icon_mapper.dart';

class DeviceTypeSelector extends StatelessWidget {
  final DeviceTypeSelectionVM deviceTypeVM;

  const DeviceTypeSelector({required this.deviceTypeVM, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: deviceTypeVM.deviceTypes.map((device) {
        final isSelected = device.isSelected;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(getDeviceIcon(device.iconOption), size: 24),
              const SizedBox(width: 8),
              Text(device.label),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => deviceTypeVM.selectDeviceType(device),
        );
      }).toList(),
    );
  }
}
