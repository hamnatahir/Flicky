import 'package:flutter/material.dart';
import '../models/device.model.dart';

class DeviceTypeSelectionVM extends ChangeNotifier {
  List<DeviceModel> _deviceTypes;

  DeviceTypeSelectionVM(this._deviceTypes);

  List<DeviceModel> get deviceTypes => _deviceTypes;

  void onSelectedDeviceType(DeviceModel selectedType) {
    _deviceTypes = [
      for (var item in _deviceTypes)
        item.copyWith(isSelected: selectedType == item)
    ];
    notifyListeners();
  }

  DeviceModel? getSelectedDeviceType() {
    try {
      return _deviceTypes.firstWhere((e) => e.isSelected);
    } catch (_) {
      return null;
    }
  }
}
