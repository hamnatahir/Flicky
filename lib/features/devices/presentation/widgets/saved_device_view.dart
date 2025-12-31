// saved_device_view.dart
import 'package:flutter/material.dart';

class SavedDeviceView extends StatelessWidget {
  const SavedDeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text('Saved Device', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
