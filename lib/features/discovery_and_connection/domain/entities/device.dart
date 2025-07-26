
import 'package:equatable/equatable.dart';

class P2PDevice extends Equatable {
  final String deviceName;
  final String deviceAddress; // MAC address or unique identifier
  final int status; // Represents connection status (e.g., connected, available, unavailable)

  const P2PDevice({
    required this.deviceName,
    required this.deviceAddress,
    required this.status,
  });

  @override
  List<Object?> get props => [deviceName, deviceAddress, status];
}

// Example status constants (can be defined elsewhere, e.g., in a constants file)
// For simplicity, defining here for now based on WifiP2pDevice status codes.
// You might want to map these to more meaningful, abstract statuses in your domain.
abstract class P2PDeviceStatus {
  static const int CONNECTED = 0;
  static const int INVITED = 1;
  static const int FAILED = 2;
  static const int AVAILABLE = 3;
  static const int UNAVAILABLE = 4;
}