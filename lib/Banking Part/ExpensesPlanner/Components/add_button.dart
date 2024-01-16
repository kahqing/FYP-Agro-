import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/Components/assets.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/game_homepage.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';

class AddButton extends PositionComponent with TapCallbacks {
  static const double margin = 10.0;

  AddButton();

  @override
  // Future<void> onLoad() async {
  //   final add = await Flame.images.load(Assets.add);
  //   sprite = Sprite(add);
  //   size = Vector2(50, 50); // Set the size of the button
  //   position = Vector2(
  //     margin,
  //     gameRef.size.y - size.y - margin,
  //   ); // Set the initial position of the button
  // }

  bool onTapUp(TapUpEvent event) {
    try {
      print("It will pop up a panel for adding expenses.");
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
