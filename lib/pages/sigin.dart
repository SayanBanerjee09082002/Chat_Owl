import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'chatroom.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;

  SignInPage(this.toggleView);

  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  signUp() async {
    if (formKey.currentState!.validate()) {
      Map<String, String> userDataMap = {
        "userName": usernameEditingController.text,
        "userEmail": emailEditingController.text
      };
      setState(() {
        isLoading = true;
      });
      await authMethods
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((val) {
        databaseMethods.UploadUserInfo(userDataMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration:
                                      InputDecoration(hintText: 'User-name'),
                                  validator: (val) {
                                    return val!.isEmpty || val.length < 3
                                        ? "Enter Username 3+ characters"
                                        : null;
                                  },
                                  controller: usernameEditingController,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration:
                                      InputDecoration(hintText: 'E-Mail'),
                                  validator: (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val!)
                                        ? null
                                        : "Enter correct email";
                                  },
                                  controller: emailEditingController,
                                ),
                                TextFormField(
                                  decoration:
                                      InputDecoration(hintText: 'Password'),
                                  validator: (val) {
                                    return val!.length < 6
                                        ? "Enter Password 6+ characters"
                                        : null;
                                  },
                                  controller: passwordEditingController,
                                ),
                              ],
                            ),
                          ),
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
                          GestureDetector(
                            onTap: () {
                              signUp();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text('Sign In',
                                  style: TextStyle(color: Colors.black)),
                            ),
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
                            child: Text('Sign In with Google',
                                style: TextStyle(color: Colors.black)),
                          ),
                          SizedBox(height: 20),
                          Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                child:
                                    Text("Already have an account? Log in now"),
                                onTap: () {
                                  widget.toggleView();
                                },
                              ))
                        ]),
                  ],
                ),
              ),
      ),
    );
  }
}
