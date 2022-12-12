import 'package:equatable/equatable.dart';
import 'dart:convert';

class DashboardUser extends Equatable {
  final String email;
  final bool read;
  final bool write;
  final bool admin;

  const DashboardUser(
      {required this.email,
      required this.read,
      required this.write,
      required this.admin});

  DashboardUser.fromJson(Map<String, dynamic> map)
      : email = map["RowKey"].runtimeType == String ? map["RowKey"] : 'unknown',
        read = map["read"].runtimeType == bool ? map["read"] : false,
        write = map["write"].runtimeType == bool ? map["write"] : false,
        admin = map["admin"].runtimeType == bool ? map["admin"] : false;

  String toJson() {
    const JsonEncoder encoder = JsonEncoder();
    if (email == 'unknown') {
      throw Exception('Missing Dashboard \'RowKey\' required for updating record');
    }
    var resBody = {};
    resBody["PartitionKey"] = "main";
    resBody["RowKey"] = email;
    resBody["read"] = read;
    resBody["write"] = write;
    resBody["admin"] = admin;
    return encoder.convert(resBody);
  }

  @override
  List<Object?> get props => [email, read, write, admin];
}
