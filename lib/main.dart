import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

void main() => runApp(GameWidget(game: MyProject()));

class MyProject extends FlameGame with HasTappables {
  SpriteComponent background = SpriteComponent();
  SpriteComponent lBoy = SpriteComponent();
  SpriteComponent rBoy = SpriteComponent();
  SpriteAnimationComponent lBoyAnimation = SpriteAnimationComponent();

  double idleHeight = 150.0;
  double idleWidth = 120.0;

  TextPaint dialogTextPaint =
      TextPaint(style: const TextStyle(fontSize: 25, color: Colors.white));

  int dialogLevel = 0;

  DialogButton db = DialogButton();

  @override
  Future onLoad() async {
    double screenWidth = size[0];
    double screenHeight = size[1];
    double textBox = 100.0;

    //animation param;
    var spriteSheet = await images.load('attack.png');
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 6, stepTime: 0.1, textureSize: Vector2(40, 30));

    lBoyAnimation =
        SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData);

    background
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(size[0], size[1] - textBox);
    add(background);

    lBoy
      ..sprite = await loadSprite('character1.png')
      ..size = Vector2(idleHeight, idleWidth)
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, screenHeight - idleHeight - textBox);
    add(lBoy);

    rBoy
      ..sprite = await loadSprite('character2.png')
      ..size = Vector2(idleHeight, idleWidth)
      ..anchor = Anchor.topCenter
      ..position = Vector2(size[0], screenHeight - idleHeight - textBox)
      ..flipHorizontally();

    add(rBoy);

    lBoyAnimation
      ..x = 100
      ..y = 100
      ..size = Vector2(50, 50);
    add(lBoyAnimation);

    db
      ..sprite = await loadSprite('forward_btn.png')
      ..size = Vector2(50, 50)
      ..position = Vector2(size[0] - 100, size[1] - 75);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (lBoy.x < (size[0] / 2) - (idleWidth / 2)) {
      lBoy.x += 100 * dt;
      if (lBoy.x > 20 && dialogLevel == 0) {
        print('a');
        dialogLevel = 1;
      }
      if (lBoy.x > 200 && dialogLevel == 1) {
        print('b');
        dialogLevel = 2;
      }
      if (lBoy.x > ((size[0] / 2) - (idleWidth / 2)) && dialogLevel == 2) {
        print('c');
        dialogLevel = 3;
      }
    }
    if (rBoy.x > (size[0] / 2) + (idleWidth / 2)) {
      rBoy.x += -100 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    Vector2 TextPosition = Vector2(size[0] / 4, size[1] - 65);
    super.render(canvas);

    switch (dialogLevel) {
      case 1:
        dialogTextPaint.render(
            canvas, 'Brown : \"What a snowy day\"', TextPosition);
        break;
      case 2:
        dialogTextPaint.render(
            canvas, 'Brown : \"hmmm....Who is that....?\"', TextPosition);
        break;
      case 3:
        dialogTextPaint.render(
            canvas, 'Brown : \"How dare...Who are you...?\"', TextPosition);
        add(db);
        break;
    }

    switch (db.dialogValue) {
      case 1:
        canvas.drawRect(Rect.fromLTRB(0, size[1] - 100, size[0] - 110, size[1]),
            Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, 'Disappeared!!!', TextPosition);
        remove(rBoy);
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int dialogValue = 0;
  @override
  bool onTapDown(TapDownInfo info) {
    try {
      dialogValue = 1;
      return true;
    } catch (error) {
      return false;
    }
  }
}
