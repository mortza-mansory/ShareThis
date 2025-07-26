import 'package:equatable/equatable.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/features/discovery_and_connection/domain/entities/device.dart';
import 'package:dartz/dartz.dart';

// New enum for file transfer status (already added)
enum FileTransferStatus {
  idle,
  connecting,
  inProgress,
  completed,
  failed,
  cancelled,
}

// New class to hold file transfer information and progress (already added)
class FileTransferInfo extends Equatable {
  final String fileName;
  final int totalBytes;
  final int bytesTransferred;
  final FileTransferStatus status;
  final String? errorMessage; // For failed transfers

  const FileTransferInfo({
    required this.fileName,
    this.totalBytes = 0,
    this.bytesTransferred = 0,
    this.status = FileTransferStatus.idle,
    this.errorMessage,
  });

  // Calculate progress percentage
  double get progress {
    if (totalBytes <= 0) return 0.0;
    return bytesTransferred / totalBytes;
  }

  FileTransferInfo copyWith({
    String? fileName,
    int? totalBytes,
    int? bytesTransferred,
    FileTransferStatus? status,
    String? errorMessage,
  }) {
    return FileTransferInfo(
      fileName: fileName ?? this.fileName,
      totalBytes: totalBytes ?? this.totalBytes,
      bytesTransferred: bytesTransferred ?? this.bytesTransferred,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [fileName, totalBytes, bytesTransferred, status, errorMessage];
}


abstract class P2PConnectionRepository {
  Future<Either<Failure, void>> initialize();

  Future<Either<Failure, void>> requestPermissionsAndEnableServices();

  Stream<List<P2PDevice>> discoverPeers();
  Future<Either<Failure, void>> startDiscovery();
  Future<Either<Failure, void>> stopDiscovery();

  Future<Either<Failure, void>> connectToDevice(P2PDevice device);
  Future<Either<Failure, void>> connectWithCredentials(String ssid, String psk);

  Future<Either<Failure, void>> disconnect();

  Stream<Either<Failure, ConnectionInfo>> getConnectionInfo();

  Stream<String> get messageStream;
  Future<Either<Failure, void>> sendMessage(String message);

  // New abstract methods for file transfer
  Stream<FileTransferInfo> sendFile(String filePath);
  // This stream provides announcements for files that can be downloaded
  Stream<FileTransferInfo> receiveFile(String saveDirectory); // Renamed to accurately reflect its usage

  // New: Abstract method for starting explicit file download
  Future<Either<Failure, void>> startFileDownload(String fileId, String saveDirectory, {String? customFileName});
}

class ConnectionInfo extends Equatable {
  final bool isGroupFormed;
  final bool isGroupOwner;
  final String? groupOwnerAddress;

  const ConnectionInfo({
    required this.isGroupFormed,
    required this.isGroupOwner,
    this.groupOwnerAddress,
  });

  @override
  List<Object?> get props => [isGroupFormed, isGroupOwner, groupOwnerAddress];
}