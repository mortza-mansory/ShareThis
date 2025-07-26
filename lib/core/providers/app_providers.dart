import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharethis/core/di/injection_container.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';
import 'package:sharethis/features/discovery_and_connection/presentation/bloc/dummy/dummy_bloc.dart';
import 'package:sharethis/features/system_usage/presentation/bloc/system_usage_bloc.dart';
import 'package:sharethis/features/system_usage/presentation/bloc/system_usage_event.dart';

import '../../features/file_selection/presentaion/bloc/app_selection/app_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/app_selection/app_selection_event.dart';
import '../../features/file_selection/presentaion/bloc/document_selection/document_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/document_selection/document_selection_event.dart';
import '../../features/file_selection/presentaion/bloc/global_file_selection/global_file_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/image_selection/image_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/image_selection/image_selection_event.dart';
import '../../features/file_selection/presentaion/bloc/personal_file_selection/personal_file_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/personal_file_selection/personal_file_selection_event.dart';
import '../../features/file_selection/presentaion/bloc/uninstalled_app_selection/uninstalled_app_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/uninstalled_app_selection/uninstalled_app_selection_event.dart';
import '../../features/file_selection/presentaion/bloc/video_selection/video_selection_bloc.dart';
import '../../features/file_selection/presentaion/bloc/video_selection/video_selection_event.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<P2PConnectionRepository>(
          create: (context) => sl<P2PConnectionRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GlobalFileSelectionBloc>(
            create: (context) => sl<GlobalFileSelectionBloc>(),
          ),
          BlocProvider<DummyBloc>(
            create: (context) => DummyBloc(),
          ),
          BlocProvider<SystemUsageBloc>(
            create: (context) => sl<SystemUsageBloc>()..add(FetchSystemUsage()),
          ),
          BlocProvider<AppSelectionBloc>(
            create: (context) => sl<AppSelectionBloc>()..add(LoadApps()),
          ),
          BlocProvider<UninstalledAppSelectionBloc>(
            create: (context) => sl<UninstalledAppSelectionBloc>()..add(LoadUninstalledApps()),
          ),
          BlocProvider<VideoSelectionBloc>(
            create: (context) => sl<VideoSelectionBloc>()..add(LoadVideoFiles()),
          ),
          BlocProvider<ImageSelectionBloc>(
            create: (context) => sl<ImageSelectionBloc>()..add(LoadImageFiles()),
          ),
          BlocProvider<DocumentSelectionBloc>(
            create: (context) => sl<DocumentSelectionBloc>()..add(LoadDocumentFiles()),
          ),
          BlocProvider<PersonalFileSelectionBloc>(
            create: (context) => sl<PersonalFileSelectionBloc>()..add(LoadDirectoryContents(path: sl<PersonalFileSelectionBloc>().getInitialPath())),
          ),
        ],
        child: child,
      ),
    );
  }
}