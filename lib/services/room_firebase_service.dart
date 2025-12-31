import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flicky/features/rooms/presentation/models/room.model.dart';

class RoomFirebaseService {
  final CollectionReference _roomsRef =
  FirebaseFirestore.instance.collection('rooms');

  Future<void> addRoom(RoomModel room) async {
    await _roomsRef.add(room.toMap());
  }

  Future<void> deleteRoom(String docId) async {
    await _roomsRef.doc(docId).delete();
  }

  Future<void> updateRoom(RoomModel room, String docId) async {
    await _roomsRef.doc(docId).update(room.toMap());
  }

  Future<List<Map<String, dynamic>>> getRoomsWithIds() async {
    final snapshot = await _roomsRef.get();
    return snapshot.docs.map((doc) {
      return {
        'room': RoomModel.fromMap(doc.data() as Map<String, dynamic>),
        'docId': doc.id,
      };
    }).toList();
  }
}
