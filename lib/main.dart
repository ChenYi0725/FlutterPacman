import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flame_testing/pacman_game.dart';
import 'package:flutter/material.dart';

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
    const GameWidget<PacmanGame>.controlled(
      gameFactory: PacmanGame.new,
    ),
  );
}
