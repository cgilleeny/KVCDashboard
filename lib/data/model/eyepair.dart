import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import './classification.dart';
import './eye.dart';

class EyePair {
  Eye? left;
  Eye? right;
  final String rowKey;
  String? partitionKey;
  final DateTime? timestamp;
  String? key;
  String? updatedon;
  String? takenon;
  String? manufacturer;
  String? model;
  String? symmetry;
  String? status;
  final Classification statusSymmetry;
  Classification symmetryHumanLabel;
  final Classification? statusSingleDetection;
  Uint8List? fullImageBytes;
  MemoryImage? fullImage;

  // set symmetryHuman(Classification newSymmetryHuman) {
  //   symmetryHumanLabel = newSymmetryHuman;
  // }

  EyePair(
      {this.left,
      this.right,
      required this.rowKey,
      this.partitionKey,
      timestamp,
      key,
      this.takenon,
      this.manufacturer,
      this.model,
      this.symmetry,
      this.status,
      statusSymmetry,
      symmetryHumanLabel,
      statusSingleDetection})
      : statusSymmetry = toClassification(statusSymmetry),
        symmetryHumanLabel = toClassification(symmetryHumanLabel),
        statusSingleDetection = toClassification(statusSingleDetection),
        timestamp = timestamp != null ? DateTime.parse(timestamp) : null;

  static EyePair fromMap(Map<String, dynamic> map) {
    final left = Eye.fromMap(map, "left");
    final right = Eye.fromMap(map, "right");
    return EyePair(
        left: left,
        right: right,
        rowKey: map["RowKey"].runtimeType == String ? map["RowKey"] : 'Unknown RowKey',
        partitionKey: map["PartitionKey"].runtimeType == String
            ? map["PartitionKey"]
            : null,
        timestamp:
            map["Timestamp"].runtimeType == String ? map["Timestamp"] : null,
        key: map["key"].runtimeType == String ? map["key"] : null,
        takenon: map["taken_on"].runtimeType == String ? map["taken_on"] : null,
        manufacturer: map["manufacturer"].runtimeType == String
            ? map["manufacturer"]
            : null,
        model: map["model"].runtimeType == String ? map["model"] : null,
        symmetry:
            map["symmetry"].runtimeType == String ? map["symmetry"] : null,
        status: map["status"].runtimeType == String ? map["status"] : null,
        statusSymmetry: map["status_symmetry"].runtimeType == String
            ? map["status_symmetry"]
            : null,
        symmetryHumanLabel: map["symmetry_human_label"].runtimeType == String
            ? map["symmetry_human_label"]
            : null,
        statusSingleDetection:
            map["status_single_detection"].runtimeType == String
                ? map["status_single_detection"]
                : null);
  }

  String toJson() {
    const JsonEncoder encoder = JsonEncoder();
    if (rowKey == 'Unknown RowKey') {
      throw Exception('Missing Azure \'RowKey\' required for updating record');
    }
    var resBody = {};
    resBody["PartitionKey"] = "main";
    resBody["RowKey"] = rowKey;
    if (timestamp != null) {
      resBody["Timestamp"] = timestamp?.toIso8601String();
    }
    if (key != null) {
      resBody["key"] = key;
    }
    if (takenon != null) {
      resBody["taken_on"] = takenon;
    }

    if (manufacturer != null) {
      resBody["manufacturer"] = manufacturer;
    }
    if (model != null) {
      resBody["model"] = model;
    }

    if (symmetry != null) {
      resBody["symmetry"] = symmetry;
    }
    if (status != null) {
      resBody["status"] = status;
    }
    if (statusSingleDetection != null) {
      resBody["status_single_detection"] =
          fromClassification(statusSingleDetection!);
    }
    resBody["status_symmetry"] = fromClassification(statusSymmetry);
    resBody["symmetry_human_label"] = fromClassification(symmetryHumanLabel);
    if (left != null) {
      resBody["left_ml_result"] = fromClassification(left!.mlResult);
      resBody["left_human_label"] = fromClassification(left!.humanLabel);
      if (left!.mlConfidenceAbnormal != null) {
        resBody["left_ml_confidence_abnormal"] = left!.mlConfidenceAbnormal!;
      }
      if (left!.mlConfidenceNormal != null) {
        resBody["left_ml_confidence_normal"] = left!.mlConfidenceNormal!;
      }
    }
    if (right != null) {
      resBody["right_ml_result"] = fromClassification(right!.mlResult);
      resBody["right_human_label"] = fromClassification(right!.humanLabel);
      if (right!.mlConfidenceAbnormal != null) {
        resBody["right_ml_confidence_abnormal"] = right!.mlConfidenceAbnormal!;
      }
      if (right!.mlConfidenceNormal != null) {
        resBody["right_ml_confidence_normal"] = right!.mlConfidenceNormal!;
      }
    }
    return encoder.convert(resBody);
  }
}
