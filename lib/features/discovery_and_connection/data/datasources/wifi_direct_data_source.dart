// lib/features/discovery_and_connection/data/datasources/wifi_direct_data_source.dart

import 'dart:async';
import 'dart:io'; // Import for File
import 'dart:typed_data';
import 'package:sharethis/features/discovery_and_connection/data/models/p2p_device_model.dart';
import 'package:sharethis/features/discovery_and_connection/data/models/connection_info_model.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:flutter/foundation.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart'; // Import for FileTransferInfo and FileTransferStatus

abstract class WifiDirectDataSource {
  Future<void> initializeAndListen();
  Future<void> requestPermissionsAndEnableServices();

  Stream<List<P2PDeviceModel>> get peersStream;
  Future<void> startPeerDiscovery();
  Future<void> stopPeerDiscovery();

  Future<void> connectToDevice(P2PDeviceModel device);
  Future<void> connectWithCredentials(String ssid, String psk);

  Future<void> disconnect();
  Stream<ConnectionInfoModel> get connectionInfoStream;
  Stream<String> get messageStream;
  Future<void> sendMessage(String message);

  // Updated abstract methods for file transfer
  Stream<FileTransferInfo> sendFile(String filePath);
  Stream<FileTransferInfo> get incomingFileAnnouncementsStream;
  Future<void> startFileDownload(String fileId, String saveDirectory, {String? customFileName});


  void dispose();
}

class WifiDirectDataSourceImpl implements WifiDirectDataSource {
  final FlutterP2pClient _p2pClient = FlutterP2pClient();

  final _peersController = StreamController<List<P2PDeviceModel>>.broadcast();
  final _connectionInfoController = StreamController<ConnectionInfoModel>.broadcast();
  final _messageController = StreamController<String>.broadcast();

  // New StreamControllers for file transfer progress and announcements
  final _sendFileProgressController = StreamController<FileTransferInfo>.broadcast();
  final _incomingFileAnnouncementsController = StreamController<FileTransferInfo>.broadcast();

  StreamSubscription<List<BleDiscoveredDevice>>? _scanSubscription;
  StreamSubscription<HotspotClientState>? _hotspotClientStateSubscription;
  StreamSubscription<String>? _receivedTextSubscription;

  // Subscriptions for file transfer streams
  StreamSubscription<List<HostedFileInfo>>? _sentFilesInfoSubscription;
  StreamSubscription<List<ReceivableFileInfo>>? _receivedFilesInfoSubscription;

  @override
  Future<void> initializeAndListen() async {
    debugPrint('WifiDirectDataSourceImpl: Initializing FlutterP2pClient.');
    await _p2pClient.initialize();

    _hotspotClientStateSubscription = _p2pClient.streamHotspotState().listen((state) {
      debugPrint('Client Hotspot State: ${state.isActive}, IP: ${state.hostIpAddress}, Host IP: ${state.hostGatewayIpAddress}');
      _connectionInfoController.add(ConnectionInfoModel.fromHotspotClientState(state));
    }, onError: (e) {
      debugPrint('Error in _p2pClient.streamHotspotState: $e');
      _connectionInfoController.addError(e);
    });

    _receivedTextSubscription = _p2pClient.streamReceivedTexts().listen((message) {
      debugPrint('Received text message: $message');
      _messageController.add(message);
    }, onError: (e) {
      debugPrint('Error in _p2pClient.streamReceivedTexts: $e');
      _messageController.addError(e);
    });

    // Listen for updates on files being sent by this client
    _sentFilesInfoSubscription = _p2pClient.streamSentFilesInfo().listen((hostedFiles) {
      for (var hostedFile in hostedFiles) {
        _updateSentFileProgress(hostedFile);
      }
    }, onError: (e) {
      debugPrint('Error in _p2pClient.streamSentFilesInfo: $e');
      _sendFileProgressController.addError(e);
    });

    // Listen for announcements of files available to receive
    _receivedFilesInfoSubscription = _p2pClient.streamReceivedFilesInfo().listen((receivableFiles) {
      for (var receivableFile in receivableFiles) {
        _incomingFileAnnouncementsController.add(_mapReceivableFileInfoToFileTransferInfo(receivableFile));
      }
    }, onError: (e) {
      debugPrint('Error in _p2pClient.streamReceivedFilesInfo: $e');
      _incomingFileAnnouncementsController.addError(e);
    });
  }

