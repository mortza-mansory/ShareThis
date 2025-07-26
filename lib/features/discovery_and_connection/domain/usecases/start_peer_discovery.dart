import 'package:dartz/dartz.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/entities/device.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class StartPeerDiscovery implements StreamUseCase<List<P2PDevice>, NoParams> {
  final P2PConnectionRepository repository;
  StartPeerDiscovery(this.repository);

  @override
  Stream<List<P2PDevice>> call(NoParams params) {
    return repository.discoverPeers();
  }
}