abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class WifiDirectFailure extends Failure {
  const WifiDirectFailure(String message) : super(message);
}

class NoPermissionsFailure extends WifiDirectFailure {
  const NoPermissionsFailure() : super('Location and/or Wi-Fi Direct permissions denied.');
}

class DeviceNotFoundFailure extends WifiDirectFailure {
  const DeviceNotFoundFailure() : super('Device not found or not discoverable.');
}

class ConnectionFailure extends WifiDirectFailure {
  const ConnectionFailure(String message) : super('Failed to connect: $message');
}

class DiscoveryFailure extends WifiDirectFailure {
  const DiscoveryFailure(String message) : super('Failed to start discovery: $message');
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super('Server error: $message');
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super('Cache error: $message');
}

class FileTransferFailure extends WifiDirectFailure {
  const FileTransferFailure(String message) : super('File transfer failed: $message');
}