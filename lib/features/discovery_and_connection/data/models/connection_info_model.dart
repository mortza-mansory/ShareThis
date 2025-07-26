import 'package:sharethis/features/discovery_and_connection/domain/repositories/p2p_connection_repository.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

class ConnectionInfoModel extends ConnectionInfo {
  const ConnectionInfoModel({
    required super.isGroupFormed,
    required super.isGroupOwner,
    super.groupOwnerAddress,
  });

  factory ConnectionInfoModel.fromHotspotClientState(HotspotClientState state) {
    return ConnectionInfoModel(
      isGroupFormed: state.isActive,
      isGroupOwner: false,
      groupOwnerAddress: state.hostGatewayIpAddress,
    );
  }
}
