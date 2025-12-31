import 'dart:convert';
import '../models/device.model.dart';

class DevicesRepository {
  // In-memory storage for devices
  List<DeviceModel> _deviceList = [];

  // Get list of saved devices
  Future<List<DeviceModel>> getListOfDevices() async {
    // Return a copy to prevent external modification
    return List<DeviceModel>.from(_deviceList);
  }

  // Save device list
  void saveDeviceList(List<DeviceModel> deviceList) {
    // Store a copy to prevent external modification
    _deviceList = List<DeviceModel>.from(deviceList);
  }
}
