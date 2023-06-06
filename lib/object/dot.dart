import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../pacman_game.dart';
import 'package:flame_testing/character/pacman.dart';

class Dot extends SpriteComponent
    with CollisionCallbacks, HasGameRef<PacmanGame> {
  final Vector2 gridPosition;
  double xOffset;

  Dot({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(15), anchor: Anchor.center);

  @override
  void onLoad() {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    final platformImage = game.images.fromCache('dot.png');
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
    }
  }
}
