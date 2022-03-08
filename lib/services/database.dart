import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  creatChatRoom(String chatroomid, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomid)
        .set(chatRoomMap);
  }

  getConversationMessages(String chatroomid) async{
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomid)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  addConversationMessages(String chatroomid, messageMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomid)
        .collection("chats")
        .add(messageMap);
  }

  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .where("user", arrayContains: userName)
        .snapshots();
  }
}
