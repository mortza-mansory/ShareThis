import 'package:dartz/dartz.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class GetConnectionInfoStream implements StreamUseCase<Either<Failure, ConnectionInfo>, NoParams> {
  final P2PConnectionRepository repository;
  GetConnectionInfoStream(this.repository);

  @override
  Stream<Either<Failure, ConnectionInfo>> call(NoParams params) {
    return repository.getConnectionInfo();
  }
}