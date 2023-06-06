import 'dart:html';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_testing/character/pacman.dart';

import '../pacman_game.dart';

class Wall extends SpriteComponent
    with CollisionCallbacks, HasGameRef<PacmanGame> {
  final Vector2 gridPosition;
  double xOffset;

  Wall({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(30), anchor: Anchor.center);

  @override
  void onLoad() {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    final platformImage = game.images.fromCache('wall.png');
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      gridPosition.y * size.y,
    );
  }
}
