import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

abstract class PermissionService {
  Future<bool> requestStoragePermission(); // This will now handle MANAGE_EXTERNAL_STORAGE
  Future<bool> checkStoragePermissionStatus(); // This will now check MANAGE_EXTERNAL_STORAGE
  // The other methods are less relevant for full file access on newer Android versions
  Future<bool> requestManageExternalStoragePermission(); // Redundant, but keeping for clarity if needed elsewhere
  Future<bool> checkManageExternalStoragePermissionStatus(); // Redundant, but keeping for clarity if needed elsewhere
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> requestStoragePermission() async {
    debugPrint('PermissionService: Requesting MANAGE_EXTERNAL_STORAGE permission...');
    // For Android 11 (API 30) and above, MANAGE_EXTERNAL_STORAGE is the way to get all files access.
    // This permission requires the user to manually enable it from app settings.
    // The request() method from permission_handler for MANAGE_EXTERNAL_STORAGE
    // will typically open the app settings page where the user can toggle it.
    final status = await Permission.manageExternalStorage.request();
    debugPrint('PermissionService: MANAGE_EXTERNAL_STORAGE permission status: $status');
    return status.isGranted;
  }

  @override
  Future<bool> checkStoragePermissionStatus() async {
    debugPrint('PermissionService: Checking MANAGE_EXTERNAL_STORAGE permission status...');
    final status = await Permission.manageExternalStorage.status;
    debugPrint('PermissionService: Current MANAGE_EXTERNAL_STORAGE permission status: $status');
    return status.isGranted;
  }

  @override
  Future<bool> requestManageExternalStoragePermission() async {
    // This method is now effectively the same as requestStoragePermission
    return await requestStoragePermission();
  }

  @override
  Future<bool> checkManageExternalStoragePermissionStatus() async {
    // This method is now effectively the same as checkStoragePermissionStatus
    return await checkStoragePermissionStatus();
  }
}
