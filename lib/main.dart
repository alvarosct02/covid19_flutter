import 'package:covid19/screens/map/map_screen.dart';
import 'package:covid19/screens/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

void main() {
  Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 33, 42, 55),
        accentColor: Color.fromARGB(255, 255, 98, 56),
        backgroundColor: Color.fromARGB(255, 243, 243, 242),

        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 33, 42, 55)),
          title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 33, 42, 55)),
          body1: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 33, 42, 55)),
          body2: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 33, 42, 55)),
          caption: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 33, 42, 55)),
        ),
      ),
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: StatsScreen(),
      ),
    );
  }
}
