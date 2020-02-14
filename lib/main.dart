import 'package:flutter/material.dart';
import 'package:liquid/views/home_page.dart';
import 'package:liquid/widgets/on_boarding_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      //home: HomePage()
      home: OnBoardingScreen(),
    );
  }
}

