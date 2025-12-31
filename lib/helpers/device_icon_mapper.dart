import 'package:flutter/material.dart';
import 'package:flicky/styles/flicky_icons_icons.dart';

IconData getDeviceIcon(String type) {
  switch (type.toLowerCase()) {
    case 'fan':
      return FlickyIcons.fan2;
    case 'light':
      return FlickyIcons.lamp;
    case 'ac':
      return FlickyIcons.ac;
    case 'fridge':
      return FlickyIcons.fridge;
    case 'heater':
      return FlickyIcons.heater;
    case 'oven':
      return FlickyIcons.oven;
    case 'microwave':
      return FlickyIcons.microwave;
    default:
      return FlickyIcons.outlet;
  }
}
