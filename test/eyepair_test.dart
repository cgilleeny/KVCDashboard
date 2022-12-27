import 'package:flutter_test/flutter_test.dart';
import 'package:go_check_kidz_dashboard/data/model/eyepair.dart';

void main() {
  group('eyepair model', () {
  test('Constructor should throw exception', () {
    expect(() => EyePair.fromMap(const {'read': true, 'write': true, 'admin': true}), throwsA(isA<Exception>()));
  });
          test('Constructor should succeed', () {
            final Map<String, dynamic> map = {"PartitionKey": "main", "RowKey": "0123542929543475890fa40a5d728de6", "Timestamp": "2022-12-15T17:31:06.8389999Z", "assymetry": 1.03912984843459, "final_result": "refer", "key": "0123542929543475890fa40a5d728de6", "left_ml_confidence_abnormal": -0.7014425992965698, "left_ml_confidence_normal": 0.8735707402229309, "left_ml_result": "ok", "manufacturer": "IOS", "model": "Phone", "right_ml_confidence_abnormal": 0.8828292489051819, "right_ml_confidence_normal": -0.7828400135040283, "right_ml_result": "refer", "status": "processed", "status_single_detection": "refer", "status_symmetry": "ok", "subject_id": "None", "taken_on": "2022-12-15"};
    expect(EyePair.fromMap(map), isA<EyePair>());
  });  });

}