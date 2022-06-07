import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helper/authenticate.dart';
import 'helper/helperfunction.dart';
import 'pages/chatroom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool? userIsLoggedIn;

  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.GetUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color.fromARGB(255, 29, 28, 28),
        ),
        debugShowCheckedModeBanner: false,
        home: userIsLoggedIn != null
            ? userIsLoggedIn!
                ? ChatRoom()
                : Authenticate()
            : Container(
                child: Center(
                child: Authenticate(),
              )));
  }
}
