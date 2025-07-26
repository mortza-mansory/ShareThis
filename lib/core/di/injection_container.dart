import 'package:get_it/get_it.dart';
import 'package:sharethis/core/services/permission_service.dart';
import 'package:sharethis/features/discovery_and_connection/data/datasources/wifi_direct_data_source.dart';
import 'package:sharethis/features/discovery_and_connection/data/repositories/p2p_connection_repository_impl.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/connect_to_device.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/disconnect_from_p2p.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/get_connection_info_stream.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/get_incoming_file_announcements.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/get_message_stream.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/initialize_p2p.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/send_file.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/send_message.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/start_file_download.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/start_peer_discovery.dart';
import 'package:sharethis/features/discovery_and_connection/domain/usecases/stop_peer_discovery.dart';

// وارد کردن‌ها برای ویژگی انتخاب فایل (برنامه‌ها)
import 'package:sharethis/features/file_selection/data/repositories/app_repository_impl.dart';
import 'package:sharethis/features/file_selection/domain/repositories/app_repository.dart';
import 'package:sharethis/features/file_selection/domain/usecases/get_installed_apps.dart';
import 'package:sharethis/features/file_selection/domain/usecases/copy_apks_to_cache.dart';

// وارد کردن‌ها برای ویژگی انتخاب فایل (برنامه‌های نصب نشده)
import 'package:sharethis/features/file_selection/data/repositories/uninstalled_app_repository_impl.dart';
import 'package:sharethis/features/file_selection/domain/repositories/uninstalled_app_repository.dart';
import 'package:sharethis/features/file_selection/domain/usecases/get_uninstalled_apps.dart';

// وارد کردن‌ها برای ویژگی انتخاب فایل (ویدیوها)
import 'package:sharethis/features/file_selection/data/repositories/video_repository_impl.dart';
import 'package:sharethis/features/file_selection/domain/repositories/video_repository.dart';
import 'package:sharethis/features/file_selection/domain/usecases/get_video_files.dart';

// وارد کردن‌ها برای ویژگی انتخاب فایل (تصاویر)
import 'package:sharethis/features/file_selection/data/repositories/image_repository_impl.dart';
import 'package:sharethis/features/file_selection/domain/repositories/image_repository.dart';
import 'package:sharethis/features/file_selection/domain/usecases/get_image_files.dart';

// وارد کردن‌ها برای ویژگی انتخاب فایل (اسناد)
import 'package:sharethis/features/file_selection/data/repositories/document_repository_impl.dart';
import 'package:sharethis/features/file_selection/domain/repositories/document_repository.dart';
import 'package:sharethis/features/file_selection/domain/usecases/get_document_files.dart';

// وارد کردن‌ها برای ویژگی انتخاب فایل (فایل‌های شخصی)
import 'package:sharethis/features/file_selection/data/repositories/file_repository_impl.dart';
import 'package:sharethis/features/file_selection/domain/repositories/file_repository.dart';
import 'package:sharethis/features/file_selection/domain/usecases/get_directory_contents.dart';

// وارد کردن‌ها برای ویژگی مصرف سیستم
import 'package:sharethis/features/system_usage/data/datasources/system_usage_local_data_source.dart';
import 'package:sharethis/features/system_usage/data/repositories/system_usage_repository_impl.dart';
import 'package:sharethis/features/system_usage/domain/repositories/system_usage_repository.dart';
import 'package:sharethis/features/system_usage/domain/usecases/get_system_usage_info.dart';
import 'package:sharethis/features/system_usage/presentation/bloc/system_usage_bloc.dart';

import '../../features/file_selection/data/datasource/app_local_data_source.dart';
import '../../features/file_selection/data/datasource/document_local_data_source.dart';
import '../../features/file_selection/data/datasource/file_local_data_source.dart';
import '../../features/file_selection/data/datasource/image_local_data_source.dart';
import '../../features/file_selection/data/datasource/uninstalled_app_local_data_source.dart';
import '../../features/file_selection/data/datasource/video_local_data_source.dart';
import '../../features/file_selection/presentaion/bloc/app_selection/app_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/document_selection/document_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/global_file_selection/global_file_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/image_selection/image_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/personal_file_selection/personal_file_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/uninstalled_app_selection/uninstalled_app_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/video_selection/video_selection_bloc.dart';



final sl = GetIt.instance;

