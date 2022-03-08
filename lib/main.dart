import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/views/login.dart';
import 'package:chatapp/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userisLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFuntions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        userisLoggedIn = val!;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: userisLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}
