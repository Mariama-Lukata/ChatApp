import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversationScreen.dart';
import 'package:chatapp/views/login.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  late Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                      (snapshot.data! as QuerySnapshot)
                          .docs[index]["chatroomid"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constats.myName, ""),
                      chatRoom: '',
                      userName: '',
                    );
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constats.myName =
        await HelperFuntions.getUseNameSharedPreference() as String;
    databaseMethods.getChatRooms(Constats.myName).then((val) {
      chatRoomsStream = val;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Chat App"),
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Colors.pink,
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  const ChatRoomTile(String string,
      {Key? key, required this.userName, required this.chatRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /* onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(ChatRoomTile((snapshot.data! as QuerySnapshot)
                        .docs[index]["chatroomid"]
                        .toString(), chatRoom: '', userName: '',), chatroomid: '',
          )));
      },*/
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(40)),
              child: Text("${userName.substring(0, 1).toUpperCase()}"),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: mediumTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