  @override
  Future<void> requestPermissionsAndEnableServices() async {
    debugPrint('WifiDirectDataSourceImpl: Checking and requesting permissions/enabling services.');
    try {
      // Storage (for file transfer)
      if (!await _p2pClient.checkStoragePermission()) {
        await _p2pClient.askStoragePermission();
      }
      // P2P (Wi-Fi Direct related permissions)
      if (!await _p2pClient.checkP2pPermissions()) {
        await _p2pClient.askP2pPermissions();
      }
      // Bluetooth (for BLE discovery)
      if (!await _p2pClient.checkBluetoothPermissions()) {
        await _p2pClient.askBluetoothPermissions();
      }

      // Wi-Fi Service
      if (!await _p2pClient.checkWifiEnabled()) {
        await _p2pClient.enableWifiServices();
      }
      // Location Service (often needed for scanning)
      if (!await _p2pClient.checkLocationEnabled()) {
        await _p2pClient.enableLocationServices();
      }
      // Bluetooth Service (if using BLE features)
      if (!await _p2pClient.checkBluetoothEnabled()) {
        await _p2pClient.enableBluetoothServices();
      }
      debugPrint('Permissions and services check/request completed.');
    } catch (e) {
      debugPrint('Error during permission/service check: $e');
      throw Exception('Failed to get required permissions or enable services: ${e.toString()}');
    }
  }

  @override
  Stream<List<P2PDeviceModel>> get peersStream => _peersController.stream;

  @override
  Future<void> startPeerDiscovery() async {
    debugPrint('WifiDirectDataSourceImpl: Starting BLE scan for peers.');
    await stopPeerDiscovery();
    _scanSubscription = await _p2pClient.startScan((devices) {
      final p2pDeviceModels = devices.map((d) => P2PDeviceModel.fromBleDiscoveredDevice(d)).toList();
      _peersController.add(p2pDeviceModels);
    }, timeout: const Duration(seconds: 30));
  }

  @override
  Future<void> stopPeerDiscovery() async {
    debugPrint('WifiDirectDataSourceImpl: Stopping BLE scan.');
    if (_scanSubscription != null) {
      await _p2pClient.stopScan();
      await _scanSubscription?.cancel();
      _scanSubscription = null;
    }
  }

  @override
  Future<void> connectToDevice(P2PDeviceModel device) async {
    debugPrint('WifiDirectDataSourceImpl: Attempting to connect to device: ${device.deviceName}');

    if (device.bleDiscoveredDevice == null) {
      throw Exception('Cannot connect: BleDiscoveredDevice not available for ${device.deviceName}.');
    }

    try {
      await _p2pClient.connectWithDevice(
        device.bleDiscoveredDevice!,
        timeout: const Duration(seconds: 60),
      );
      debugPrint('WifiDirectDataSourceImpl: Successfully connected to ${device.deviceName}');
    } catch (e) {
      debugPrint('WifiDirectDataSourceImpl: Failed to connect to ${device.deviceName}: $e');
      rethrow;
    }
  }

