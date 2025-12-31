import 'package:flutter/material.dart';
import '../models/device.model.dart';
import 'device_row_item.dart';
import '../pages/device_details_page.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DevicesList extends StatefulWidget {
  final List<DeviceModel> devices;
  final List<String> docIds;

  const DevicesList({
    super.key,
    required this.devices,
    required this.docIds,
  });

  @override
  State<DevicesList> createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _removeDeviceById(String docId) {
    final index = widget.docIds.indexOf(docId);
    if (index == -1) return;

    final removedDevice = widget.devices[index];
    final removedDocId = widget.docIds[index];

    // Animate removal
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: DeviceRowItem(
          device: removedDevice,
          docId: removedDocId,
          onTapDevice: (_, __) {},
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );

    // Remove from underlying list after animation completes
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        widget.devices.removeAt(index);
        widget.docIds.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.devices.isEmpty) {
      return const Center(child: Text('No devices available'));
    }

    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.all(16),
      initialItemCount: widget.devices.length,
      itemBuilder: (context, index, animation) {
        // Guard: prevent out-of-range errors
        if (index >= widget.devices.length) return const SizedBox();

        final device = widget.devices[index];
        final docId = widget.docIds[index];

        return FadeTransition(
          opacity: animation,
          child: DeviceRowItem(
            device: device,
            docId: docId,
            onTapDevice: (d, id) async {
              final deleted = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => DeviceDetailsPage(
                    device: d,
                    docId: id,
                    onDeleted: () => _removeDeviceById(id),
                  ),
                ),
              );

              if (deleted == true) {
                _removeDeviceById(id);
              }
            },
          ).animate(
            delay: (index * 0.125).seconds,
          ).slideY(begin: 0.5, end: 0, duration: 0.5.seconds)
              .fadeIn(duration: 0.5.seconds),
        );
      },
    );
  }
}
