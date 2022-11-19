import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:go_check_kidz_dashboard/data/model/classification.dart';
import 'package:go_check_kidz_dashboard/data/model/page.dart';
import 'package:intl/intl.dart';

import 'data/model/filter.dart';

mixin Azure {
  List<int>? _storageKey;
  String? storageAccount;
  Map<String, String>? _config;


  void _parseConnectionString(connectionString) {
    try {
      Map<String, String> m = {};
      var items = connectionString.split(';');
      for (var item in items) {
        var i = item.indexOf('=');
        var key = item.substring(0, i);
        var val = item.substring(i + 1);
        m[key] = val;
      }
      _config = m;
      if (_config == null) {
        throw Exception('Connection String Parse error.');
      }
      if (!_config!.containsKey('AccountKey')) {
        throw Exception('Missing Azure Storage Account Key.');
      }
      if (!_config!.containsKey('AccountName')) {
        throw Exception('Missing Azure Storage Account Name.');
      }
      _storageKey = base64Decode(_config!['AccountKey']!);
      storageAccount = _config!['AccountName'];
    } catch (e) {
      throw Exception('Connection String Parse error.');
    }
  }

  String _getSignature(String message) {
    if (_storageKey == null) {
      throw Exception('Missing Azure Storage Account Key.');
    }
    List<int> messageBytes = utf8.encode(message);
    if (kDebugMode) {
      print(messageBytes.length);
    }
    // List<int> key = base64.decode(_storageKey);
    Hmac hmac = Hmac(sha256, _storageKey!);
    Digest digest = hmac.convert(messageBytes);

    return base64.encode(digest.bytes);
  }

  String _getUTCDate() {
    try {
      var f = DateFormat('E, dd MMM yyyy HH:mm:ss');
      var now = DateTime.now().toUtc();
      return '${f.format(now)} GMT';
    } catch (e) {
      // print('Error ******' + e.toString());
      rethrow;
    }
  }

  void expectedField(name) {
    throw Exception(
        'Invalid JSON data: expected field "$name" but did not find one');
  }

  String toParameters(
      Filter? filter, EyepairPage currentPage, int rowsPerPage) {
    var parameters = '?\$top=$rowsPerPage';
    if (currentPage.nextPartitionKey != null &&
        currentPage.nextRowKey != null) {
      parameters +=
          '&NextPartitionKey=${currentPage.nextPartitionKey!}&NextRowKey=${currentPage.nextRowKey!}';
    }
    if (filter == null) {
      return parameters;
    }
    bool firstFilter = true;
    if (filter.byDate != DateFilter.none && filter.range != null) {
      parameters +=
          '&\$filter=Timestamp ge datetime\'${filter.range!.start.toIso8601String()}\' and Timestamp le datetime\'${filter.range!.end.toIso8601String()}\'';
      firstFilter = false;
    }
    if (filter.byMLSymmetry != Classification.any) {
      if (firstFilter) {
        parameters += '&\$filter=';
        firstFilter = false;
      } else {
        parameters += ' and ';
      }
      parameters +=
          'status_symmetry eq \'${fromClassification(filter.byMLSymmetry)}\'';
    }
    if (filter.byHandLabeledSymmetry != Classification.any) {
      if (firstFilter) {
        parameters += '&\$filter=';
        firstFilter = false;
      } else {
        parameters += ' and ';
      }
      if (filter.byHandLabeledSymmetry == Classification.unprocessed) {
        parameters += 'not(symmetry_human_label gt \'\')';
      } else {
        parameters +=
            'symmetry_human_label eq \'${fromClassification(filter.byHandLabeledSymmetry)}\'';
      }
    }
    if (filter.byMLSingle != Classification.any) {
      String classification = filter.byMLSingle == Classification.error
          ? 'unusable'
          : fromClassification(filter.byMLSingle);
      if (firstFilter) {
        parameters += '&\$filter=';
        firstFilter = false;
      } else {
        parameters += ' and ';
      }
      parameters +=
          '(left_ml_result eq \'$classification\' or right_ml_result eq \'$classification\')';
    }
    if (filter.byHandLabeledSingle != Classification.any) {
      String classification = filter.byHandLabeledSingle == Classification.error
          ? 'unusable'
          : fromClassification(filter.byHandLabeledSingle);
      if (firstFilter) {
        parameters += '&\$filter=';
        firstFilter = false;
      } else {
        parameters += ' and ';
      }
      if (filter.byHandLabeledSingle == Classification.unprocessed) {
        parameters +=
            '(not(left_human_label gt \'\') or not(right_human_label gt \'\'))';
      } else {
        parameters +=
            '(left_human_label eq \'$classification\' or right_human_label eq \'$classification\')';
      }
    }
    return parameters;
  }

  String _sharedKeyLiteAuthorization(String utcDate, String path) {
    if (storageAccount == null) {
      throw Exception('Missing Azure Storage Account Name.');
    }

    final dataToEncode = "$utcDate\n/${storageAccount!}$path";
    // String signature = getSignature(dataToEncode);
    return "SharedKeyLite ${storageAccount!}:${_getSignature(dataToEncode)}";
  }

  String _sharedKeyAuthorization(String utcDate, String path, String verb) {
    if (storageAccount == null) {
      throw Exception('Missing Azure Storage Account Name.');
    }
    final dataToEncode =
        "$verb\n\n\n\nx-ms-date:$utcDate\n/${storageAccount!}$path";
    String signature = _getSignature(dataToEncode);
    return "SharedKey ${storageAccount!}:$signature";
  }

  Map<String, String> getHeaders(String tablename, String connectionString,
      {String whereClause = ''}) {
    _parseConnectionString(connectionString);
    final now = _getUTCDate();

    if (whereClause.isEmpty) {
      return {
        "Content-Type": "application/json",
        "x-ms-date": now,
        "Authorization": _sharedKeyLiteAuthorization(now, "/$tablename"),
        "x-ms-version": "2021-04-10",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, PUT",
        "Accept": "application/json;odata=nometadata",
        "DataServiceVersion": "3.0;NetFx",
        "MaxDataServiceVersion": "3.0;NetFx"
      };
    }
    return {
      "Content-Type": "application/json",
      "x-ms-date": now,
      "Authorization":
          _sharedKeyLiteAuthorization(now, "/$tablename$whereClause"),
      "x-ms-version": "2021-04-10",
      "Accept": "application/json;odata=nometadata",
      "DataServiceVersion": "3.0;NetFx",
      "MaxDataServiceVersion": "3.0;NetFx"
    };
  }

  Map<String, String> getBlobHeader(
      String pathSuffix, String connectionString) {
    _parseConnectionString(connectionString);
    final now = _getUTCDate();

    return {
      "x-ms-date": now,
      "Authorization": _sharedKeyAuthorization(now, pathSuffix, "GET"),
    };
  }
}
