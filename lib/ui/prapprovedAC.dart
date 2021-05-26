import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keenapp/modal/mUser.dart';
import 'package:keenapp/provider/prList_Provider.dart';
import 'package:keenapp/provider/user_Provider.dart';

import 'package:keenapp/ui/prapprovedNF.dart';
import 'package:keenapp/ui/widgets/responsive_ui.dart';
import 'package:keenapp/constants/constants.dart';
import 'package:keenapp/ui/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class prapprovedAC extends StatelessWidget {
  String PRNumber;
  String types;

  prapprovedAC({this.PRNumber, this.types});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Actions....'),
        ),
        body: prapprovedACScreen(PRNumber: PRNumber, types: types),
      ),
    );
  }
}

class prapprovedACScreen extends StatefulWidget {
  String PRNumber;
  String types;
  prapprovedACScreen({Key key, @required this.PRNumber, @required this.types})
      : super(key: key);

  @override
  _prapprovedACScreenState createState() => _prapprovedACScreenState();
}

class _prapprovedACScreenState extends State<prapprovedACScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  final formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  var indicator = null;

  void showstatusApprove() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.done_all_outlined,
                      color: Colors.green,
                      size: 80.0,
                    ),
                    Text(
                      'Submit Data Complete',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void evenApprovedNF() async {
    setState(() {
      indicator = LinearProgressIndicator();
    });
    if (formKey.currentState.validate()) {
      String Comment1 = commentController.text;

      var userProvider = Provider.of<UserProvider>(context, listen: false);
      mUser user = userProvider.getUser();

      var prProvider = Provider.of<PRListProvider>(context, listen: false);
      print(widget.types);

      String _status;
      if (widget.types != 'Approve') {
        _status = await prProvider.notapprove(user.empEmail, user.empUsername,
            widget.PRNumber, Comment1, widget.types);
      } else {
        _status = await prProvider.approve(user.empEmail, user.empUsername,
            widget.PRNumber, Comment1, widget.types);
      }
      print(_status);
      if (_status == "Approved" ||
          _status == '"Wait For PO"' ||
          _status == '"OK"' ||
          _status == '"Request For Verification"') {
        String statusemail = "approve";

        if (_status == '"OK"') {
          statusemail = "notApprovePR";
        }
        String emailNF = await prProvider.sendmailNF(
            widget.PRNumber, statusemail, user.empEmail);
        if (emailNF == '"OK"') {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Send mail Complete..')));
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Can\'t Send mail')));
        }
      }

      if (_status == '"Approved"' ||
          _status == '"Wait For PO"' ||
          _status == '"OK"' ||
          _status == '"Request For Verification"') {
        print(_status);
        showstatusApprove();
        Timer(
            Duration(seconds: 3),
            () => {
                  Navigator.of(context).pushReplacementNamed(MAINPAGE),
                });
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Can\'t Approve Please contract IT..')));
      }
    }
  }

  void evenuptoscreen() {
    //showstatusApprove();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Container(
      child: Material(
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.only(bottom: 5),
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              indicator ?? Container(),
              SizedBox(
                height: 10,
              ),
              header(widget.PRNumber, widget.types),
              comment(),
              Expanded(child: SizedBox()),
              btnapprove(),
            ],
          ),
        ),
      ),
    );
  }

  Widget header(String PRNumber, String types) {
    Color Colortype;
    if (types == 'Approve') {
      Colortype = Colors.green;
    } else if (types == 'Reject') {
      Colortype = Colors.red;
    } else {
      Colortype = Colors.orange[200];
    }
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PR Number. ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '   ${PRNumber}',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            types,
            style: TextStyle(
                backgroundColor: Colortype,
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget comment() {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '** Cannot emptry **',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                // hack textfield height
                child: TextFormField(
                  validator: (String text) {
                    if (text.isEmpty) {
                      return 'Please input Comment..';
                    }
                    return null;
                  },
                  controller: commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Comment!",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget commentTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: commentController,
      icon: Icons.comment,
      hint: "Comment!",
    );
  }

  Widget btnapprove() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 150,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: evenApprovedNF,
              child: Text(
                'Submit',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: RaisedButton(
              color: Colors.grey[300],
              onPressed: evenuptoscreen,
              // Respond to button press

              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
