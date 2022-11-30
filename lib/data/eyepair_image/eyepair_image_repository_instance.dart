import 'eyepair_image_network_service.dart';
import 'eyepair_image_repository.dart';

class ImageEyepairRepositoryInstance {
  static var repository = ImageRepository(ImageNetworkService());
}