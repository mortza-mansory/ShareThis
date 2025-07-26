import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class SendFile implements StreamUseCase<FileTransferInfo, SendFileParams> {
  final P2PConnectionRepository repository;
  SendFile(this.repository);

  @override
  Stream<FileTransferInfo> call(SendFileParams params) {
    return repository.sendFile(params.filePath);
  }
}

class SendFileParams extends Equatable {
  final String filePath;
  const SendFileParams({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}