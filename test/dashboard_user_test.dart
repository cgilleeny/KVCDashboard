import 'package:flutter_test/flutter_test.dart';
import 'package:go_check_kidz_dashboard/data/model/dashboard_user.dart';

void main() {
  test('Constructor should throw exception', () {
    expect(() => DashboardUser.fromJson(const {'read': true, 'write': true, 'admin': true}), throwsA(isA<Exception>()));
  });
}
