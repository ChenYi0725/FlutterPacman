import 'package:flame/game.dart';
import 'package:flame_testing/pacman_game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const GameWidget<PacmanGame>.controlled(
      gameFactory: PacmanGame.new,
    ),
  );
}
