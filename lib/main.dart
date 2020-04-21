import 'package:flutter/material.dart';

import 'files.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var series = 'Practical Christianity - Book of James';
  var session = 'Bible Study';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: FileScreen(
            series: series, 
            session: session
            ),
        ),
      ),
    );
  }
}