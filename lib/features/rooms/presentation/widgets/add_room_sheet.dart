import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flicky/features/rooms/presentation/models/room.model.dart';
import 'package:flicky/features/rooms/presentation/providers/room_list_state.dart';

class AddRoomSheet extends StatelessWidget {
  const AddRoomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const AddRoomForm(),
    );
  }
}

class AddRoomForm extends StatefulWidget {
  const AddRoomForm({super.key});

  @override
  State<AddRoomForm> createState() => _AddRoomFormState();
}

class _AddRoomFormState extends State<AddRoomForm> {
  final TextEditingController _roomNameController = TextEditingController();
  String? _nameError;

  void _validateAndSave() async {
    setState(() {
      _nameError = _roomNameController.text.trim().isEmpty ? "Please enter room name" : null;
    });

    if (_nameError == null) {
      final name = _roomNameController.text.trim();
      final provider = context.read<RoomListState>();
      try {
        await provider.addRoom(RoomModel(name: name));

        // Success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$name saved successfully!"),
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.of(context).pop(); // close bottom sheet
      } catch (e) {
        // Error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save room: $e"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add Room",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _roomNameController,
            decoration: InputDecoration(
              labelText: 'Room Name',
              border: const OutlineInputBorder(),
              errorText: _nameError,
            ),
            onSubmitted: (_) => _validateAndSave(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAndSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Save Room",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
