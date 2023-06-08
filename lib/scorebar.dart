import 'dart:ui';
import '../pacman_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class scorebar extends PositionComponent with HasGameRef<PacmanGame> {
  scorebar({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  }) {
    positionType = PositionType.viewport;
  }

  late TextComponent _scoreTextComponent;

  @override
  void onload() {
    _scoreTextComponent = TextComponent(
      text: 'Score:${game.dotCollected}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(100 + 20 * 30, 20),
    );
    add(_scoreTextComponent);
  }

  @override
  void update(double dt) {
    _scoreTextComponent.text = '${game.dotCollected}';
    super.update(dt);
  }
}
