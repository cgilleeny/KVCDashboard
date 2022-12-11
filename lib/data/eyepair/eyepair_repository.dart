import 'dart:convert';

import 'package:go_check_kidz_dashboard/data/eyepair/eyepair_network_service.dart';

import '../model/eyepair.dart';
import '../model/filter.dart';
import '../model/page.dart';

class EyepairRepository {
  final EyepairNetworkService networkService;
  List<EyepairPage> _pages = [];
  Filter? _filter;
  int _rowsPerPage = 10;

  EyepairRepository(this.networkService);

  Future<EyepairPage> fetchEyepairsFirst(Filter? filter,
      {rowsPerPage = 10}) async {
    _filter = filter?.copyWith();
    _rowsPerPage = rowsPerPage;

    final page = await networkService.fetchEyepairs(
        filter, EyepairPage(<EyePair>[]), _rowsPerPage);
    page.pageIndex = 0;
    _pages = [page];
    return page;
  }

  Future<EyepairPage> fetchEyepairs(int pageIndex) async {
    if (_pages.length > pageIndex) {
      return _pages[pageIndex];
    }
    final page =
        await networkService.fetchEyepairs(_filter, _pages.last, _rowsPerPage);
    page.pageIndex = pageIndex;
    _pages.add(page);
    return page;
  }

  Future<String> updateEyepair(
      String rowKey, Map<String, dynamic> map) async {
    const JsonEncoder encoder = JsonEncoder();
    final body = encoder.convert(map);
    await networkService.updateEyepair(rowKey, body);
    return map.values.first;
  }

  Filter? fetchFilter() {
    return _filter;
  }
}
