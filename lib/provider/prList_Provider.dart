import 'dart:convert';
import 'package:keenapp/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:keenapp/modal/PRApproveList.dart';

import 'package:http/http.dart' as http;
import 'package:keenapp/modal/mSelectBox.dart';

class PRListProvider with ChangeNotifier {
  List<PrApproveList> _data = [];

  List<PrApproveList> get prList => [..._data];

  addNew(PrApproveList post) async {
    _data.add(post);
    notifyListeners();
  }

  List<PrApproveList> getPRNumber(String prNumber) {
    var _datafilter =
        _data.firstWhere((element) => element.prNumber == prNumber);

    List<PrApproveList> aaa = [];

    aaa.add(_datafilter);
    return aaa;
  }

  getAll(String userEmail, String department, String _PRNumbersc,
      String requireDate, String detail, String chkCodition) async {
    List<PrApproveList> _dataFromAPI;

    var url = Uri.parse('${URLAPI}PR/GetPRApprove/');

    var respon = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": userEmail,
        "department": department == null ? "" : department,
        "PRNumber": _PRNumbersc == null ? "" : _PRNumbersc,
        "requireDate": requireDate == null ? "" : requireDate,
        "detail": detail == null ? "" : detail,
        "chkCodition": chkCodition == "" ? "" : chkCodition
      }),
    );
    //print(respon.body);
    _dataFromAPI = prApproveListFromJson(respon.body);
    // print(_dataFromAPI.length);

    _data.clear();

    _dataFromAPI.forEach((element) {
      _data.add(element);
    });

    notifyListeners();
  }

  approve(String Email, String Users, String PRNumber, String Comment,
      String status) async {
    String _status;
    if (status == "Approve") {
      _status = "Approved";
    } else if (status == "Reject") {
      _status = "Reject";
    }

    var url = Uri.parse('${URLAPI}PR/ApprovedPR?clientName=mobile');

    var respon = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "PRNumber": PRNumber,
        "status": _status == null ? "" : _status,
        "users": Users == null ? "" : Users,
        "email": Email == null ? "" : Email,
        "comment": Comment == null ? "" : Comment,
        "levels": '1'
      }),
    );

    await getAll(Email, '', '', '', '', '');
    if (respon.body.toString() == '"Wait For PO"') {
      await generatePDF(PRNumber, 'mobile');
      await convertPRPO(PRNumber, 'mobile', Users);
    }

    print(respon.body);

    return respon.body.toString();
  }

  notapprove(String Email, String Users, String PRNumber, String Comment,
      String status) async {
    var url = Uri.parse('${URLAPI}PR/notApprovePR?clientName=mobile');

    var respon = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "PRNumber": PRNumber,
        "status": status == null ? "" : status,
        "users": Users == null ? "" : Users,
        "email": Email == null ? "" : Email,
        "comment": Comment == null ? "" : Comment,
        "levels": '1'
      }),
    );

    print(respon.body);
    return respon.body.toString();
  }

  sendmailNF(String PRNumber, String type, String email) async {
    String check = 'False';
    var url = Uri.parse(
        '${URLAPI}PR/SendEmailNF?PRNumber=${PRNumber}&type=${type}&email=${email}');

    var respon = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    check = respon.body.toString();
    return check;
  }

  generatePDF(String PRNumber, String name) async {
    String check = 'False';

    var url = Uri.parse(
        '${URLAPI}PR/generatePDF?clientName=${name}&PRNumber=${PRNumber}');

    var respon = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    check = respon.body.toString();

    return check;
  }

  convertPRPO(String PRNumber, String name, String username) async {
    String check = 'False';

    var url = Uri.parse(
        '${URLAPI}PR/convertPRPO?clientName=${name}&PRNumber=${PRNumber}&Username=${username}');

    var respon = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    check = respon.statusCode.toString();

    return check;
  }

  clearUser() {
    _data.clear();
    _data = [];

    // notifyListeners();
  }

  getDepartment() async {
    List<MSelectBox> _depatment;
    var url = Uri.parse('${URLAPI}DataMaster/Department');

    var respon = await http.get(url);

    _depatment = mSelectBoxFromJson(respon.body);

    return _depatment;
  }
}
