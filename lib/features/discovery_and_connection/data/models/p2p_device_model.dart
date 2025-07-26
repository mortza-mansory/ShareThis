// lib/features/discovery_and_connection/data/models/p2p_device_model.dart

import 'package:sharethis/features/discovery_and_connection/domain/entities/device.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

class P2PDeviceModel extends P2PDevice {
  final BleDiscoveredDevice? bleDiscoveredDevice;

  const P2PDeviceModel({
    required super.deviceName,
    required super.deviceAddress,
    required super.status,
    this.bleDiscoveredDevice,
  });

  factory P2PDeviceModel.fromBleDiscoveredDevice(BleDiscoveredDevice device) {
    return P2PDeviceModel(
      deviceName: device.deviceName ?? 'Unknown Device',
      deviceAddress: device.deviceAddress ?? 'Unknown Address', // Changed from macAddress to deviceAddress
      status: P2PDeviceStatus.AVAILABLE,
      bleDiscoveredDevice: device,
    );
  }
}