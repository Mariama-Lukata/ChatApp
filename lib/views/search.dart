import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/messages.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatpage.dart';
import 'package:chatapp/views/conversationScreen.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

String? _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: (searchSnapshot!.docs[index].data()
                    as Map<String, dynamic>)["name"],
                userEmail: (searchSnapshot!.docs[index].data()
                    as Map<String, dynamic>)["email"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatroonandStartConversation({required String userName}) {
    if (userName != Constats.myName) {
      String chatRoomId = getChatRoomId(userName, Constats.myName);

      List<String> users = [userName, Constats.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };
      DatabaseMethods().creatChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId,
                    chatroomid: '',
                  )));
    } else {
      print("Dont talk to yourself, talk to a friend");
    }
  }

  Widget SearchTile({String? userName, String? userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName!,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail!,
                style: mediumTextStyle(),
              )
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
               Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => chatpage(email:userEmail,)));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: simpleTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Chat App"),
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.pink),
                    decoration: InputDecoration(
                        hintText: "search username",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xFFE91E63),
                            const Color(0xFFEC407A)
                          ]),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset('assets/images/search.png')),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
