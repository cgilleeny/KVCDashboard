import 'eyepair_network_service.dart';
import 'eyepair_repository.dart';

class EyepairRepositoryInstance {
  static var repository =EyepairRepository(EyepairNetworkService());
}