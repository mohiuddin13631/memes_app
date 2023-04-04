import 'package:flutter/material.dart';
import 'package:memes/view/details.dart';
import 'package:memes/view/home_page.dart';
import 'package:memes/view/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage()
      // home: HomeScreen()
      // home: Details()
    );
  }
}

