class DeviceModel {
  final String iconOption;
  final String label;
  final int outlet;
  final bool isSelected;
  final String roomName; // NEW FIELD

  DeviceModel({
    required this.iconOption,
    required this.label,
    required this.outlet,
    required this.roomName,
    this.isSelected = false,
  });

  DeviceModel copyWith({
    String? iconOption,
    String? label,
    int? outlet,
    bool? isSelected,
    String? roomName,
  }) {
    return DeviceModel(
      iconOption: iconOption ?? this.iconOption,
      label: label ?? this.label,
      outlet: outlet ?? this.outlet,
      isSelected: isSelected ?? this.isSelected,
      roomName: roomName ?? this.roomName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': label,
      'icon': iconOption,
      'isOn': isSelected ? 1 : 0,
      'outlet': outlet,
      'roomName': roomName,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      label: map['name'] ?? '',
      iconOption: map['icon'] ?? '',
      isSelected: map['isOn'] ?? '',
      outlet: map['outlet'] ?? 0,
      roomName: map['roomName'] ?? '',
    );
  }
}
