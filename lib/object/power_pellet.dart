import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../pacman_game.dart';
import 'package:flame_testing/character/pacman.dart';

class PowerPellet extends SpriteComponent
    with CollisionCallbacks, HasGameRef<PacmanGame> {
  final Vector2 gridPosition;
  double xOffset;

  PowerPellet({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(20), anchor: Anchor.center);

  @override
  void onLoad() {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    final platformImage = game.images.fromCache('power_pellet.png');
    sprite = Sprite(platformImage);
    position = Vector2(
      (gridPosition.x * 30) + xOffset,
      gridPosition.y * 30,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Pacman) {
      removeFromParent();
      game.clyde.frightened();
      //game.blinky.frightened();
    }
  }
}
