import 'package:flutter/material.dart';
import '../repositories/devices.repository.dart';
import '../repositories/outlets.repository.dart';
import '../models/device.model.dart';
import '../models/outlet.model.dart';

// Device List State
class DeviceListState extends ChangeNotifier {
  List<DeviceModel> _devices = [];

  List<DeviceModel> get devices => _devices;

  void initialize(List<DeviceModel> deviceList) {
    _devices = deviceList;
    notifyListeners();
  }

  void addDevice(DeviceModel device) {
    _devices.add(device);
    notifyListeners();
  }

  void removeDevice(DeviceModel device) {
    _devices.remove(device);
    notifyListeners();
  }

  void toggleDevice(DeviceModel selectedDevice) {
    _devices = _devices.map((device) {
      if (device == selectedDevice) {
        return device.copyWith(isSelected: !device.isSelected);
      }
      return device;
    }).toList();
    notifyListeners();
  }

  bool deviceExists(String deviceName) {
    return _devices.any(
            (d) => d.label.trim().toLowerCase() == deviceName.trim().toLowerCase());
  }
}

// Selected Device State
class SelectedDeviceState extends ChangeNotifier {
  DeviceModel? _selectedDevice;
  DeviceModel? get selectedDevice => _selectedDevice;

  void selectDevice(DeviceModel device) {
    _selectedDevice = device;
    notifyListeners();
  }

  void clearSelection() {
    _selectedDevice = null;
    notifyListeners();
  }
}

// Device Toggle State
class DeviceToggleState extends ChangeNotifier {
  bool _isToggling = false;
  bool get isToggling => _isToggling;

  void setToggling(bool val) {
    _isToggling = val;
    notifyListeners();
  }
}

// Outlet List State
class OutletListState extends ChangeNotifier {
  List<OutletModel> _outlets = [];
  OutletModel? _selectedOutlet;

  List<OutletModel> get outlets => _outlets;
  OutletModel? get selectedOutlet => _selectedOutlet;

  void initialize(List<OutletModel> outletList) {
    _outlets = outletList;
    notifyListeners();
  }

  void selectOutlet(OutletModel outlet) {
    _selectedOutlet = outlet;
    notifyListeners();
  }
}

// Repositories
final deviceRepository = DevicesRepository();
final outletsRepository = OutletsRepository();
