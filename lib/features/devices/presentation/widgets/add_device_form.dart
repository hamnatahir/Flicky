import 'package:flutter/material.dart';
import '../models/device.model.dart';
import '../models/outlet.model.dart';
import 'package:flicky/features/rooms/presentation/models/room.model.dart';
import 'package:flicky/features/rooms/presentation/providers/room_list_state.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController _deviceNameController = TextEditingController();
  int? _selectedDeviceIndex;
  RoomModel? _selectedRoom;

  String? _nameError;
  String? _typeError;
  String? _roomError;

  final List<Map<String, dynamic>> deviceTypes = [
    {'key': 'ac', 'label': 'conditioning', 'icon': Icons.ac_unit},
    {'key': 'personal', 'label': 'personal items', 'icon': FlickyIcons.hairdrier},
    {'key': 'fan', 'label': 'Fans', 'icon': FlickyIcons.fan},
    {'key': 'light', 'label': 'Lights', 'icon': Icons.lightbulb},
    {'key': 'oven', 'label': 'Kitchen', 'icon': FlickyIcons.oven},
    {'key': 'microwave', 'label': 'Electronics', 'icon': FlickyIcons.microwave},
    {'key': 'heater', 'label': 'Heater', 'icon': FlickyIcons.heater},
    {'key': 'other', 'label': 'Other', 'icon': Icons.device_unknown},
  ];

  void _validateAndSave() {
    setState(() {
      _nameError = _deviceNameController.text.trim().isEmpty ? "Please enter device name" : null;
      _typeError = _selectedDeviceIndex == null ? "Please select device type" : null;
      _roomError = _selectedRoom == null ? "Please select a room" : null;
    });

    if (_nameError == null && _typeError == null && _roomError == null) {
      final selectedType = deviceTypes[_selectedDeviceIndex!];

      final device = DeviceModel(
        label: _deviceNameController.text.trim(),
        iconOption: selectedType['key'],
        outlet: widget.outletList.isNotEmpty
            ? int.tryParse(widget.outletList[0].id) ?? 0
            : 0,
        roomName: _selectedRoom!.name,
        isSelected: false,
      );

      widget.onSave(device);

      // Show snackbar for 2 seconds
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${device.label} added successfully!'),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<RoomListState>().rooms;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text("Add Device", style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          // Device Name
          TextField(
            controller: _deviceNameController,
            decoration: InputDecoration(
              labelText: 'Device Name',
              errorText: _nameError,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Device Type Selection
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: deviceTypes.length,
              itemBuilder: (context, index) {
                final item = deviceTypes[index];
                final selected = _selectedDeviceIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDeviceIndex = index),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary.withOpacity(0.25)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], size: 36),
                        const SizedBox(height: 8),
                        Text(item['label'], textAlign: TextAlign.center),
                        if (_typeError != null && selected == false && index == deviceTypes.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _typeError!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Room Selection
          DropdownButtonFormField<RoomModel>(
            value: _selectedRoom,
            hint: const Text("Select Room"),
            dropdownColor: theme.colorScheme.background,
            items: rooms.isNotEmpty
                ? rooms.map((room) {
              return DropdownMenuItem(
                value: room,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    color: room == _selectedRoom
                        ? Colors.grey.withOpacity(0.2) // Only dropdown row highlight
                        : Colors.transparent,
                  ),
                  child: Text(
                    room.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList()
                : [
              DropdownMenuItem(
                value: null,
                child: Text(
                  "Please add new rooms",
                  style: TextStyle(
                      color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                ),
              )
            ],
            selectedItemBuilder: (context) {
              // Show selected room text clearly in dropdown field
              return rooms.map((room) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    room.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList();
            },
            onChanged: rooms.isNotEmpty ? (val) => setState(() => _selectedRoom = val) : null,
            decoration: InputDecoration(
              errorText: _roomError,
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
              ),
              onPressed: _validateAndSave,
              child: const Text("Save Device"),
            ),
          ),
        ],
      ),
    );
  }
}
