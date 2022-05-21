import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authenticate.dart';
import 'pages/search.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  _MyApp createState() => _MyApp();
}
class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color.fromARGB(255, 29, 28, 28),
      ),
      debugShowCheckedModeBanner: false,
      home: Authenticate(),
    );
  }
}
