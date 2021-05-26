import 'package:flutter/material.dart';

class approvedNF extends StatelessWidget {
  const approvedNF({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Process..."),
      ),
      body: Center(
        child: approvedNFScreen(),
      ),
    );
  }
}

class approvedNFScreen extends StatefulWidget {
  approvedNFScreen({Key key}) : super(key: key);

  @override
  _approvedNFScreenState createState() => _approvedNFScreenState();
}

class _approvedNFScreenState extends State<approvedNFScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.done_all_outlined,
            color: Colors.green,
            size: 120.0,
          ),
          Text(
            'Submit Data Complete',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
