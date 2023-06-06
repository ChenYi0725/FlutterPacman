import 'dart:math';
import 'package:flame_testing/segment/segment_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_testing/enum.dart';
import 'package:flame_testing/pacman_game.dart';
import 'package:flutter/services.dart';
import 'package:flame/collisions.dart';

class Pacman extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<PacmanGame> {
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 150;
  bool isDirectionChanged = false;
  late MovingDirection previousDirection;
  Vector2 gridPosition = Vector2(10, 6);
  Vector2 hitAngle = Vector2(0, -1);
  double xOffset;
  MovingDirection currentDirection = MovingDirection.stop;
  bool isUpWall = false;
  bool isDownWall = false;
  bool isLeftWall = false;
  bool isRightWall = false;

  Pacman({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(30), anchor: Anchor.center);

  @override
  void onLoad() {
    add(RectangleHitbox());
    animation = SpriteAnimation.fromFrameData(
      //sprite圖動畫
      game.images.fromCache('pacman.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.3,
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
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      if (!isLeftWall) {
        currentDirection = MovingDirection.left;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      if (!isRightWall) {
        currentDirection = MovingDirection.right;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      if (!isUpWall) {
        currentDirection = MovingDirection.up;
      }
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
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

  double getPositionX() {
    return position.x;
  }

  @override
  void update(double dt) {
    move(dt);
    findAndCheckGridPosition();
    findPassableWay();
    faceAngle();
    super.update(dt);
  }

  void findAndCheckGridPosition() {
    gridPosition.x = (((position.x - xOffset) / 30).round()) as double;
    gridPosition.y = (((position.y) / 30).round()) as double;
  }

  void findPassableWay() {
    // print(isLeftWall);
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

  void faceAngle() {
    switch (currentDirection) {
      case MovingDirection.up:
        angle = 3 * pi / 2;
        break;
      case MovingDirection.down:
        angle = pi / 2;
        break;
      case MovingDirection.left:
        angle = pi;
        break;
      case MovingDirection.right:
        angle = 0;
        break;
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
