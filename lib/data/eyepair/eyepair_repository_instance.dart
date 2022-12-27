import 'package:azstore/azstore.dart';

import '../../keys/azure_connection_strings.dart';
import 'eyepair_network_service.dart';
import 'eyepair_repository.dart';

class EyepairRepositoryInstance {
  static var repository = EyepairRepository(EyepairNetworkService(AzureStorage.parse(dashboardScreeningConnectionString), 'eyephotos'));
}