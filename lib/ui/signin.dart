import 'package:flutter/material.dart';
import 'package:keenapp/constants/constants.dart';
import 'package:keenapp/database/post_db.dart';
import 'package:keenapp/database/post_db_sqflite.dart';
import 'package:keenapp/modal/mUser.dart';

import 'package:keenapp/provider/user_Provider.dart';
import 'package:keenapp/ui/widgets/custom_shape.dart';
import 'package:keenapp/ui/widgets/responsive_ui.dart';
import 'package:keenapp/ui/widgets/textformfield.dart';

import 'package:http/http.dart' as http;
import 'package:keenapp/modal/LoginResult.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SignInScreen()),
    );
  }
}

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  PostDBSqflite _postDB = PostDBSqflite(databaseName: 'user');

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // GlobalKey<FormState> _key = GlobalKey();

  List<LoginResult> _userdataFromAPI;
  var indicator = null;

  @override
  void initState() {
    super.initState();
    checkuserINAppDB();
  }

  void checkuserINAppDB() async {
    var userDB = await _postDB.loadUser();

    if (userDB.length > 0) {
      var postProvider = Provider.of<UserProvider>(context, listen: false);

      var _mUser = mUser();
      userDB.forEach((e) {
        _mUser = mUser(
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

      postProvider.addNewUser(_mUser);

      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Login Success...')));
      Navigator.of(context).pushReplacementNamed(MAINPAGE);
    }
  }

  Future<void> getUserLogin(String Username, String Password) async {
    var url = Uri.parse('${URLAPI}Login/\'${Username}\'/\'${Password}\'');

    var respon = await http.get(url);

    _userdataFromAPI = loginResultFromJson(respon.body);

    return;
  }

  void authenticationmainpage() async {
    setState(() {
      indicator = LinearProgressIndicator();
    });

    if (formKey.currentState.validate()) {
      String Username = emailController.text;
      String Password = passwordController.text;

      await getUserLogin(Username, Password);

      if (_userdataFromAPI.length > 0) {
        var _data1 = mUser();
        _userdataFromAPI.forEach((e) {
          _data1 = mUser(
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

        // var testProvider = Provider.of<PostProvider>(context, listen: false);

        // testProvider.addNewPost('ttttt');
        //print(_data1.empCode);
        var postProvider = Provider.of<UserProvider>(context, listen: false);

        postProvider.addNewUser(_data1);

        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Login Success...')));
        Navigator.of(context).pushReplacementNamed(MAINPAGE);
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Username Or Passward is wrong...')));
      }
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Plese input Data..')));
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
      body: Container(
        child: Material(
          child: Container(
            height: _height,
            width: _width,
            padding: EdgeInsets.only(bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  indicator ?? Container(),
                  clipShape(),
                  welcomeTextRow(),
                  signInTextRow(),
                  form(),
                  rememberAccount(),
                  SizedBox(height: _height / 12),
                  button(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow[200], Colors.yellowAccent[700]],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow[200], Colors.yellowAccent[700]],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/images/login.png',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: emailController,
      icon: Icons.account_box,
      hint: "Your ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.visiblePassword,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "Password",
    );
  }

  Widget rememberAccount() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Automatically remember Account.",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: authenticationmainpage,
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.yellow[200], Colors.yellowAccent[700]],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(
                color: Colors.black,
                fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }
}
