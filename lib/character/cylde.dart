import 'dart:math';
import 'package:flame_testing/segment/segment_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_testing/enum.dart';
import 'package:flame_testing/pacman_game.dart';
import 'package:flutter/services.dart';
import 'package:flame/collisions.dart';
import 'package:flame_testing/character/pacman.dart';

class Clyde extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<PacmanGame>, CollisionCallbacks {
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 150;
  bool isDirectionChanged = false;
  late MovingDirection previousDirection;
  Vector2 gridPosition = Vector2(10, 11);
  double xOffset;
  MovingDirection currentDirection = MovingDirection.stop;
  bool isFrightened = false;
  bool isUpWall = false;
  bool isDownWall = false;
  bool isLeftWall = false;
  bool isRightWall = false;

  Clyde({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(30), anchor: Anchor.center);

  @override
  void onLoad() {
    add(RectangleHitbox());
    animation = SpriteAnimation.fromFrameData(
      //sprite圖動畫
      game.images.fromCache('clyde.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.2,
      ),
    );
    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      gridPosition.y * size.y,
    );
  }

  @override //移動時若先改變xy
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //按下按鈕後判斷往哪
    previousDirection = currentDirection;
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      if (!isLeftWall) {
        currentDirection = MovingDirection.left;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      if (!isRightWall) {
        currentDirection = MovingDirection.right;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      if (!isUpWall) {
        currentDirection = MovingDirection.up;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      if (!isDownWall) {
        currentDirection = MovingDirection.down;
      }
    } else {
      currentDirection = MovingDirection.stop;
    }
    isUpWall = false;
    isDownWall = false;
    isRightWall = false;
    isLeftWall = false;
    if (currentDirection != previousDirection) {
      isDirectionChanged = true;
    }
    return true;
  }

  @override
  void update(double dt) {
    move(dt);
    calculateGridPosition();
    findPassableWay();
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pacman) {
      if (isFrightened) {
        gridPosition = Vector2(10, 11);
        isFrightened = false;
        removeFromParent();
      } else {
        other.removeFromParent();
      }
    }
  }

  void calculateGridPosition() {
    gridPosition.x = (((position.x - xOffset) / 30).round()) as double;
    gridPosition.y = (((position.y) / 30).round()) as double;
  }

  void frightened() {
    animation = SpriteAnimation.fromFrameData(
      //sprite圖動畫
      game.images.fromCache('frightened_clyde.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.2,
      ),
    );
    isFrightened = true;
  }

  void findPassableWay() {
    final mapIndex = (gridPosition.x + gridPosition.y * 20) as int;
    isUpWall = false;
    isDownWall = false;
    isLeftWall = false;
    isRightWall = false;
    if (map[mapIndex] & 1 != 0) {
      isUpWall = true;
    }
    if (map[mapIndex] & 2 != 0) {
      isDownWall = true;
    }
    if (map[mapIndex] & 4 != 0) {
      isLeftWall = true;
    }
    if (map[mapIndex] & 8 != 0) {
      isRightWall = true;
    }
  }

  void move(double dt) {
    //根據移動方向移動
    switch (currentDirection) {
      case MovingDirection.stop:
        velocity.x = 0;
        velocity.y = 0;
        break;
      case MovingDirection.up:
        if (!isUpWall) {
          velocity.x = 0;
          velocity.y = -moveSpeed;
        } else {
          currentDirection = MovingDirection.stop;
        }
        break;
      case MovingDirection.down:
        if (!isDownWall) {
          velocity.x = 0;
          velocity.y = moveSpeed;
        } else {
          currentDirection = MovingDirection.stop;
        }
        break;
      case MovingDirection.left:
        if (!isLeftWall) {
          velocity.y = 0;
          velocity.x = -moveSpeed;
        } else {
          currentDirection = MovingDirection.stop;
        }
        break;
      case MovingDirection.right:
        if (!isRightWall) {
          velocity.y = 0;
          velocity.x = moveSpeed;
        } else {
          currentDirection = MovingDirection.stop;
        }
        break;
    }
    position += velocity * dt;
    if (isDirectionChanged) {
      position = Vector2(
        (gridPosition.x * size.x) + xOffset,
        gridPosition.y * size.y,
      );

      isDirectionChanged = false;
    }
    super.update(dt);
  }
}
