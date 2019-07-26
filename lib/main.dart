import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_notebook_sqllite/screen/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/Welcome': (BuildContext context) => new NoteList()
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color color1 = Color(0xFF1c92d2);
  Color color2 = Color(0xFFf2fcfe);

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Icon(
              Icons.note,
              size: 100,
              color: Colors.blue,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(90)),
                color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter)),
    );
  }
}
