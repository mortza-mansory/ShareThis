import 'package:dartz/dartz.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/features/discovery_and_connection/domain/entities/device.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';
import 'package:sharethis/features/discovery_and_connection/data/datasources/wifi_direct_data_source.dart';
import 'package:sharethis/features/discovery_and_connection/data/models/p2p_device_model.dart';
import 'package:sharethis/features/discovery_and_connection/data/models/connection_info_model.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class P2PConnectionRepositoryImpl implements P2PConnectionRepository {
  final WifiDirectDataSource remoteDataSource;

  P2PConnectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await remoteDataSource.initializeAndListen();
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error initializing: $e');
      return Left(WifiDirectFailure('Failed to initialize Wi-Fi Direct: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPermissionsAndEnableServices() async {
    try {
      await remoteDataSource.requestPermissionsAndEnableServices();
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error requesting permissions: $e');
      if (e.toString().contains('permissions')) {
        return const Left(NoPermissionsFailure());
      }
      return Left(WifiDirectFailure('Failed to request permissions or enable services: ${e.toString()}'));
    }
  }

  @override
  Stream<List<P2PDevice>> discoverPeers() {
    return remoteDataSource.peersStream.map((models) => models.map((m) => m as P2PDevice).toList());
  }

  @override
  Future<Either<Failure, void>> startDiscovery() async {
    try {
      await remoteDataSource.startPeerDiscovery();
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error starting discovery: $e');
      return Left(DiscoveryFailure('Failed to start peer discovery: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> stopDiscovery() async {
    try {
      await remoteDataSource.stopPeerDiscovery();
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error stopping discovery: $e');
      return Left(DiscoveryFailure('Failed to stop peer discovery: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> connectToDevice(P2PDevice device) async {
    try {
      if (device is! P2PDeviceModel || device.bleDiscoveredDevice == null) {
        return const Left(DeviceNotFoundFailure());
      }
      await remoteDataSource.connectToDevice(device);
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error connecting: $e');
      return Left(ConnectionFailure('Failed to connect to device: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> connectWithCredentials(String ssid, String psk) async {
    try {
      await remoteDataSource.connectWithCredentials(ssid, psk);
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error connecting with credentials: $e');
      return Left(ConnectionFailure('Failed to connect with credentials: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await remoteDataSource.disconnect();
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error disconnecting: $e');
      return Left(ConnectionFailure('Failed to disconnect: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, ConnectionInfo>> getConnectionInfo() {
    return remoteDataSource.connectionInfoStream.map((model) => Right<Failure, ConnectionInfo>(model as ConnectionInfo)).handleError((error) {
      debugPrint('P2PConnectionRepositoryImpl: Error in connection info stream: $error');
      throw WifiDirectFailure('Error getting connection info: ${error.toString()}');
    });
  }

  @override
  Stream<String> get messageStream => remoteDataSource.messageStream;

  @override
  Future<Either<Failure, void>> sendMessage(String message) async {
    try {
      await remoteDataSource.sendMessage(message);
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error sending message: $e');
      return Left(WifiDirectFailure('Failed to send message: ${e.toString()}'));
    }
  }

  @override
  Stream<FileTransferInfo> sendFile(String filePath) {
    return remoteDataSource.sendFile(filePath).handleError((error) {
      debugPrint('P2PConnectionRepositoryImpl: Error sending file: $error');
      // Use the newly defined FileTransferFailure
      throw FileTransferFailure('Failed to send file: ${error.toString()}');
    });
  }

  @override
  Stream<FileTransferInfo> receiveFile(String saveDirectory) {
    // This method now maps to incomingFileAnnouncementsStream from data source
    return remoteDataSource.incomingFileAnnouncementsStream.handleError((error) {
      debugPrint('P2PConnectionRepositoryImpl: Error in receive file announcements stream: $error');
      // Use the newly defined FileTransferFailure
      throw FileTransferFailure('Error receiving file announcements: ${error.toString()}');
    });
  }

  // New method in repository for triggering file download explicitly
  @override // Must be overridden from P2PConnectionRepository interface
  Future<Either<Failure, void>> startFileDownload(String fileId, String saveDirectory, {String? customFileName}) async {
    try {
      await remoteDataSource.startFileDownload(fileId, saveDirectory, customFileName: customFileName);
      return const Right(null);
    } catch (e) {
      debugPrint('P2PConnectionRepositoryImpl: Error starting file download: $e');
      // Use the newly defined FileTransferFailure
      return Left(FileTransferFailure('Failed to start file download: ${e.toString()}'));
    }
  }
}