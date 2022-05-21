import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  final Function toggleView;
  LogInPage(this.toggleView);
  _LogInPage createState() => _LogInPage();
}

class _LogInPage extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 340,
                child: Padding(
                  padding: const EdgeInsets.all(90.0),
                  child: Image(
                    image: AssetImage(
                      'images/shiba.png',
                    ),
                  ),
                ),
              ), //image
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                TextField(decoration: InputDecoration(hintText: 'E-Mail')),
                TextField(decoration: InputDecoration(hintText: 'Password')),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('Forgot Password?'),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text('Log In', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text('Log In with Google',
                      style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Container(
                      alignment: Alignment.center,
                        child: Text("Don't have an account? Create one now"),
                      ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
