// To parse this JSON data, do
//
//     final loginResult = loginResultFromJson(jsonString);

import 'dart:convert';

List<LoginResult> loginResultFromJson(String str) => List<LoginResult>.from(
    json.decode(str).map((x) => LoginResult.fromJson(x)));

String loginResultToJson(List<LoginResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginResult {
  LoginResult({
    this.rowId,
    this.empCode,
    this.empName,
    this.empLname,
    this.empPosition,
    this.empSection,
    this.empDepartment,
    this.empUsername,
    this.empPassword,
    this.empEmail,
    this.empStatus,
    this.createDate,
    this.authDate,
  });

  int rowId;
  String empCode;
  String empName;
  String empLname;
  String empPosition;
  String empSection;
  String empDepartment;
  String empUsername;
  String empPassword;
  String empEmail;
  String empStatus;
  String createDate;
  String authDate;

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        rowId: json["rowID"] == null ? null : json["rowID"],
        empCode: json["empCode"] == null ? null : json["empCode"],
        empName: json["empName"] == null ? null : json["empName"],
        empLname: json["empLname"] == null ? null : json["empLname"],
        empPosition: json["empPosition"] == null ? null : json["empPosition"],
        empSection: json["empSection"] == null ? null : json["empSection"],
        empDepartment:
            json["empDepartment"] == null ? null : json["empDepartment"],
        empUsername: json["empUsername"] == null ? null : json["empUsername"],
        empPassword: json["empPassword"] == null ? null : json["empPassword"],
        empEmail: json["empEmail"] == null ? null : json["empEmail"],
        empStatus: json["empStatus"] == null ? null : json["empStatus"],
        createDate: json["createDate"] == null ? null : json["createDate"],
        authDate: json["authDate"] == null ? null : json["authDate"],
      );

  Map<String, dynamic> toJson() => {
        "rowID": rowId == null ? null : rowId,
        "empCode": empCode == null ? null : empCode,
        "empName": empName == null ? null : empName,
        "empLname": empLname == null ? null : empLname,
        "empPosition": empPosition == null ? null : empPosition,
        "empSection": empSection == null ? null : empSection,
        "empDepartment": empDepartment == null ? null : empDepartment,
        "empUsername": empUsername == null ? null : empUsername,
        "empPassword": empPassword == null ? null : empPassword,
        "empEmail": empEmail == null ? null : empEmail,
        "empStatus": empStatus == null ? null : empStatus,
        "createDate": createDate == null ? null : createDate,
        "authDate": authDate == null ? null : authDate,
      };
}
