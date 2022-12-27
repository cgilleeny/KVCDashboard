import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_check_kidz_dashboard/data/model/classification.dart';
import 'package:go_check_kidz_dashboard/data/model/filter.dart';

void main() {
  group('filter model', () {
    test('default constructor', () {
      final filter = Filter();
      expect(filter, isA<Filter>());
      expect(filter.isDefault, true);
    });

    test('copyWith range', () {
      final filter = Filter();
      final newFilter = filter.copyWith(
          range: DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 1)),
              end: DateTime.now()));
      expect(newFilter, isA<Filter>());
      expect(newFilter.range, isA<DateTimeRange>());
      expect(newFilter.isDefault, true);
    });

    test('copyWith byDate & azure parameters', () {
      final filter = Filter();
      final today = DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 1)),
              end: DateTime.now());
      final newFilter = filter.copyWith(range: today, byDate: DateFilter.today);
      expect(newFilter, isA<Filter>());
      expect(newFilter.byDate, isA<DateFilter>());
      expect(newFilter.isDefault, false);
                  expect(
        newFilter.toAzureStorageParameters(),
        'Timestamp ge datetime\'${today.start.toIso8601String()}\' and Timestamp le datetime\'${today.end.toIso8601String()}\'',
      );
    });

    test('copyWith byHandLabeledSingle & azure parameters', () {
      final filter = Filter();
      final newFilter =
          filter.copyWith(byHandLabeledSingle: Classification.refer);
      expect(newFilter, isA<Filter>());
      expect(newFilter.byHandLabeledSingle, Classification.refer);
      expect(newFilter.isDefault, false);
            expect(
        newFilter.toAzureStorageParameters(),
        '(left_human_label eq \'${fromClassification(Classification.refer)}\' or right_human_label eq \'${fromClassification(Classification.refer)}\')'
      );
    });

    test('copyWith byHandLabeledSymmetry & azure parameters', () {
      final filter = Filter();
      final newFilter =
          filter.copyWith(byHandLabeledSymmetry: Classification.refer);
      expect(newFilter, isA<Filter>());
      expect(newFilter.byHandLabeledSymmetry, Classification.refer);
      expect(newFilter.isDefault, false);
      expect(
        newFilter.toAzureStorageParameters(),
        'symmetry_human_label eq \'${fromClassification(Classification.refer)}\''
      );
    });

    test('copyWith byMLSingle & azure parameters', () {
      final filter = Filter();
      final newFilter = filter.copyWith(byMLSingle: Classification.ok);
      expect(newFilter, isA<Filter>());
      expect(newFilter.byMLSingle, Classification.ok);
      expect(newFilter.isDefault, false);
      expect(newFilter.toAzureStorageParameters(),
          '(left_ml_result eq \'${fromClassification(Classification.ok)}\' or right_ml_result eq \'${fromClassification(Classification.ok)}\')');
    });

    test('copyWith byMLSymmetry & azure parameters', () {
      final filter = Filter();
      final newFilter = filter.copyWith(byMLSymmetry: Classification.ok);
      expect(newFilter, isA<Filter>());
      expect(newFilter.byMLSymmetry, Classification.ok);
      expect(newFilter.isDefault, false);

      expect(newFilter.toAzureStorageParameters(),
          'status_symmetry eq \'${fromClassification(Classification.ok)}\'');
    });

        test('copyWith all & azure parameters', () {
      final filter = Filter();
            final today = DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 1)),
              end: DateTime.now());
      final newFilter = filter.copyWith(range: today, byDate: DateFilter.today, byHandLabeledSingle: Classification.refer, byHandLabeledSymmetry: Classification.refer, byMLSymmetry: Classification.ok, byMLSingle: Classification.ok);
      expect(newFilter, isA<Filter>());
      expect(newFilter.byMLSymmetry, Classification.ok);
      expect(newFilter.isDefault, false);
      final expectedParamater = 'Timestamp ge datetime\'${today.start.toIso8601String()}\' and Timestamp le datetime\'${today.end.toIso8601String()}\' and ' +
          'status_symmetry eq \'${fromClassification(Classification.ok)}\' and ' + 
          'symmetry_human_label eq \'${fromClassification(Classification.refer)}\' and ' +
          '(left_ml_result eq \'${fromClassification(Classification.ok)}\' or right_ml_result eq \'${fromClassification(Classification.ok)}\') and ' +
          '(left_human_label eq \'${fromClassification(Classification.refer)}\' or right_human_label eq \'${fromClassification(Classification.refer)}\')'
          ;
      expect(newFilter.toAzureStorageParameters(),
          expectedParamater,) ;
    });
  });
}
