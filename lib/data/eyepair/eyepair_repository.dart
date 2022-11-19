import 'package:go_check_kidz_dashboard/data/eyepair/eyepair_network_service.dart';

import '../model/eyepair.dart';
import '../model/filter.dart';
import '../model/page.dart';

class EyepairRepository {
  final EyepairNetworkService networkService;
  List<EyepairPage> pages = [];
  Filter? filter;
  int rowsPerPage = 10;

  EyepairRepository(this.networkService);

  Future<EyepairPage> fetchEyepairsFirst(Filter? filter,
      {rowsPerPage = 10}) async {
    filter = filter;
    rowsPerPage = rowsPerPage;

    final page = await networkService.fetchEyepairs(
        filter, EyepairPage(<EyePair>[]), rowsPerPage);
    page.pageIndex = 0;
    pages = [page];
    return page;
  }

  Future<EyepairPage> fetchEyepairs(int pageIndex) async {
    if (pages.length > pageIndex) {
      return pages[pageIndex];
    }
    final page =
        await networkService.fetchEyepairs(filter, pages.last, rowsPerPage);
    page.pageIndex = pageIndex;
    pages.add(page);
    return page;
  }
}
