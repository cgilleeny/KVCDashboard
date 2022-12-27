// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
import 'package:azstore/azstore.dart';
import 'dart:typed_data';

// import '../../azure.dart';
import '../../keys/azure_connection_strings.dart';

class ImageNetworkService {
  Future<Uint8List?> fetchImage(
    String rowKey,
    String suffix,
  ) {
    final storage = AzureStorage.parse(dashboardImageConnectionString);
    // const String baseURL = 'https://uploadphotodata.blob.core.windows.net';

    return storage
        .getBlob("/data/$rowKey/$rowKey$suffix")
        .then((response) async {
          if (response.statusCode > 299) {
            if (response.statusCode == 404) {
              return null;
            }
            final statusCode = response.statusCode;
            final reasonPhrase = response.reasonPhrase;
            return throw Exception(
                'Http response code: $statusCode. $reasonPhrase');
          }
          return await response.stream.toBytes();
        }).catchError((error) {
          throw Exception(error.toString());
        });
  }

  // Future<Uint8List?> fetchImage(
  //   http.Client client,
  //   String rowKey,
  //   String suffix,
  // ) {
  //   const String baseURL = 'https://uploadphotodata.blob.core.windows.net';

  //   final path = "/data/$rowKey/$rowKey$suffix";

  //   if (kDebugMode) {
  //     print(path);
  //   }

  //   final url = Uri.parse("$baseURL$path");
  //   Map<String, String> headers =
  //       getBlobHeader(path, dashboardImageConnectionString);

  //   return client
  //       .get(
  //     url,
  //     headers: headers,
  //   )
  //       .then((response) async {
  //     if (response.statusCode > 299) {
  //       if (response.statusCode == 404) {
  //         return null;
  //       }
  //       final statusCode = response.statusCode;
  //       final reasonPhrase = response.reasonPhrase;
  //       throw Exception('Http response code: $statusCode. $reasonPhrase');
  //     }
  //     return response.bodyBytes;
  //   }).catchError((error) {
  //     throw Exception(error.toString());
  //   });
  // }
}
