import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/Components/assets.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/game_homepage.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/nextpage.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Background extends SpriteComponent with HasGameRef<ExpensesGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.background);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
