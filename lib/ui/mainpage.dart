import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keenapp/constants/constants.dart';
import 'package:keenapp/database/post_db.dart';
import 'package:keenapp/database/post_db_sqflite.dart';
import 'package:keenapp/modal/PRApproveList.dart';
import 'package:keenapp/modal/mUser.dart';
import 'package:keenapp/provider/prList_Provider.dart';

import 'package:keenapp/provider/user_Provider.dart';
import 'package:keenapp/ui/prSearch.dart';
import 'package:keenapp/ui/prdetail.dart';
import 'package:keenapp/ui/widgets/responsive_ui.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainPageScreen(),
    );
  }
}

class mainPageScreen extends StatefulWidget {
  mainPageScreen({Key key}) : super(key: key);

  @override
  _mainPageScreenState createState() => _mainPageScreenState();
}

class _mainPageScreenState extends State<mainPageScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  String PRNumber;

  List<PrApproveList> _dataFromAPI;
  // PostDB _postDB = PostDB('user');
  PostDBSqflite _postDB = PostDBSqflite(databaseName: 'user');

  @override
  void initState() {
    super.initState();
    getPrApproveListfirstLoad();
  }

  Future<void> getPrApproveListfirstLoad() async {
    var postProvider = Provider.of<UserProvider>(context, listen: false);
    mUser user = postProvider.getUser();

    if (user.empEmail != null) {
      var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
      prListtProvider.getAll(user.empEmail, '', '', '', '', '');
      //Navigator.pop(context);
    }

    return;
  }

  Future<void> getPrApproveList() async {
    var postProvider = Provider.of<UserProvider>(context, listen: false);
    mUser user = postProvider.getUser();

    if (user.empEmail != null) {
      var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
      prListtProvider.getAll(user.empEmail, '', '', '', '', '');
      Navigator.pop(context);
    }

    return;
  }

  void menu() {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('menu')));
  }

  void SearchPR() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => prSearch(),
      ),
    );
  }

  void singout() async {
    await _postDB.clearData();

    var userDB = await _postDB.loadUser();
    print(userDB.length);

    var postProvider = Provider.of<UserProvider>(context, listen: false);
    postProvider.clearUser();

    var prProvider = Provider.of<PRListProvider>(context, listen: false);
    prProvider.clearUser();

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Singout complete')));
    Navigator.of(context).pushReplacementNamed(SIGN_IN);
  }

  void approved(String PRNumber) {
    //print(PRNumber);

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => prDetail(PRNumber: PRNumber, type: 'hello'),
      ),
    );
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
        title: Text('PR Approve'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: SearchPR,
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: PRList(),
      drawer: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget child) {
          return Drawer(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.yellow[600],
                          image: DecorationImage(
                            image: AssetImage("assets/images/background.jpg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 30),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: provider.posts.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var post = provider.posts[index];
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'Welcome',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              ' ${post.empName} ${post.empLname} ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'PR Approve List',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onTap: getPrApproveList,
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: singout,
                  textColor: Colors.black,
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: _large
                        ? _width / 4
                        : (_medium ? _width / 3.75 : _width / 3.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.yellow[200],
                          Colors.yellowAccent[700]
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Text('SIGN OUT ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: _large ? 14 : (_medium ? 12 : 10))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget PRList() {
    return Consumer<PRListProvider>(
        builder: (BuildContext context, PRListProvider provider, Widget child) {
      return Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: provider.prList.length,
            itemBuilder: (BuildContext context, int index) {
              var _data = provider.prList[index];
              Color colorstatus = Colors.black;

              if (_data.status == "Draft") {
                colorstatus = Color.fromRGBO(236, 235, 234, 1);
              } else if (_data.status == "Request For Approve" ||
                  _data.status == "Wait For Approve") {
                colorstatus = Color.fromRGBO(247, 201, 93, 14);
              } else if (_data.status == "Request For Information" ||
                  _data.status == "Request For Discuss") {
                colorstatus = Color.fromRGBO(212, 160, 42, 1);
              } else if (_data.status == "Reject") {
                colorstatus = Color.fromRGBO(241, 95, 80, 1);
              } else if (_data.status == "Approve") {
                colorstatus = Color.fromRGBO(69, 153, 248, 1);
              } else if (_data.status == "Request For Verification") {
                colorstatus = Color.fromRGBO(148, 230, 243, 1);
              } else if (_data.status == "Account Verified" ||
                  _data.status == "Purchase Verified" ||
                  _data.status == "Verified") {
                colorstatus = Color.fromRGBO(75, 184, 201, 1);
              } else if (_data.status == "Wait For PO") {
                colorstatus = Color.fromRGBO(31, 151, 169, 1);
              } else if (_data.status == "Finish") {
                colorstatus = Color.fromRGBO(9, 152, 11, 1);
              } else if (_data.status == "Delete") {
                colorstatus = Color.fromRGBO(236, 235, 234, 1);
              }

              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    alignment: Alignment.topCenter,
                    child: ListTile(
                      onTap: () {
                        approved('${_data.prNumber}');
                      },
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _data.prNumber,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _data.status,
                              style: TextStyle(
                                backgroundColor: colorstatus,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_data.department}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${_data.requestBy}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Sub Sec.${_data.subSection}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 340,
                                  child: Text(
                                    '${_data.detail}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Request. ${_data.requestDate.toString().substring(0, 10)}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Require. ${_data.requireDate.toString().substring(0, 10)}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${NumberFormat("#,###.##").format(double.parse(_data.subTotal.toString())) ?? "0"}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.double,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          )),
        ],
      );
    });
  }

  Widget Listapr() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        var PRNumber = 'cccc';
        return Container(
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.topCenter,
          child: ListTile(
            onTap: () {
              approved(PRNumber);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PR20210400${index + 1}'),
                Text(
                  'Request for Approve',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dept. : IT'),
                      Text('Req. : Theerayut.l'),
                      Text('Date Req. : 2021/04/25'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('remark. : Remark remark remark'),
                    Text(
                      'Total : ${10000 * index}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 20,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
