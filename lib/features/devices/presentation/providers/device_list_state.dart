import 'package:flutter/material.dart';
import '../models/device.model.dart';
import 'package:flicky/services/device_firebase_service.dart';

class DeviceListState extends ChangeNotifier {
  final DeviceFirebaseService _service = DeviceFirebaseService();

  List<DeviceModel> _devices = [];
  List<String> _docIds = [];

  List<DeviceModel> get devices => _devices;
  List<String> get docIds => _docIds;

  Future<void> loadDevices() async {
    final snapshot = await _service.getDevicesWithIds();
    _devices = snapshot.map((e) => e['device'] as DeviceModel).toList();
    _docIds = snapshot.map((e) => e['docId'] as String).toList();
    notifyListeners();
  }

  Future<void> addDevice(DeviceModel device) async {
    final docId = await _service.addDeviceAndGetId(device);
    _devices.add(device);
    _docIds.add(docId);
    notifyListeners();
  }

  Future<void> deleteDevice(String docId) async {
    await _service.deleteDevice(docId);
    final index = _docIds.indexOf(docId);
    if (index >= 0) {
      _docIds.removeAt(index);
      _devices.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> updateDeviceStatus(String docId, bool isOn) async {
    final index = _docIds.indexOf(docId);
    if (index >= 0) {
      _devices[index] = _devices[index].copyWith(isSelected: isOn);
      await _service.updateDeviceStatus(docId, isOn);
      notifyListeners();
    }
  }
}
