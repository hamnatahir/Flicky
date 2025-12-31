import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flicky/features/rooms/presentation/providers/room_list_state.dart';
import 'package:flicky/features/devices/presentation/providers/device_list_state.dart';
import 'package:flicky/helpers/device_icon_mapper.dart';
import 'package:flicky/features/landing/presentations/pages/main_page_header.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';
import 'package:flicky/styles/style.dart';

class RoomsPage extends StatefulWidget {
  static const String route = '/rooms';
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  String? _selectedRoomId;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RoomListState>().loadRooms();
      context.read<DeviceListState>().loadDevices();
    });
  }

  void _showDeleteDialog(String docId, String roomName, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Room"),
        content: Text("Are you sure you want to delete '$roomName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final removedRoom = context.read<RoomListState>().rooms[index];
              final removedDocId = context.read<RoomListState>().docIds[index];
              context.read<RoomListState>().deleteRoom(removedDocId);
              _listKey.currentState?.removeItem(
                index,
                    (context, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: _buildRoomTile(removedRoom, removedDocId, index, shadow: false),
                ),
                duration: const Duration(milliseconds: 300),
              );
              setState(() {
                _selectedRoomId = null;
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomTile(room, String docId, int index, {bool shadow = true}) {
    final devices = context.read<DeviceListState>().devices;
    final roomDevices = devices.where((d) => d.roomName == room.name).toList();
    final isSelected = _selectedRoomId == docId;
    bool showTileDelete = isSelected;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tileBg = isDark ? Colors.grey[850] : Colors.grey[200];
    final textColor = isDark ? Colors.white : theme.colorScheme.primary;
    final iconColor = theme.colorScheme.primary;
    final shadowColor = isDark ? Colors.black45 : Colors.black26;

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _selectedRoomId = docId;
        });
      },
      onTap: () {
        if (_selectedRoomId != null) {
          setState(() {
            _selectedRoomId = null;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 140,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: tileBg,
          boxShadow: isSelected && shadow
              ? [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]
              : [],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FlickyIcons.room, size: 30, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    room.name,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: showTileDelete
                    ? GestureDetector(
                  key: ValueKey('delete_$docId'),
                  onTap: () => _showDeleteDialog(docId, room.name, index),
                  child: Container(
                    key: ValueKey('icon_$docId'),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                )
                    : Text(
                  "${roomDevices.length} devices",
                  key: ValueKey('count_$docId'),
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: roomDevices.map((device) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      getDeviceIcon(device.iconOption),
                      size: 24,
                      color: device.isSelected
                          ? Colors.green
                          : (isDark ? Colors.white60 : Colors.grey),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ).animate(
      delay: (index * 0.125).seconds,
    ).slideY(begin: 0.5, end: 0, duration: 0.5.seconds).fadeIn(duration: 0.5.seconds);
  }

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<RoomListState>().rooms;
    final docIds = context.read<RoomListState>().docIds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainPageHeader(
          icon: Icon(
            FlickyIcons.room,
            size: HomeAutomationStyles.largeIconSize,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: 'My Rooms',
        )
            .animate()
            .slideX(begin: 0.5, end: 0, duration: const Duration(milliseconds: 500))
            .fadeIn(duration: const Duration(milliseconds: 500)),
        HomeAutomationStyles.mediumVGap,
        Expanded(
          child: rooms.isEmpty
              ? const Center(child: Text('No available rooms'))
              : AnimatedList(
            key: _listKey,
            initialItemCount: rooms.length,
            itemBuilder: (context, index, animation) {
              final room = rooms[index];
              final docId = docIds[index];
              return FadeTransition(
                opacity: animation,
                child: _buildRoomTile(room, docId, index),
              );
            },
          ),
        ),
      ],
    );
  }
}
