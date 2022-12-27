// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
import 'package:azstore/azstore.dart';
import 'package:flutter/foundation.dart';

import '../../keys/azure_connection_strings.dart';
import '../model/filter.dart';
import '../model/eyepair.dart';
import '../model/page.dart';

class EyepairNetworkService {
  final AzureStorage storage;
  final String tableName;
  EyepairNetworkService(this.storage, this.tableName);

  Future<void> updateEyepair(String rowKey, Map<String, dynamic> map) {
    // var storage = AzureStorage.parse(dashboardScreeningConnectionString);
    return storage
        .upsertTableRow(
            tableName: tableName,
            partitionKey: 'main',
            rowKey: rowKey,
            bodyMap: map)
        .catchError((error) {
      throw Exception(error.toString());
    });
  }

  Future<EyepairPage> fetchEyepairs(
      Filter? filter, EyepairPage currentPage, int rowsPerPage) {
    return storage
        .filterNextTableRows(
            tableName: tableName,
            filter: filter?.toAzureStorageParameters() ?? '',
            top: rowsPerPage,
            nextPartitionKey: currentPage.nextPartitionKey,
            nextRowKey: currentPage.nextRowKey)
        .then((map) {
      final rows = map["Rows"];
      if (rows == null) {
        return throw Exception(
            'Expected non-null value for azure storage rows');
      }
      final List<EyePair> eyepairs = [];
      for (var row in rows) {
        try {
                    if (kDebugMode) {
            print(row);
          }
          eyepairs.add(EyePair.fromMap(row));
        } catch (error) {
          if (kDebugMode) {
            print(error.toString());
          }
        }
      }
      return EyepairPage(eyepairs,
          nextPartitionKey: map["NextPartitionKey"],
          nextRowKey: map["NextRowKey"]);
    }).catchError((error) {
      throw Exception(error.toString());
    });
  }
  // Future<EyepairPage> fetchEyepairs(http.Client client, Filter? filter,
  //     EyepairPage currentPage, int rowsPerPage) {
  //   const String baseURL =
  //       'https://uploadphotodata.table.core.windows.net/eyephotos';
  //   // final azure = Azure(dashboardScreeningConnectionString);
  //   final parameters = toParameters(filter, currentPage, rowsPerPage);
  //   // final url = Uri.parse('$baseURL?\$top=100');
  //   final url = Uri.parse('$baseURL$parameters');
  //   if (kDebugMode) {
  //     print(url);
  //   }
  //   String? nextPartitionKey;
  //   String? nextRowKey;
  //   return client
  //       .get(
  //     url,
  //     headers: getHeaders('eyephotos', dashboardScreeningConnectionString),
  //   )
  //       .then((response) {
  //     if (response.statusCode > 299) {
  //       final statusCode = response.statusCode;
  //       final reasonPhrase = response.reasonPhrase;
  //       throw Exception('Http response code: $statusCode. $reasonPhrase');
  //     }
  //     nextPartitionKey = response.headers["x-ms-continuation-nextpartitionkey"];
  //     nextRowKey = response.headers["x-ms-continuation-nextrowkey"];
  //     return json.decode(response.body);
  //   }).then((json) {
  //     final dashboardeyepairs = json['value'];
  //     if (dashboardeyepairs is! List<dynamic>) {
  //       expectedField('value');
  //     }
  //     final List<EyePair> eyepairs = [];
  //     for (var eyepair in dashboardeyepairs) {
  //       if (kDebugMode) {
  //         print(eyepair);
  //       }
  //       eyepairs.add(EyePair.fromMap(eyepair));
  //     }
  //     if (kDebugMode) {
  //       print("Number of eyepairs: ${eyepairs.length}");
  //     }
  //     return EyepairPage(eyepairs,
  //         nextPartitionKey: nextPartitionKey, nextRowKey: nextRowKey);
  //   }).catchError((error) {
  //     throw Exception(error.toString());
  //   });
  // }
}
