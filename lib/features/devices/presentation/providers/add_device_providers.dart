import 'package:flutter/material.dart';
import 'package:flicky/features/devices/presentation/models/outlet.model.dart';
import 'package:flicky/features/devices/presentation/models/device.model.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';

class AddDeviceForm extends StatefulWidget {
  final List<OutletModel> outletList;
  final void Function(DeviceModel) onSave;

  const AddDeviceForm({
    required this.outletList,
    required this.onSave,
    super.key,
  });

  @override
  State<AddDeviceForm> createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final TextEditingController _deviceNameController =
  TextEditingController();

  int? _selectedDeviceIndex;

  final List<Map<String, dynamic>> deviceTypes = [
    {'key': 'ac', 'label': 'Air\nConditioning', 'icon': Icons.ac_unit},
    {'key': 'personal', 'label': 'Personal\nItem', 'icon': FlickyIcons.hairdrier},
    {'key': 'fan', 'label': 'Fan', 'icon': FlickyIcons.fan},
    {'key': 'light', 'label': 'Light\nFixture', 'icon': Icons.lightbulb},
    {'key': 'oven', 'label': 'Oven', 'icon': FlickyIcons.oven},
    {'key': 'microwave', 'label': 'Microwave', 'icon': FlickyIcons.microwave},
    {'key': 'heater', 'label': 'Heater', 'icon': FlickyIcons.heater},
    {'key': 'other', 'label': 'Other', 'icon': Icons.device_unknown},
  ];

  void showAlert(String message) {
    ScaffoldMessenger.of(
      context.findRootAncestorStateOfType<ScaffoldState>()!.context,
    ).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add Device",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Device Name
          TextField(
            controller: _deviceNameController,
            decoration: const InputDecoration(
              labelText: 'Device Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Device Type Selector
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: deviceTypes.length,
              itemBuilder: (context, index) {
                final device = deviceTypes[index];
                final isSelected = _selectedDeviceIndex == index;

                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedDeviceIndex = index),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.25)
                          : Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          device['icon'],
                          size: 40,
                          color: isSelected
                              ? Theme.of(context)
                              .colorScheme
                              .primary
                              : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          device['label'],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if (_deviceNameController.text.trim().isEmpty) {
                  showAlert("Please enter device name");
                  return;
                }

                if (_selectedDeviceIndex == null) {
                  showAlert("Please select device type");
                  return;
                }

                final selectedType =
                deviceTypes[_selectedDeviceIndex!];

                final device = DeviceModel(
                  label: _deviceNameController.text.trim(),
                  iconOption: selectedType['key'], // meaningful string
                  isSelected: false,
                  outlet: widget.outletList.isNotEmpty
                      ? int.parse(widget.outletList[0].id)
                      : 0,
                );

                widget.onSave(device);
                Navigator.of(context).pop();
              },
              child: const Text("Save Device"),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
