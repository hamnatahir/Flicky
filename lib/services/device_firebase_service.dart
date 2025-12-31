import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/devices/presentation/models/device.model.dart';

class DeviceFirebaseService {
  final CollectionReference _deviceRef =
  FirebaseFirestore.instance.collection('devices');

  Future<void> addDevice(DeviceModel device) async {
    await _deviceRef.add(device.toMap());
  }

  Future<String> addDeviceAndGetId(DeviceModel device) async {
    final docRef = await _deviceRef.add(device.toMap());
    return docRef.id;
  }

  Future<List<DeviceModel>> getDevices() async {
    final snapshot = await _deviceRef.get();
    return snapshot.docs
        .map((doc) => DeviceModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getDevicesWithIds() async {
    final snapshot = await _deviceRef.get();
    return snapshot.docs.map((doc) {
      return {
        'device': DeviceModel.fromMap(doc.data() as Map<String, dynamic>),
        'docId': doc.id,
      };
    }).toList();
  }

  Future<void> deleteDevice(String docId) async {
    await _deviceRef.doc(docId).delete();
  }

  Future<void> updateDeviceStatus(String docId, bool isOn) async {
    await _deviceRef.doc(docId).update({'isOn': isOn});
  }
}
