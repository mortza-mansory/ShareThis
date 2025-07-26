
import 'package:sharethis/core/usecases/usecase.dart';
import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';

class GetIncomingFileAnnouncements implements StreamUseCase<FileTransferInfo, NoParams> {
  final P2PConnectionRepository repository;
  GetIncomingFileAnnouncements(this.repository);

  @override
  Stream<FileTransferInfo> call(NoParams params) {
    return repository.receiveFile(''); // The parameter 'saveDirectory' is not used for just announcements.
  }
}