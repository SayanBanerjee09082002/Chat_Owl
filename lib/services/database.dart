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

  GetUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<String>? addChatRoom(chatRoomMap, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId, messageMap) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void>? addMessage(String chatRoomId, chatMessageData){
    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return  await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
