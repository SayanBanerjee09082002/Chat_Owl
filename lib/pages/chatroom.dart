import 'package:chatapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper/authenticate.dart';
import '../helper/helperfunction.dart';
import '../services/database.dart';
import 'chat.dart';
import 'search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream<QuerySnapshot>? chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName:
                        (snapshot.data!.docs[index].data() as Map)['chatRoomId']
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        (snapshot.data?.docs[index].data() as Map)["chatRoomId"]
                            .toString(),
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.GetUserNameSharedPreference())!;
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  AuthMethods authMethods = new AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('CHATAPP'),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelect(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text('Log Out'),
                    ),
                    PopupMenuItem<int>(value: 1, child: Text('Create Group'))
                  ])
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }

  void onSelect(BuildContext context, int value) {
    switch (value) {
      case 0:
        AuthMethods().signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authenticate()));
        break;
    }
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(userName.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ))
          ],
        ),
      ),
    );
  }
}
