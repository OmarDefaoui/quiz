import 'package:flutter/material.dart';
import 'package:quiz/ui/screens/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pink,
        fontFamily: "Montserrat",
        buttonColor: Colors.pink,
        canvasColor: Colors.transparent,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
