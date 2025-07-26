import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class StartFileDownload implements UseCase<VoidResult, StartFileDownloadParams> {
  final P2PConnectionRepository repository;
  StartFileDownload(this.repository);

  @override
  Future<Either<Failure, VoidResult>> call(StartFileDownloadParams params) async {
    final result = await repository.startFileDownload(
      params.fileId,
      params.saveDirectory,
      customFileName: params.customFileName,
    );
    return result.map((_) => VoidResult());
  }
}

class StartFileDownloadParams extends Equatable {
  final String fileId;
  final String saveDirectory;
  final String? customFileName;

  const StartFileDownloadParams({
    required this.fileId,
    required this.saveDirectory,
    this.customFileName,
  });

  @override
  List<Object?> get props => [fileId, saveDirectory, customFileName];
}