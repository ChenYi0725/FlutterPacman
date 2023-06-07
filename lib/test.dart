import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyDQrugOGIy1DoXRuKkelx89pWZE4CdPSeA",
    databaseURL:
        "https://flutterpacman-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "flutterpacman",
    messagingSenderId: "661444629295",
    appId: "1:661444629295:web:0552e00e773c6d0bb107da",
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () async {
              //print('object');
              final _firebaseInstance = await FirebaseDatabase.instance;
              _firebaseInstance.databaseURL =
                  'https://pacman-cd3c3-default-rtdb.asia-southeast1.firebasedatabase.app';
              _firebaseInstance.ref('/').set({
                'user': 'Eason',
              });
              _firebaseInstance.ref('/').
            },
            child: const Text('onPressed'),
          ),
        ),
      ),
    );
  }
}