  @override
  Future<void> connectWithCredentials(String ssid, String psk) async {
    debugPrint('WifiDirectDataSourceImpl: Connecting with credentials. SSID: $ssid');

    try {
      await _p2pClient.connectWithCredentials(ssid, psk, timeout: const Duration(seconds: 60));
      debugPrint('WifiDirectDataSourceImpl: Successfully connected with credentials.');
    } catch (e) {
      debugPrint('WifiDirectDataSourceImpl: Failed to connect with credentials: $e');
      throw Exception('Failed to connect with provided credentials: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    debugPrint('WifiDirectDataSourceImpl: Disconnecting.');

    await stopPeerDiscovery();

    try {
      await _p2pClient.disconnect();
      debugPrint('WifiDirectDataSourceImpl: Successfully disconnected.');
    } catch (e) {
      debugPrint('WifiDirectDataSourceImpl: Disconnect failed: $e');
      throw Exception('Failed to disconnect Wi-Fi Direct: $e');
    }
  }

  @override
  Stream<ConnectionInfoModel> get connectionInfoStream => _connectionInfoController.stream;

  @override
  Stream<String> get messageStream => _messageController.stream;

  @override
  Future<void> sendMessage(String message) async {
    debugPrint('WifiDirectDataSourceImpl: Broadcasting message: $message');

    try {
      await _p2pClient.broadcastText(message);
      debugPrint('WifiDirectDataSourceImpl: Message broadcasted successfully.');
    } catch (e) {
      debugPrint('WifiDirectDataSourceImpl: Failed to broadcast message: $e');
      throw Exception('Failed to broadcast message: $e');
    }
  }

  @override
  Stream<FileTransferInfo> sendFile(String filePath) {
    final file = File(filePath);
    final fileName = file.path.split('/').last;

    if (!file.existsSync()) {
      _sendFileProgressController.addError('File not found at $filePath');
      return _sendFileProgressController.stream.where((info) => info.fileName == fileName).asBroadcastStream();
    }

    _p2pClient.broadcastFile(file).then((p2pFileInfo) {
      if (p2pFileInfo == null) {
        _sendFileProgressController.add(FileTransferInfo(
          fileName: fileName,
          status: FileTransferStatus.failed,
          errorMessage: 'Failed to initiate file broadcast.',
        ));
      } else {
        debugPrint('File broadcast initiated for: ${p2pFileInfo.id} (Size: ${p2pFileInfo.size} bytes)');
        _sendFileProgressController.add(FileTransferInfo(
          fileName: fileName,
          totalBytes: p2pFileInfo.size ?? 0,
          bytesTransferred: 0,
          status: FileTransferStatus.connecting,
        ));
      }
    }).catchError((e) {
      debugPrint('Error initiating file broadcast for $fileName: $e');
      _sendFileProgressController.add(FileTransferInfo(
        fileName: fileName,
        status: FileTransferStatus.failed,
        errorMessage: e.toString(),
      ));
    });

    return _sendFileProgressController.stream.where((info) => info.fileName == fileName).asBroadcastStream();
  }

  void _updateSentFileProgress(HostedFileInfo hostedFile) {
    final fileName = hostedFile.localPath.split('/').last;
    final totalBytes = hostedFile.info.size ?? 0;

    FileTransferStatus newStatus;
    String? errorMessage;
    int bytesTransferred = 0;

    switch (hostedFile.state) { // Using ReceivableFileState constants
      case ReceivableFileState.idle:
        newStatus = FileTransferStatus.idle;
        break;
      case ReceivableFileState.downloading: // HostedFile is sending, but uses ReceivableFileState enum
        newStatus = FileTransferStatus.inProgress; // Treat as in progress for sending
        // In this case, hostedFile.getProgressPercent might be used if only one receiver is expected.
        // For simplicity now, we'll keep bytesTransferred as 0 or aggregate later.
        break;
      case ReceivableFileState.completed:
        newStatus = FileTransferStatus.completed;
        bytesTransferred = totalBytes;
        break;
      case ReceivableFileState.error: // Corrected from 'failed' to 'error'
        newStatus = FileTransferStatus.failed;
        errorMessage = 'File sending failed for ${fileName}.';
        break;
    // No 'sending' state in ReceivableFileState, mapping to 'downloading'
    // default case handles unexpected states or idle
      default:
        newStatus = FileTransferStatus.idle;
    }

    final updatedInfo = FileTransferInfo(
      fileName: fileName,
      totalBytes: totalBytes,
      bytesTransferred: bytesTransferred,
      status: newStatus,
      errorMessage: errorMessage,
    );
    _sendFileProgressController.add(updatedInfo);
  }

  @override
  Stream<FileTransferInfo> get incomingFileAnnouncementsStream => _incomingFileAnnouncementsController.stream;

  FileTransferInfo _mapReceivableFileInfoToFileTransferInfo(ReceivableFileInfo receivableFile) {
    final fileId = receivableFile.info.id;
    final totalBytes = receivableFile.info.size ?? 0;
    final bytesTransferred = (totalBytes * (receivableFile.downloadProgressPercent / 100.0)).toInt();

    FileTransferStatus newStatus;
    String? errorMessage;

    switch (receivableFile.state) { // Using ReceivableFileState constants
      case ReceivableFileState.idle:
        newStatus = FileTransferStatus.idle;
        break;
      case ReceivableFileState.downloading:
        newStatus = FileTransferStatus.inProgress;
        break;
      case ReceivableFileState.completed:
        newStatus = FileTransferStatus.completed;
        break;
      case ReceivableFileState.error: // Corrected from 'failed' to 'error'
        newStatus = FileTransferStatus.failed;
        errorMessage = 'File download announcement failed for ID: ${fileId}.';
        break;
    // No 'sending' state in ReceivableFileState, mapping to 'downloading' as it's the closest active state
      default:
        newStatus = FileTransferStatus.idle;
    }

    return FileTransferInfo(
      fileName: fileId,
      totalBytes: totalBytes,
      bytesTransferred: bytesTransferred,
      status: newStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  Future<void> startFileDownload(String fileId, String saveDirectory, {String? customFileName}) async {
    String downloadFileName = customFileName ?? fileId;
    int downloadTotalBytes = 0;

    debugPrint('Initiating download for file ID: $fileId to $saveDirectory');
    try {
      final bool success = await _p2pClient.downloadFile(
        fileId,
        saveDirectory,
        customFileName: customFileName,
        onProgress: (progressUpdate) {
          // FileDownloadProgressUpdate has 'fileName', 'totalSize', 'bytesDownloaded', 'progressPercent'
          downloadTotalBytes = progressUpdate.totalSize;

          debugPrint('Download progress for ${downloadFileName}: ${progressUpdate.progressPercent}%');

          _incomingFileAnnouncementsController.add(
            FileTransferInfo(
              fileName: downloadFileName,
              totalBytes: downloadTotalBytes,
              bytesTransferred: progressUpdate.bytesDownloaded,
              status: FileTransferStatus.inProgress,
              errorMessage: null,
            ),
          );
        },
      );
      if (success) {
        debugPrint('File ID: $fileId downloaded successfully.');
        _incomingFileAnnouncementsController.add(
          FileTransferInfo(
            fileName: downloadFileName,
            totalBytes: downloadTotalBytes,
            bytesTransferred: downloadTotalBytes,
            status: FileTransferStatus.completed,
            errorMessage: null,
          ),
        );
      } else {
        debugPrint('File ID: $fileId download failed.');
        _incomingFileAnnouncementsController.add(
          FileTransferInfo(
            fileName: downloadFileName,
            totalBytes: downloadTotalBytes,
            bytesTransferred: 0,
            status: FileTransferStatus.failed,
            errorMessage: 'Download failed.',
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during file download for ID $fileId: $e');
      _incomingFileAnnouncementsController.add(
        FileTransferInfo(
          fileName: downloadFileName,
          totalBytes: downloadTotalBytes,
          bytesTransferred: 0,
          status: FileTransferStatus.failed,
          errorMessage: e.toString(),
        ),
      );
      throw Exception('Failed to download file: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    debugPrint('WifiDirectDataSourceImpl: Disposing resources.');
    _scanSubscription?.cancel();
    _hotspotClientStateSubscription?.cancel();
    _receivedTextSubscription?.cancel();
    _sentFilesInfoSubscription?.cancel();
    _receivedFilesInfoSubscription?.cancel();

    _peersController.close();
    _connectionInfoController.close();
    _messageController.close();
    _sendFileProgressController.close();
    _incomingFileAnnouncementsController.close();

    _p2pClient.dispose();
  }
}