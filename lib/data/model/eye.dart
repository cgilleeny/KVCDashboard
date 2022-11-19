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

  static Eye fromMap(Map<String, dynamic> map, String eye) {
    return Eye(
      map["${eye}_ml_result"].runtimeType == String
          ? map["${eye}_ml_result"]
          : null,
      map["${eye}_ml_confidence_normal"].runtimeType == String
          ? map["${eye}_ml_confidence_normal"]
          : null,
      map["${eye}_ml_confidence_abnormal"].runtimeType == String
          ? map["${eye}_ml_confidence_abnormal"]
          : null,
      map["${eye}_human_label"].runtimeType == String
          ? map["${eye}_human_label"]
          : null,
    );
  }
}
