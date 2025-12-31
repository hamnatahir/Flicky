import 'package:flutter/material.dart';
import 'package:flicky/features/devices/presentation/widgets/add_device_form.dart';
import 'package:flicky/features/devices/presentation/models/device.model.dart';
import 'package:flicky/features/devices/presentation/models/outlet.model.dart';

class AddDeviceSheet extends StatelessWidget {
  final List<OutletModel> outletList;
  final void Function(DeviceModel) onSave;

  const AddDeviceSheet({super.key, required this.outletList, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: AddDeviceForm(
        outletList: outletList,
        onSave: onSave,
      ),
    );
  }
}
