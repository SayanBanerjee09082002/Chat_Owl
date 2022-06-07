import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper/helperfunction.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'chatroom.dart';
import 'forgotpassword.dart';

class LogInPage extends StatefulWidget {
  final Function toggleView;
  LogInPage(this.toggleView);
  _LogInPage createState() => _LogInPage();
}

class _LogInPage extends State<LogInPage> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  LogIn() async {
    if (formKey.currentState?.validate() ?? true) {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .logInWithEmailAndPassword(
          emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot<Map<String, dynamic>>? userInfoSnapshot =
          await DatabaseMethods().GetUserInfo(emailEditingController.text);

          HelperFunctions.SaveUserLoggedInSharedPreference(true);
          HelperFunctions.SaveUserNameSharedPreference(
              userInfoSnapshot?.docs[0].data()["userName"]);
          HelperFunctions.SaveUserEmailSharedPreference(
              userInfoSnapshot?.docs[0].data()["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
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
                Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(hintText: 'E-Mail'),
                          validator: (val) {
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                                ? null
                                : "Please Enter Correct Email";
                          },
                          controller: emailEditingController,
                        ),
                        TextFormField(
                          decoration:
                          InputDecoration(hintText: 'Password'),
                          controller: passwordEditingController,
                        ),
                      ]),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      null;
                    },
                      child: Text('Forgot Password?')),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () => LogIn(),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Text('Log In',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 16,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
