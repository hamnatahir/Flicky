import 'package:flicky/features/devices/presentation/models/device.model.dart';

class RoomModel {
  final String name;
  final List<DeviceModel> devices; // updated to hold full DeviceModel objects

  RoomModel({
    required this.name,
    this.devices = const [],
  });

  RoomModel copyWith({
    String? name,
    List<DeviceModel>? devices,
  }) {
    return RoomModel(
      name: name ?? this.name,
      devices: devices ?? this.devices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // Convert devices to list of maps for storage (if needed)
      'devices': devices.map((d) => d.toMap()).toList(),
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      name: map['name'] ?? '',
      devices: map['devices'] != null
          ? List<DeviceModel>.from(
          (map['devices'] as List).map((d) => DeviceModel.fromMap(d)))
          : [],
    );
  }
}
