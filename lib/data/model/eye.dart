import 'dart:typed_data';
import 'package:flutter/material.dart';

import './classification.dart';

class Eye {
  final Classification mlResult;
  final double? mlConfidenceNormal;
  final double? mlConfidenceAbnormal;
  Classification humanLabel;
  Uint8List? detectionImageBytes;
  MemoryImage? detectionImage;
  Uint8List? symmetryImageBytes;

  // set human(Classification newHuman) {
  //   humanLabel = newHuman;
  // }

  Eye(mlResult, mlConfidenceNormal, mlConfidenceAbnormal, humanLabel)
      : mlResult = toClassification(mlResult),
        mlConfidenceNormal = mlConfidenceNormal != null
            ? double.tryParse(mlConfidenceNormal)
            : null,
        mlConfidenceAbnormal = mlConfidenceAbnormal != null
            ? double.tryParse(mlConfidenceAbnormal)
            : null,
        humanLabel = toClassification(humanLabel);

  Eye.fromJson(Map<String, dynamic> map, String eye)
  : mlResult = map["${eye}_ml_result"].runtimeType == String
          ? toClassification(map["${eye}_ml_result"])
          : Classification.unprocessed,
      mlConfidenceNormal = map["${eye}_ml_confidence_normal"].runtimeType == String
          ? double.tryParse(map["${eye}_ml_confidence_normal"])
          : null,
      mlConfidenceAbnormal = map["${eye}_ml_confidence_abnormal"].runtimeType == String
          ? double.tryParse(map["${eye}_ml_confidence_abnormal"])
          : null,
      humanLabel = map["${eye}_human_label"].runtimeType == String
          ? toClassification(map["${eye}_human_label"])
          : Classification.unprocessed;

  // static Eye fromMap(Map<String, dynamic> map, String eye) {
  //   return Eye(
  //     map["${eye}_ml_result"].runtimeType == String
  //         ? map["${eye}_ml_result"]
  //         : null,
  //     map["${eye}_ml_confidence_normal"].runtimeType == String
  //         ? map["${eye}_ml_confidence_normal"]
  //         : null,
  //     map["${eye}_ml_confidence_abnormal"].runtimeType == String
  //         ? map["${eye}_ml_confidence_abnormal"]
  //         : null,
  //     map["${eye}_human_label"].runtimeType == String
  //         ? map["${eye}_human_label"]
  //         : null,
  //   );
  // }
}
