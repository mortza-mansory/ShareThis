import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:sharethis/core/errors/failures.dart';
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/entities/device.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class ConnectToDevice implements UseCase<VoidResult, ConnectToDeviceParams> {
  final P2PConnectionRepository repository;
  ConnectToDevice(this.repository);

  @override
  Future<Either<Failure, VoidResult>> call(ConnectToDeviceParams params) async {
    final result = await repository.connectToDevice(params.device);
    return result.map((_) => VoidResult());
  }
}

class ConnectToDeviceParams extends Equatable {
  final P2PDevice device;
  const ConnectToDeviceParams({required this.device});

  @override
  List<Object?> get props => [device];
}