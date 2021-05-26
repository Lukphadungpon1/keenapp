import 'package:sembast/sembast.dart';

class mUser {
  String empCode;
  String empName;
  String empLname;
  String empPosition;
  String empSection;
  String empDepartment;
  String empUsername;
  String empPassword;
  String empEmail;

  mUser(
      {this.empCode,
      this.empName,
      this.empLname,
      this.empPosition,
      this.empSection,
      this.empDepartment,
      this.empUsername,
      this.empPassword,
      this.empEmail});

  static toJson(mUser post) {
    return {
      'empCode': post.empCode,
      'empName': post.empName,
      'empLname': post.empLname,
      'empSection': post.empSection,
      'empPosition': post.empPosition,
      'empDepartment': post.empDepartment,
      'empUsername': post.empUsername,
      'empPassword': post.empPassword,
      'empEmail': post.empEmail
    };
  }

  static mUser fromList(List<mUser> UserList) {
    UserList.forEach((e) {
      return mUser(
          empCode: e.empCode,
          empName: e.empName,
          empLname: e.empLname,
          empPosition: e.empPosition,
          empSection: e.empSection,
          empDepartment: e.empDepartment,
          empUsername: e.empUsername,
          empPassword: e.empPassword,
          empEmail: e.empEmail);
    });
  }

  static mUser fromRecord(RecordSnapshot record) {
    var post = mUser(
        empCode: record['empCode'],
        empName: record['empName'],
        empLname: record['empLname'],
        empSection: record['empSection'],
        empPosition: record['empPosition'],
        empDepartment: record['empDepartment'],
        empUsername: record['empUsername'],
        empPassword: record['empPassword'],
        empEmail: record['empEmail']);
    return post;
  }
}
