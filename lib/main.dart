import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flame_testing/pacman_game.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'components/rounded_button.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDQrugOGIy1DoXRuKkelx89pWZE4CdPSeA",
    databaseURL:
        "https://flutterpacman-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "flutterpacman",
    messagingSenderId: "661444629295",
    appId: "1:661444629295:web:0552e00e773c6d0bb107da",
  ));
  runApp(
      // const GameWidget<PacmanGame>.controlled(
      //   gameFactory: PacmanGame.new,
      // )
      const WelcomePage(),
  );
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _firebase = FirebaseDatabase.instance;
  bool isPlayer1 = false;
  bool isPlayer2 = false;
  String player1 = "";
  String player2 = "";
  String roomID = "";
  @override
  void initState() {
    super.initState();
    _firebase.databaseURL =
    'https://pacman-cd3c3-default-rtdb.asia-southeast1.firebasedatabase.app';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                children: [
                  const SizedBox(height: 50.0,),
                  const Text(
                    'Join a Room',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 50.0,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter room ID',
                    ),
                    onChanged: (value) {
                      setState(() {
                        roomID = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter your name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        player2 = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
              child: Column(
                children: [
                  const Text(
                    'Create a Room',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 50.0,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter your name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        player1 = value;
                        roomID = '$player1\'room';
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 50.0,
                // horizontal: 50.0
              ),
              child: RoundedButton(
                title: 'Submit',
                color: Colors.blue,
                onPressed: () {
                  print('player 1 : $player1');
                  print('player 2 : $player2');
                  print('roomID : $roomID');
                  if(player1 != "") {
                    setState(() {
                      isPlayer1 = true;
                    });
                  }
                  else {
                    setState(() {
                      isPlayer2 = true;
                    });
                  }
                  _firebase.ref('/').update({
                    "roomID": roomID,
                  });
                  _firebase.ref('/$roomID/').update({
                    "player1": player1,
                    "player2": player2,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
