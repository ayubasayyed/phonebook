import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/screens/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'database app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.deepPurpleAccent,
        accentColor: Colors.deepPurple,
      ),
      home: HomePage(),
      // routes: ,
    );
  }
}

