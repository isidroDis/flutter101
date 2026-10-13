import 'package:flutter/material.dart';
import 'package:flutter101/main.dart';

void main() {
  runApp(const MyAppAgain());
}

class MyAppAgain extends StatelessWidget {
  const MyAppAgain({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePageAgain(),
    );
  }
}

class MyHomePageAgain extends StatefulWidget {
  const MyHomePageAgain({Key? key}) : super(key: key);

  @override
  _MyHomePageAgainState createState() => _MyHomePageAgainState();
}

class _MyHomePageAgainState extends State<MyHomePageAgain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title 2"),
        titleTextStyle: TextStyle(color: Colors.red, fontSize: 20.0),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print("BASTA PRINT");
            },
            icon: Icon(Icons.fax_rounded),
          ),
        ],
        elevation: 2,
        shadowColor: Colors.black,
      ),
    );
  }
}
