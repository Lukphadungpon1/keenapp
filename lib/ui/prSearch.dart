import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keenapp/database/post_db_sqflite.dart';
import 'package:keenapp/modal/mSelectBox.dart';
import 'package:keenapp/modal/mUser.dart';
import 'package:keenapp/provider/prList_Provider.dart';
import 'package:keenapp/provider/user_Provider.dart';
import 'package:keenapp/ui/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class prSearch extends StatelessWidget {
  const prSearch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search..."),
      ),
      body: prSearchScreen(),
    );
  }
}

class prSearchScreen extends StatefulWidget {
  prSearchScreen({Key key}) : super(key: key);

  @override
  _prSearchScreenState createState() => _prSearchScreenState();
}

class _prSearchScreenState extends State<prSearchScreen> {
  PostDBSqflite _postDB = PostDBSqflite(databaseName: 'user');
  PRListProvider _prListProvider = PRListProvider();

  final formKey = GlobalKey<FormState>();

  TextEditingController PRNumberCT = TextEditingController();
  TextEditingController RequireCT = TextEditingController();
  TextEditingController DetailCT = TextEditingController();

  mUser _user;
  String _departmentChoose;
  List<MSelectBox> _departments = [];
  var indicator = null;

  @override
  void initState() {
    super.initState();
    getdefaultValue();
  }

  Future<void> getdefaultValue() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    _user = userProvider.getUser();

    var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
    _departments = await _prListProvider.getDepartment();

    setState(() {});
  }

  void searchBtn() async {
    setState(() {
      indicator = LinearProgressIndicator();
    });

    print(_user.empEmail);
    var prListtProvider = Provider.of<PRListProvider>(context, listen: false);
    await prListtProvider.getAll(_user.empEmail, _departmentChoose,
        PRNumberCT.text.toString(), '', DetailCT.text.toString(), '1');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        indicator ?? Container(),
        Container(
          child: Form(
            key: formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    PRTextFormField(),
                    SizedBox(
                      height: 5,
                    ),
                    Department(),
                    SizedBox(
                      height: 5,
                    ),
                    DaterequieTextFormField(),
                    DetailTextFormField(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          print('aaaa');
                          searchBtn();
                        },
                        child: Text(
                          'Search',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget PRTextFormField() {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          hintText: "Your PRNumber",
          labelText: "PR Number",
          labelStyle: TextStyle(fontSize: 14, color: Colors.black),
        ),
        keyboardType: TextInputType.name,
        controller: PRNumberCT,
      ),
    );
  }

  Widget DetailTextFormField() {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          hintText: "Your Detail",
          labelText: "Detail",
          labelStyle: TextStyle(fontSize: 14, color: Colors.black),
        ),
        keyboardType: TextInputType.name,
        controller: DetailCT,
        maxLines: 5,
      ),
    );
  }

  Widget DaterequieTextFormField() {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Your Date",
                labelText: "Date Require",
                labelStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
              controller: RequireCT,
            ),
            // Text(_dateTime == null
            //     ? 'Choose Date'
            //     : DateFormat('yyyy-MM-dd').format(_dateTime)),
          ),
          SizedBox(
            width: 150,
            child: RaisedButton(
              child: Text('Pick a date'),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2050),
                ).then(
                  (date) => setState(() {
                    RequireCT = new TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(date),
                    );
                  }),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget Department() {
    return Row(
      children: [
        Text('Department : '),
        Container(
          width: 250,
          child: DropdownButton(
            hint: Text('Select Department '),
            dropdownColor: Colors.grey[300],
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            style: TextStyle(color: Colors.black, fontSize: 18),
            value: _departmentChoose,
            onChanged: (newValue) {
              setState(() {
                _departmentChoose = newValue;
              });
            },
            items: _departments.map((valueitem) {
              return DropdownMenuItem(
                child: Text(valueitem.text),
                value: valueitem.value,
              );
            }).toList(),
          ),

          // TextField(
          //   decoration: InputDecoration(
          //     hintText: "Your PRNumber",
          //     labelText: "PR Number",
          //     labelStyle: TextStyle(fontSize: 15, color: Colors.black),
          //   ),
          //   keyboardType: TextInputType.name,
          // ),
        ),
      ],
    );
  }
}
