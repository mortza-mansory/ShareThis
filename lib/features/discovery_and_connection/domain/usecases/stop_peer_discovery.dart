import 'package:dartz/dartz.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class StopPeerDiscovery implements UseCase<VoidResult, NoParams> {
  final P2PConnectionRepository repository;
  StopPeerDiscovery(this.repository);

  @override
  Future<Either<Failure, VoidResult>> call(NoParams params) async {
    final result = await repository.stopDiscovery();
    return result.map((_) => VoidResult());
  }
}