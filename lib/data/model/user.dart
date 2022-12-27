import 'dart:convert';

import 'package:equatable/equatable.dart';

class AzureUser extends Equatable {
  final String email;
  final bool read;
  final bool write;
  final bool admin;

  const AzureUser(
      {required this.email,
      required this.read,
      required this.write,
      required this.admin});
  static AzureUser fromMap(Map<String, dynamic> map) {
    return AzureUser(
      email: map["RowKey"].runtimeType == String ? map["RowKey"] : 'unknown',
      read: map["read"].runtimeType == bool ? map["read"] : false,
      write: map["write"].runtimeType == bool ? map["write"] : false,
      admin: map["admin"].runtimeType == bool ? map["admin"] : false,
    );
  }

  String toJson() {
    const JsonEncoder encoder = JsonEncoder();
    if (email == 'unknown') {
      throw Exception('Missing Azure \'RowKey\' required for updating record');
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
  // TODO: implement props
  List<Object?> get props => [email, read, write, admin];

  static List<AzureUser> azureUsers = [
    const AzureUser(
      email: 'gilleenyc@gmail.com',
      read: true,
      write: true,
      admin: true,
    ),
    const AzureUser(
      email: 'evantagedirect@gmail.com',
      read: true,
      write: true,
      admin: true,
    ),
  ];
}
