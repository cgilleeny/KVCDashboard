import 'package:flutter_test/flutter_test.dart';
import 'package:go_check_kidz_dashboard/data/model/classification.dart';
import 'package:go_check_kidz_dashboard/data/model/eyepair.dart';
import 'package:go_check_kidz_dashboard/data/eyepair/eyepair_network_service.dart';
import 'package:go_check_kidz_dashboard/data/model/filter.dart';
import 'package:go_check_kidz_dashboard/data/model/page.dart';
import 'package:go_check_kidz_dashboard/keys/azure_connection_strings.dart';
import 'package:azstore/azstore.dart';

void main() {
  group('eyepair API call', () {
    // ARRANGE
    final storage = AzureStorage.parse(dashboardScreeningConnectionString);


    test('Should return list of first 2 eyepairs & next page values', () async {

          for (var i = 1; i < 4; i++) {
      final eyepair = EyePair(rowKey: '$i', symmetryHumanLabel: 'ok');
      await storage.upsertTableRow(
          tableName: 'testeyephotos', partitionKey: 'main', rowKey: '$i', body: eyepair.toJson());
    }
      final networkService =
          EyepairNetworkService(storage, 'testeyephotos');

      final page =
          await networkService.fetchEyepairs(null, EyepairPage(<EyePair>[]), 2);

      // ACT && ASSERT
      expect(page, isA<EyepairPage>());

      expect(page.eyepairs.length, 2);
      expect(page.nextPartitionKey, isNotNull);
      expect(page.nextRowKey, isNotNull);
    });

    test('Should return list of last eyepair & no next page values', () async {
      final networkService =
          EyepairNetworkService(storage, 'testeyephotos');

      final page =
          await networkService.fetchEyepairs(null, EyepairPage(<EyePair>[]), 2);
      final lastPage = await networkService.fetchEyepairs(null, page, 2);

      // ACT && ASSERT
      expect(lastPage, isA<EyepairPage>());

      expect(lastPage.eyepairs.length, 1);
      expect(lastPage.nextPartitionKey, isNull);
      expect(lastPage.nextRowKey, isNull);
    });

    test('Should update an eye screening', () async {
      // ARRANGE

      final networkService =
          EyepairNetworkService(storage, 'testeyephotos');

      Map<String, dynamic> map = {"symmetry_human_label": 'refer'};

      // ACT && ASSERT
      await networkService.updateEyepair('1', map);
      final page =
          await networkService.fetchEyepairs(null, EyepairPage(<EyePair>[]), 2);
      expect(page.eyepairs[0].symmetryHumanLabel, Classification.refer);
    });

    test('Should return filtered list of one eyepair & no next page values', () async {
      // ARRANGE
      final networkService =
          EyepairNetworkService(storage, 'testeyephotos');
final page =
          await networkService.fetchEyepairs(Filter(byHandLabeledSymmetry: Classification.refer), EyepairPage(<EyePair>[]), 2);

      // ACT && ASSERT
      expect(page, isA<EyepairPage>());

      expect(page.eyepairs.length, 1);
      expect(page.nextPartitionKey, isNull);
      expect(page.nextRowKey, isNull);
    });
  });
}