Future<void> init() async {
  // هسته - سرویس‌ها
  sl.registerLazySingleton<PermissionService>(
        () => PermissionServiceImpl(),
  );

  // ویژگی‌ها - کشف و اتصال
  sl.registerLazySingleton<WifiDirectDataSource>(
        () => WifiDirectDataSourceImpl(),
  );

  sl.registerLazySingleton<P2PConnectionRepository>(
        () => P2PConnectionRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => ConnectToDevice(sl()));
  sl.registerLazySingleton(() => DisconnectFromP2P(sl()));
  sl.registerLazySingleton(() => GetConnectionInfoStream(sl()));
  sl.registerLazySingleton(() => GetIncomingFileAnnouncements(sl()));
  sl.registerLazySingleton(() => GetMessageStream(sl()));
  sl.registerLazySingleton(() => InitializeP2P(sl()));
  sl.registerLazySingleton(() => SendFile(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => StartFileDownload(sl()));
  sl.registerLazySingleton(() => StartPeerDiscovery(sl()));
  sl.registerLazySingleton(() => StopPeerDiscovery(sl()));

  // ویژگی‌ها - مصرف سیستم
  sl.registerLazySingleton<SystemUsageLocalDataSource>(
        () => SystemUsageLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SystemUsageRepository>(
        () => SystemUsageRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<GetSystemUsageInfo>(
        () => GetSystemUsageInfo(sl()),
  );
  sl.registerFactory<SystemUsageBloc>(
        () => SystemUsageBloc(getSystemUsageInfo: sl()),
  );

  // ویژگی‌ها - انتخاب فایل (برنامه‌ها)
  sl.registerLazySingleton<AppLocalDataSource>(
        () => AppLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AppRepository>(
        () => AppRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetInstalledApps(sl()));
  sl.registerLazySingleton(() => CopyApksToCache(sl()));

  sl.registerFactory<AppSelectionBloc>(
        () => AppSelectionBloc(
      getInstalledApps: sl(),
      copyApksToCache: sl(),
      permissionService: sl(),
      globalFileSelectionBloc: sl(), // تزریق GlobalFileSelectionBloc
    ),
  );

  // ویژگی‌ها - انتخاب فایل (برنامه‌های نصب نشده)
  sl.registerLazySingleton<UninstalledAppLocalDataSource>(
        () => UninstalledAppLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<UninstalledAppRepository>(
        () => UninstalledAppRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetUninstalledApps(sl()));

  sl.registerFactory<UninstalledAppSelectionBloc>(
        () => UninstalledAppSelectionBloc(
      getUninstalledApps: sl(),
      permissionService: sl(),
      globalFileSelectionBloc: sl(), // تزریق GlobalFileSelectionBloc
    ),
  );

  // ویژگی‌ها - انتخاب فایل (ویدیوها)
  sl.registerLazySingleton<VideoLocalDataSource>(
        () => VideoLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<VideoRepository>(
        () => VideoRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetVideoFiles(sl()));

  sl.registerFactory<VideoSelectionBloc>(
        () => VideoSelectionBloc(
      getVideoFiles: sl(),
      permissionService: sl(),
      globalFileSelectionBloc: sl(), // تزریق GlobalFileSelectionBloc
    ),
  );

  // ویژگی‌ها - انتخاب فایل (تصاویر)
  sl.registerLazySingleton<ImageLocalDataSource>(
        () => ImageLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ImageRepository>(
        () => ImageRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetImageFiles(sl()));

  sl.registerFactory<ImageSelectionBloc>(
        () => ImageSelectionBloc(
      getImageFiles: sl(),
      permissionService: sl(),
      globalFileSelectionBloc: sl(), // تزریق GlobalFileSelectionBloc
    ),
  );

  // ویژگی‌ها - انتخاب فایل (اسناد)
  sl.registerLazySingleton<DocumentLocalDataSource>(
        () => DocumentLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<DocumentRepository>(
        () => DocumentRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetDocumentFiles(sl()));

  sl.registerFactory<DocumentSelectionBloc>(
        () => DocumentSelectionBloc(
      getDocumentFiles: sl(),
      permissionService: sl(),
      globalFileSelectionBloc: sl(),
    ),
  );

  sl.registerLazySingleton<FileLocalDataSource>(
        () => FileLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<FileRepository>(
        () => FileRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetDirectoryContents(sl()));

  sl.registerFactory<PersonalFileSelectionBloc>(
        () => PersonalFileSelectionBloc(
      getDirectoryContents: sl(),
      permissionService: sl(),
      globalFileSelectionBloc: sl(),
    ),
  );

  sl.registerLazySingleton(() => GlobalFileSelectionBloc());
}