import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/services/fireStore_db.dart';
import 'package:untitled/services/login_info.dart';


import 'home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogIn = false;

  getLoggedInState() async{
    await LocalDataSaver.getLogData().then((value){
      setState((){
        isLogIn = value ?? false; // If value is null, default to false

      });
    });
  }

  Future getAllnotes()async{
    await Firedb().getAllNotes();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedInState();
    getAllnotes();
    print("redirecting to home page");
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: isLogIn ? Home(): Login(),
    );
  }
}
