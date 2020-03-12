import 'dart:async';

import 'package:darkness_dungeon/core/decoration/decoration.dart';
import 'package:flame/position.dart';

class PotionLife extends GameDecoration {
  final Position initPosition;
  final double life;
  Timer _timer;
  double _lifeDistributed = 0;

  PotionLife(this.initPosition, this.life)
      : super(
          spriteImg: 'itens/potion_life.png',
          initPosition: initPosition,
          width: 16,
          height: 16,
        );

  @override
  void update(double dt) {
    if (position.overlaps(gameRef.player.position)) {
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_lifeDistributed >= life) {
          timer.cancel();
        } else {
          _lifeDistributed += 2;
          gameRef.player.addLife(5);
        }
      });
      remove();
    }
    super.update(dt);
  }
}
