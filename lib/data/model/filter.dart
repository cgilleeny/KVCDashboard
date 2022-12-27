import 'package:flutter/material.dart';

import './classification.dart';

enum DateFilter {
  none('None'),
  today('Today'),
  yesterday('Yesterday'),
  thisWeek('This Week'),
  lastWeek('Last Week'),
  thisMonth('This Month'),
  thisYear('This Year'),
  custom('Custom');

  const DateFilter(this.title);
  final String title;
}

class Filter {
  DateTimeRange? range;
  DateFilter byDate;
  Classification byMLSymmetry;
  Classification byHandLabeledSymmetry;
  Classification byMLSingle;
  Classification byHandLabeledSingle;

  Filter(
      {this.range,
      this.byDate = DateFilter.none,
      this.byMLSymmetry = Classification.any,
      this.byHandLabeledSymmetry = Classification.any,
      this.byMLSingle = Classification.any,
      this.byHandLabeledSingle = Classification.any});

  Filter copyWith(
      {DateTimeRange? range,
      DateFilter? byDate,
      Classification? byMLSymmetry,
      Classification? byHandLabeledSymmetry,
      Classification? byMLSingle,
      Classification? byHandLabeledSingle}) {
    return Filter(
        range: range ?? this.range,
        byDate: byDate ?? this.byDate,
        byMLSymmetry: byMLSymmetry ?? this.byMLSymmetry,
        byHandLabeledSymmetry:
            byHandLabeledSymmetry ?? this.byHandLabeledSymmetry,
        byMLSingle: byMLSingle ?? this.byMLSingle,
        byHandLabeledSingle: byHandLabeledSingle ?? this.byHandLabeledSingle);
  }

  bool get isDefault {
    return byDate == DateFilter.none &&
        byMLSymmetry == Classification.any &&
        byHandLabeledSymmetry == Classification.any &&
        byMLSingle == Classification.any &&
        byHandLabeledSingle == Classification.any;
  }

  String toAzureStorageParameters() {
    String parameters = '';
    if (byDate != DateFilter.none && range != null) {
      parameters +=
          'Timestamp ge datetime\'${range!.start.toIso8601String()}\' and Timestamp le datetime\'${range!.end.toIso8601String()}\'';

    }
    if (byMLSymmetry != Classification.any) {
      if (parameters.isNotEmpty) {
        parameters += ' and ';
      }
      parameters +=
          'status_symmetry eq \'${fromClassification(byMLSymmetry)}\'';
    }
    if (byHandLabeledSymmetry != Classification.any) {
      if (parameters.isNotEmpty) {
        parameters += ' and ';
      }
      if (byHandLabeledSymmetry == Classification.unprocessed) {
        parameters += 'not(symmetry_human_label gt \'\')';
      } else {
        parameters +=
            'symmetry_human_label eq \'${fromClassification(byHandLabeledSymmetry)}\'';
      }
    }
    if (byMLSingle != Classification.any) {
      String classification = byMLSingle == Classification.error
          ? 'unusable'
          : fromClassification(byMLSingle);
      if (parameters.isNotEmpty) {
        parameters += ' and ';
      }
      parameters +=
          '(left_ml_result eq \'$classification\' or right_ml_result eq \'$classification\')';
    }
    if (byHandLabeledSingle != Classification.any) {
      String classification = byHandLabeledSingle == Classification.error
          ? 'unusable'
          : fromClassification(byHandLabeledSingle);
      if (parameters.isNotEmpty) {
        parameters += ' and ';
      }
      if (byHandLabeledSingle == Classification.unprocessed) {
        parameters +=
            '(not(left_human_label gt \'\') or not(right_human_label gt \'\'))';
      } else {
        parameters +=
            '(left_human_label eq \'$classification\' or right_human_label eq \'$classification\')';
      }
    }
    return parameters;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Filter &&
        other.range == range &&
        other.byDate == byDate &&
        other.byMLSymmetry == byMLSymmetry &&
        other.byHandLabeledSymmetry == byHandLabeledSymmetry &&
        other.byMLSingle == byMLSingle &&
        other.byHandLabeledSingle == byHandLabeledSingle;
  }

  @override
  int get hashCode => super.hashCode;
}
