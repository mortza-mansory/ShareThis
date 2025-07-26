import 'package:dartz/dartz.dart';
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart'; // Use the interface

class InitializeP2P implements UseCase<VoidResult, NoParams> {
  final P2PConnectionRepository repository; // Now uses the interface
  InitializeP2P(this.repository);

  @override
  Future<Either<Failure, VoidResult>> call(NoParams params) async {
    final permissionResult = await repository.requestPermissionsAndEnableServices();
    if (permissionResult.isLeft()) {
      return permissionResult.map((_) => VoidResult()); // Return the permission failure
    }

    final initResult = await repository.initialize();
    return initResult.map((_) => VoidResult());
  }
}