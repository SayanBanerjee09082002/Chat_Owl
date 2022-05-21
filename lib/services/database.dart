import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  GetUserByUsername(String username) async {
    return await
    FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
        .get();
  }

  Future<void> UploadUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }
}
