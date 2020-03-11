import 'dart:ui';

import 'package:darkness_dungeon/core/rpg_game.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

class AnimatedObjectOnce extends Component with HasGameRef<RPGGame> {
  Rect position;
  final FlameAnimation.Animation animation;
  final VoidCallback onFinish;
  final bool onlyUpdate;
  bool _isDestroyed = false;
  Rect positionInWorld;
  bool _isFirstUpdate = true;

  AnimatedObjectOnce({
    this.position,
    this.animation,
    this.onFinish,
    this.onlyUpdate = false,
  }) {
    positionInWorld = position;
  }

  @override
  void render(Canvas canvas) {
    if (animation == null || onlyUpdate) return;
    if (animation.loaded()) {
      animation.getSprite().renderRect(canvas, position);
    }
  }

  @override
  void update(double dt) {
    if (_isFirstUpdate) {
      position = Rect.fromLTWH(
        position.left - gameRef.mapCamera.x,
        position.top - gameRef.mapCamera.y,
        position.width,
        position.height,
      );
      positionInWorld = position;
      _isFirstUpdate = false;
    }

    if (animation != null && !_isDestroyed) {
      animation.update(dt);
      if (animation.isLastFrame) {
        if (onFinish != null) onFinish();
        remove();
      }
    }

    position = Rect.fromLTWH(
      positionInWorld.left + gameRef.mapCamera.x,
      positionInWorld.top + gameRef.mapCamera.y,
      positionInWorld.width,
      positionInWorld.height,
    );
  }

  @override
  bool destroy() {
    return _isDestroyed;
  }

  void remove() {
    _isDestroyed = true;
  }
}
