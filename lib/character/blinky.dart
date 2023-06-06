import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_testing/pacman_game.dart';
import 'package:flame_testing/enum.dart';
import 'package:flame_testing/character/pacman.dart';
import 'package:flame_testing/segment/segment_manager.dart';

class Blinky extends SpriteAnimationComponent
    with HasGameRef<PacmanGame>, CollisionCallbacks {
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 100;
  bool isDirectionChanged = false;
  late MovingDirection previousDirection;
  Vector2 gridPosition = Vector2(10, 11);
  double xOffset;
  MovingDirection currentDirection = MovingDirection.left;
  bool isUpWall = false;
  bool isDownWall = false;
  bool isLeftWall = false;
  bool isRightWall = false;
  bool isFrightened = false;

  Blinky({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(30), anchor: Anchor.center);

  void frightened() {
    animation = SpriteAnimation.fromFrameData(
      //sprite圖動畫
      game.images.fromCache('frightened_ghost.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(16),
        stepTime: 0.2,
      ),
    );
    isFrightened = true;
  }

  @override
  void onLoad() {
    add(RectangleHitbox());
    animation = SpriteAnimation.fromFrameData(
      //sprite圖動畫
      game.images.fromCache('blinky.png'),
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

  bool isPacmanLeft() {
    if ((gridPosition.x - game.pacman.gridPosition.x) > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isPacmanDown() {
    if ((gridPosition.y - game.pacman.gridPosition.y) > 0) {
      return true;
    } else {
      return false;
    }
  }

  void chase() {
    print(isPacmanLeft());
    previousDirection = currentDirection;
    final mapIndex = (gridPosition.x + gridPosition.y * 20) as int;
    switch (map[mapIndex] & 15) {
      //判斷鬼該面朝哪
      case 1: //上有牆壁
        if (currentDirection == MovingDirection.up) {
          //鬼從下上來
          if (isPacmanLeft()) {
            //鬼在人右邊
            currentDirection = MovingDirection.left;
          } else {
            currentDirection = MovingDirection.right;
          }
        } else if (currentDirection == MovingDirection.right ||
            currentDirection == MovingDirection.left) {
          //鬼從左或右過來
          if (!isPacmanDown()) {
            currentDirection = MovingDirection.down;
          }
        }

        break;
      case 2: //下有牆壁
        if (currentDirection == MovingDirection.down) {
          //鬼從上下來
          if (isPacmanLeft()) {
            //鬼在人右邊
            currentDirection = MovingDirection.left;
          } else {
            currentDirection = MovingDirection.right;
          }
        } else if (currentDirection == MovingDirection.right ||
            currentDirection == MovingDirection.left) {
          //鬼從左或右過來
          if (isPacmanDown()) {
            currentDirection = MovingDirection.up;
          }
        }
        break;
      case 4: //左有牆壁
        if (currentDirection == MovingDirection.left) {
          //鬼從右過來
          if (!isPacmanDown()) {
            //鬼在人上面
            currentDirection = MovingDirection.down;
          } else {
            currentDirection = MovingDirection.up;
          }
        } else if (currentDirection == MovingDirection.up ||
            currentDirection == MovingDirection.down) {
          //鬼從上或下過來
          if (!isPacmanLeft()) {
            currentDirection = MovingDirection.right;
          }
        }
        break;
      case 5: //上左有牆壁
        if (currentDirection == MovingDirection.left) {
          currentDirection = MovingDirection.down;
        } else if (currentDirection == MovingDirection.up) {
          currentDirection = MovingDirection.right;
        }
        break;
      case 6: //下左有牆壁
        if (currentDirection == MovingDirection.left) {
          currentDirection = MovingDirection.up;
        } else if (currentDirection == MovingDirection.down) {
          currentDirection = MovingDirection.right;
        }
        break;
      case 8: //右有牆壁
        if (currentDirection == MovingDirection.right) {
          //鬼從左過來
          if (!isPacmanDown()) {
            //在鬼上面
            currentDirection = MovingDirection.down;
          } else {
            currentDirection = MovingDirection.up;
          }
        } else if (currentDirection == MovingDirection.up ||
            currentDirection == MovingDirection.down) {
          //鬼從上或下過來
          if (isPacmanLeft()) {
            currentDirection = MovingDirection.left;
          }
        }
        break;
      case 9: //上右有牆壁
        if (currentDirection == MovingDirection.right) {
          currentDirection = MovingDirection.down;
        } else if (currentDirection == MovingDirection.up) {
          currentDirection = MovingDirection.left;
        }
        break;
      case 10: //下右有牆壁
        if (currentDirection == MovingDirection.right) {
          currentDirection = MovingDirection.up;
        } else if (currentDirection == MovingDirection.down) {
          currentDirection = MovingDirection.left;
        }
        break;
      case 0: //十字路口
        if (currentDirection == MovingDirection.left ||
            currentDirection == MovingDirection.right) {
          //面對左或右
          //面對上或下
          if (!isPacmanLeft()) {
            //鬼在人左邊
            currentDirection = MovingDirection.right;
          } else if (isPacmanLeft()) {
            //鬼在人右邊
            currentDirection = MovingDirection.left;
          }
        } else {
          if (!isPacmanDown()) {
            //鬼在人上面
            currentDirection = MovingDirection.down;
          } else {
            currentDirection = MovingDirection.up;
          }
        }
        break;
    }

    if (currentDirection != previousDirection) {
      isDirectionChanged = true;
    }
  }

//如果按住方向鍵不會被擋下
  @override
  void update(double dt) {
    chase();
    move(dt);
    calculateGridPosition();
    findPassableWay();
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pacman) {
      other.removeFromParent();
    }
  }

  void calculateGridPosition() {
    gridPosition.x = (((position.x - xOffset) / 30).round()) as double;
    gridPosition.y = (((position.y) / 30).round()) as double;
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
