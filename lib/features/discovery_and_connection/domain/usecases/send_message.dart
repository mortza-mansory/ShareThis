import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class SendMessage implements UseCase<VoidResult, SendMessageParams> {
  final P2PConnectionRepository repository;
  SendMessage(this.repository);

  @override
  Future<Either<Failure, VoidResult>> call(SendMessageParams params) async {
    final result = await repository.sendMessage(params.message);
    return result.map((_) => VoidResult());
  }
}

class SendMessageParams extends Equatable {
  final String message;
  const SendMessageParams({required this.message});

  @override
  List<Object?> get props => [message];
}
