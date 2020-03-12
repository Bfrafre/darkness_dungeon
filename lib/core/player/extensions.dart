import 'dart:ui';

import 'package:darkness_dungeon/core/flying_attack_object.dart';
import 'package:darkness_dungeon/core/player/player.dart';
import 'package:darkness_dungeon/core/util/Direction.dart';
import 'package:darkness_dungeon/core/util/animated_object_once.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension PlayerExtensions on Player {
  void simpleAttackMelee({
    @required FlameAnimation.Animation attackEffectRightAnim,
    @required FlameAnimation.Animation attackEffectBottomAnim,
    @required FlameAnimation.Animation attackEffectLeftAnim,
    @required FlameAnimation.Animation attackEffectTopAnim,
    @required double damage,
    double heightArea = 32,
    double widthArea = 32,
  }) {
    if (isDie) return;

    Rect positionAttack;
    FlameAnimation.Animation anim = attackEffectRightAnim;
    double pushLeft = 0;
    double pushTop = 0;
    switch (lastDirection) {
      case Direction.top:
        positionAttack = Rect.fromLTWH(positionInWorld.left,
            positionInWorld.top - heightArea, widthArea, heightArea);
        if (attackEffectTopAnim != null) anim = attackEffectTopAnim;
        pushTop = heightArea * -1;
        break;
      case Direction.right:
        positionAttack = Rect.fromLTWH(positionInWorld.left + widthArea,
            positionInWorld.top, widthArea, heightArea);
        if (attackEffectRightAnim != null) anim = attackEffectRightAnim;
        pushLeft = widthArea;
        break;
      case Direction.bottom:
        positionAttack = Rect.fromLTWH(positionInWorld.left,
            positionInWorld.top + heightArea, widthArea, heightArea);
        if (attackEffectBottomAnim != null) anim = attackEffectBottomAnim;
        pushTop = heightArea;
        break;
      case Direction.left:
        positionAttack = Rect.fromLTWH(positionInWorld.left - widthArea,
            positionInWorld.top, widthArea, heightArea);
        if (attackEffectLeftAnim != null) anim = attackEffectLeftAnim;
        pushLeft = widthArea * -1;
        break;
    }

    gameRef.add(AnimatedObjectOnce(animation: anim, position: positionAttack));

    gameRef.enemies.where((i) => i.isVisibleInMap()).forEach((enemy) {
      if (enemy.positionInWorld.overlaps(positionAttack)) {
        enemy.receiveDamage(damage);
        if (!this.isCollision(
            enemy.positionInWorld.translate(pushLeft, pushTop), this.gameRef)) {
          enemy.translate(pushLeft, pushTop);
        }
      }
    });
  }

  void simpleAttackRange({
    @required FlameAnimation.Animation animationRight,
    @required FlameAnimation.Animation animationLeft,
    @required FlameAnimation.Animation animationTop,
    @required FlameAnimation.Animation animationBottom,
    @required FlameAnimation.Animation animationDestroy,
    @required double width,
    @required double height,
    double speed = 1.5,
    double damage = 1,
  }) {
    if (isDie) return;

    Position startPosition;
    FlameAnimation.Animation attackRangeAnimation;

    switch (this.lastDirection) {
      case Direction.left:
        if (animationLeft != null) attackRangeAnimation = animationLeft;
        startPosition = Position(
          this.positionInWorld.left - width,
          (this.positionInWorld.top +
              (this.positionInWorld.height - height) / 2),
        );
        break;
      case Direction.right:
        if (animationRight != null) attackRangeAnimation = animationRight;
        startPosition = Position(
          this.positionInWorld.right,
          (this.positionInWorld.top +
              (this.positionInWorld.height - height) / 2),
        );
        break;
      case Direction.top:
        if (animationTop != null) attackRangeAnimation = animationTop;
        startPosition = Position(
          (this.positionInWorld.left +
              (this.positionInWorld.width - width) / 2),
          this.positionInWorld.top - height,
        );
        break;
      case Direction.bottom:
        if (animationBottom != null) attackRangeAnimation = animationBottom;
        startPosition = Position(
          (this.positionInWorld.left +
              (this.positionInWorld.width - width) / 2),
          this.positionInWorld.bottom,
        );
        break;
    }

    gameRef.add(
      FlyingAttackObject(
          direction: lastDirection,
          flyAnimation: attackRangeAnimation,
          destroyAnimation: animationDestroy,
          initPosition: startPosition,
          height: height,
          width: width,
          damage: damage,
          speed: speed,
          damageInPlayer: false),
    );
  }
}
