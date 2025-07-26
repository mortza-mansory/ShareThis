import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharethis/features/home/presentation/pages/main_page.dart';
import 'package:sharethis/features/discovery_and_connection/presentation/pages/sender_scan_page.dart';
import 'package:sharethis/features/discovery_and_connection/presentation/pages/receiver_scan_page.dart';
import 'package:sharethis/features/settings/presentation/pages/settings_page.dart';
import 'package:sharethis/features/file_transfer/presentation/pages/file_transfer_page.dart';

import '../../features/file_selection/presentaion/pages/sender_file_selection_page.dart' show SenderFileSelectionPage; // New Import

class AppRouteNames {
  static const String initial = '/';
  static const String mainPage = '/main_page';
  static const String receiverHome = '/receiver_home';
  static const String receiverFileReceive = '/receiver_file_receive';
  static const String senderFileSelection = '/sender_file_selection';
  static const String senderScan = '/sender_scan';
  static const String receiverScan = '/receiver_scan';
  static const String senderDeviceSearch = '/sender_device_search';
  static const String senderFileSend = '/sender_file_send';
  static const String settings = '/settings';
  static const String fileTransfer = '/file_transfer';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRouteNames.mainPage,
  routes: [
    GoRoute(
      path: AppRouteNames.initial,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: AppRouteNames.mainPage,
      builder: (context, state) => const MainPage(),
    ),
    // Sender Flow Routes
    GoRoute(
      path: AppRouteNames.senderFileSelection,
      builder: (context, state) => const SenderFileSelectionPage(),
    ),
    GoRoute(
      path: AppRouteNames.senderScan,
      builder: (context, state) => const SenderScanPage(),
    ),
    // Receiver Flow Routes
    GoRoute(
      path: AppRouteNames.receiverScan,
      builder: (context, state) => const ReceiverScanPage(),
    ),
    GoRoute(
      path: AppRouteNames.receiverFileReceive,
      builder: (context, state) => const Text('Receiver File Receive Page (TODO)'),
    ),
    GoRoute(
      path: AppRouteNames.senderDeviceSearch,
      builder: (context, state) => const Text('Sender Device Search Page (TODO)'),
    ),
    GoRoute(
      path: AppRouteNames.senderFileSend,
      builder: (context, state) => const Text('Sender File Send Page (TODO)'),
    ),
    // File Transfer Route
    GoRoute(
      path: AppRouteNames.fileTransfer,
      builder: (context, state) => const FileTransferPage(),
    ),
    // Settings Route
    GoRoute(
      path: AppRouteNames.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text('Error: ${state.error}')),
  ),
);