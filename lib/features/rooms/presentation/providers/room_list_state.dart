import 'package:flutter/material.dart';
import 'package:flicky/features/rooms/presentation/models/room.model.dart';
import 'package:flicky/services/room_firebase_service.dart';

class RoomListState extends ChangeNotifier {
  final RoomFirebaseService _service = RoomFirebaseService();

  List<RoomModel> _rooms = [];
  List<String> _docIds = [];

  List<RoomModel> get rooms => _rooms;
  List<String> get docIds => _docIds;

  Future<void> loadRooms() async {
    final snapshot = await _service.getRoomsWithIds(); // List<Map<String, dynamic>>

    _rooms = snapshot.map((e) => e['room'] as RoomModel).toList();
    _docIds = snapshot.map((e) => e['docId'] as String).toList();

    notifyListeners();
  }

  Future<void> addRoom(RoomModel room) async {
    await _service.addRoom(room);
    await loadRooms();
  }

  Future<void> deleteRoom(String docId) async {
    await _service.deleteRoom(docId);
    final index = _docIds.indexOf(docId);
    if (index >= 0) {
      _docIds.removeAt(index);
      _rooms.removeAt(index);
      notifyListeners();
    }
  }
}
