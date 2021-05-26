import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:intl/intl.dart';
import 'package:keenapp/modal/PRApproveList.dart';
import 'package:keenapp/modal/mUser.dart';
import 'package:keenapp/provider/prList_Provider.dart';
import 'package:keenapp/provider/user_Provider.dart';
import 'package:keenapp/ui/prapprovedAC.dart';
import 'package:provider/provider.dart';

import 'package:keenapp/ui/widgets/responsive_ui.dart';
import 'package:keenapp/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart' as urlLaunch;

class prDetail extends StatelessWidget {
  String PRNumber;
  String type;
  prDetail({this.PRNumber, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: prDetailScreen(
        PRNumber: PRNumber,
      ),
    );
  }
}

class prDetailScreen extends StatefulWidget {
  String PRNumber;
  prDetailScreen({Key key, @required this.PRNumber}) : super(key: key);

  @override
  _prDetailScreenState createState() => _prDetailScreenState();
}

class _prDetailScreenState extends State<prDetailScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  double iconSize = 40;
  List<PrApproveList> _ListPRApproved;
  var indicator = null;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> _luancherInBrowser(String filename) async {
    String url = '${URL}UploadFiles/purchaseRequisition/quotation/$filename';
    // if (await urlLaunch.canLaunch(url)) {
    //   await urlLaunch.launch(
    //     url,
    //     forceSafariVC: false,
    //     forceWebView: false,
    //     headers: <String, String>{'header_key': 'header_value'},
    //   );
    // } else {
    //   throw 'Coun\'t launch $url';
    // }
    if (await urlLaunch.canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await urlLaunch.launch(url,
          forceSafariVC: false, forceWebView: false);
      if (!nativeAppLaunchSucceeded) {
        await urlLaunch.launch(url, forceSafariVC: false, forceWebView: false);
      }
    }
  }

  Future<void> getdata() async {
    var postProvider = Provider.of<UserProvider>(context, listen: false);
    mUser user = postProvider.getUser();

    if (user.empEmail != null) {
      var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
      prListtProvider.getAll(user.empEmail, '', widget.PRNumber, '', '', '');

      //Navigator.pop(context);
    }

    return;

    // var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
    // _ListPRApproved = prListtProvider.getPRNumber(widget.PRNumber);

    // setState(() {});
  }

  void getalllist() async {
    var postProvider = Provider.of<UserProvider>(context, listen: false);
    mUser user = postProvider.getUser();

    if (user.empEmail != null) {
      var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
      prListtProvider.getAll(user.empEmail, '', '', '', '', '');
      Navigator.pop(context);
    }
  }

  void authenticationmainpage() {
    print("Routing to your account");
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Login Successful')));

    Navigator.of(context).pushReplacementNamed(MAINPAGE);
  }

  void openattachfile(String attachfile, String types) {
    if (attachfile != "") {
      var value = attachfile.split(',');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(types),
              content: SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var i = 0; i < value.length; i++)
                      OutlineButton(
                        onPressed: () {
                          _luancherInBrowser(value[i]);
                        },
                        child: Text('Click >>  ${types} ${i + 1}'),
                        borderSide: BorderSide(color: Colors.blue),
                        shape: StadiumBorder(),
                      )
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Can\'t open Attach File..')));
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => getalllist(),
        ),
        title: Text("PR Detail..."),
      ),
      body: Container(
        child: Material(
          child: Column(
            children: [
              Expanded(
                child: Consumer<PRListProvider>(builder: (BuildContext context,
                    PRListProvider provider, Widget child) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.prList.length,
                          itemBuilder: (BuildContext context, int index) {
                            PrApproveList _dataPR = provider.prList[index];
                            List<Detail> _detail;
                            _detail = _dataPR.details;

                            return Container(
                              height: _height,
                              width: _width,
                              padding: EdgeInsets.only(bottom: 5),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    header(_dataPR),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    subtotal(_dataPR),
                                    btnapprove(_dataPR),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(PrApproveList _dataPR) {
    Color colorstatus = Colors.black;

    if (_dataPR.status == "Draft") {
      colorstatus = Color.fromRGBO(236, 235, 234, 1);
    } else if (_dataPR.status == "Request For Approve" ||
        _dataPR.status == "Wait For Approve") {
      colorstatus = Color.fromRGBO(247, 201, 93, 14);
    } else if (_dataPR.status == "Request For Information" ||
        _dataPR.status == "Request For Discuss") {
      colorstatus = Color.fromRGBO(212, 160, 42, 1);
    } else if (_dataPR.status == "Reject") {
      colorstatus = Color.fromRGBO(241, 95, 80, 1);
    } else if (_dataPR.status == "Approve") {
      colorstatus = Color.fromRGBO(69, 153, 248, 1);
    } else if (_dataPR.status == "Request For Verification") {
      colorstatus = Color.fromRGBO(148, 230, 243, 1);
    } else if (_dataPR.status == "Account Verified" ||
        _dataPR.status == "Purchase Verified" ||
        _dataPR.status == "Verified") {
      colorstatus = Color.fromRGBO(75, 184, 201, 1);
    } else if (_dataPR.status == "Wait For PO") {
      colorstatus = Color.fromRGBO(31, 151, 169, 1);
    } else if (_dataPR.status == "Finish") {
      colorstatus = Color.fromRGBO(9, 152, 11, 1);
    } else if (_dataPR.status == "Delete") {
      colorstatus = Color.fromRGBO(236, 235, 234, 1);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(5.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRNumber :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '${_dataPR.prNumber}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_dataPR.status}',
                  style: TextStyle(
                      color: colorstatus,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '${_dataPR.department}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sub_Section :',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          '${_dataPR.subSection}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request By :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '${_dataPR.requestBy}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CER Number :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '${_dataPR.forProject}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Date :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '${_dataPR.requestDate.toString().substring(0, 10)}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Require Date :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '${_dataPR.requireDate.toString().substring(0, 10)}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vender :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '${_dataPR.vender}',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remark :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: SizedBox(
                        width: 320,
                        child: Text(
                          '${_dataPR.detail}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          attachfile(_dataPR.uploadquotation, _dataPR.uploadfile),
          SizedBox(height: 10),
          detail(),
          details(_dataPR.details),
          const Divider(
            color: Colors.black,
            height: 5,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
        ],
      ),
    );
  }

  Widget details(List<Detail> _details) {
    return SizedBox(
      height: 150,
      child: Expanded(
          child: ListView.builder(
        itemCount: _details.length,
        itemBuilder: (BuildContext context, int index) {
          Detail _detailss = _details[index];

          Widget bodydetail;

          if (index == 0 || _detailss.types == "T") {
            bodydetail = Container();
          } else {
            bodydetail = const Divider(
              color: Colors.grey,
              height: 5,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            );
          }

          if (_detailss.types != "T") {
            return Container(
              child: Column(
                children: [
                  bodydetail,
                  Row(
                    children: [
                      SizedBox(
                        width: 240,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 300,
                              child: Text(
                                '${_detailss.productName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_detailss.glNo} ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${_detailss.glDesc}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${_detailss.qty}'),
                                Text(
                                    '${NumberFormat("#,###.##").format(double.parse(_detailss.discount.toString())) ?? "0"} %'),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${NumberFormat("#,###.##").format(double.parse(_detailss.unitPrice.toString())) ?? "0"}'),
                                Text(
                                    '${NumberFormat("#,###.##").format(double.parse(_detailss.amountDiscount.toString())) ?? "0"}'),
                                Text(
                                  '${NumberFormat("#,###.##").format(double.parse(_detailss.amount.toString())) ?? "0"}',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.double,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Container(
              child: Text('  >> ${_detailss.textFree}'),
            );
          }
        },
      )),
    );
  }

  Widget detail() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Detail...',
          //   style: TextStyle(
          //       color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          // ),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Product Name ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' GL Code , GL Desc',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Qty',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Dis.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Amount',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Total',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
            height: 5,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
        ],
      ),
    );
  }

  Widget attachfile(String quotation, String attachfile) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            onPressed: () {
              openattachfile(quotation, 'Quotation File');
            },
            child: Column(
              children: [
                Text(
                  'Quotation File',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.file_copy,
                  color: Colors.blue,
                  size: 25.0,
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              openattachfile(attachfile, 'Upload File');
            },
            child: Column(
              children: [
                Text(
                  'Upload File',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.file_copy,
                  color: Colors.blue,
                  size: 25.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subtotal(PrApproveList _dataPR) {
    String Currency = "";
    _dataPR.details.forEach((element) {
      Currency = element.currency;
    });
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(5.0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Row(
                children: [
                  Text(
                    'Currency : ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${Currency}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ],
              )),
              Container(
                child: Row(
                  children: [
                    Text(
                      'Total : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${NumberFormat("#,###.##").format(double.parse(_dataPR.total.toString())) ?? "0"}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Discunt : ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${_dataPR.discount != 0 ? _dataPR.discount : 0} %',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'SubTotal : ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${NumberFormat("#,###.##").format(double.parse(_dataPR.subTotal.toString())) ?? "0"}',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void actionprapprovedAC(String PRNumber, String types) {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return prapprovedAC();
    //     });
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => prapprovedAC(PRNumber: PRNumber, types: types),
      ),
    );
  }

  Widget btnapprove(PrApproveList _dataPR) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              actionprapprovedAC(_dataPR.prNumber, 'Approve');
            },
            child: Text(
              'Approve',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          drowdownbtnrequest(PRNumber: _dataPR.prNumber),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              actionprapprovedAC(_dataPR.prNumber, 'Reject');
              // Respond to button press
            },
            child: Text(
              'Reject',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class drowdownbtnrequest extends StatefulWidget {
  String PRNumber;
  drowdownbtnrequest({Key key, @required this.PRNumber}) : super(key: key);

  @override
  _drowdownbtnrequestState createState() => _drowdownbtnrequestState();
}

class _drowdownbtnrequestState extends State<drowdownbtnrequest> {
  int _value = 1;

  void actionprapprovedAC(String PRNumber, String types) {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return prapprovedAC();
    //     });
    //print(types);
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => prapprovedAC(PRNumber: PRNumber, types: types),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.orange[200],
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      height: 38,
      child: DropdownButton(
          dropdownColor: Colors.orange[200],
          value: _value,
          items: [
            DropdownMenuItem(
              child: Text(
                "Req. For Infomation",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text(
                "Req. For Discuss",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              value: 2,
            ),
            DropdownMenuItem(
                child: Text(
                  "Req. For Account Verify",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                value: 3),
            DropdownMenuItem(
                child: Text(
                  "Req. For Purchase Verify",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                value: 4)
          ],
          onChanged: (value) {
            setState(() {
              _value = value;
              if (value == 1) {
                actionprapprovedAC(widget.PRNumber, 'Request For Infomation');
              } else if (value == 2) {
                actionprapprovedAC(widget.PRNumber, 'Request For Discuss');
              } else if (value == 3) {
                actionprapprovedAC(
                    widget.PRNumber, 'Request For Account Verify');
              } else if (value == 4) {
                actionprapprovedAC(
                    widget.PRNumber, 'Request For Purchase Verify');
              }
            });
          }),
    );
  }
}
