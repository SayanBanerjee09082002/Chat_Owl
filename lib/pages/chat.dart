import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({required this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot<Object?>>? chats;
  late QuerySnapshot<Map<String, dynamic>> snapshot;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message:
                        (snapshot.data?.docs[index].data() as Map)["message"],
                    sendByMe: Constants.myName ==
                        (snapshot.data?.docs[index].data() as Map)["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId, null).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                });
          },
        ),
        title: Text('CHATS'),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 10.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: messageEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: GestureDetector(
                          onTap: () => addMessage(),
                          child: Icon(
                            Icons.send,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [Colors.orange, Colors.orangeAccent]
                  : [const Color(0x1D473E2C), const Color(0xAF58F8F)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
      ),
    );
  }
}

class Constants {
  static String myName = "";
}