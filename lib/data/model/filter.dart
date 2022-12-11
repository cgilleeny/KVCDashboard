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
}
