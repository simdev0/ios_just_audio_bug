




import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  var series = 'Practical Christianity - Book of James';
  var session = 'Bible Study';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
    );
  }
}