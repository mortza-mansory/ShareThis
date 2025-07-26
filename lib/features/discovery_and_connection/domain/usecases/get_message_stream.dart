import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class GetMessageStream implements StreamUseCase<String, NoParams> {
  final P2PConnectionRepository repository;
  GetMessageStream(this.repository);

  @override
  Stream<String> call(NoParams params) {
    return repository.messageStream;
  }
}
