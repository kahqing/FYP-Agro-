import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/Components/assets.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/Components/background.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/Components/buttons.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/category_list.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/nextpage.dart';
import 'package:agro_plus_app/General%20Part/home_page.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
// import 'package:event_bus/event_bus.dart';

class ExpensesGame extends FlameGame {
  final EventBus eventBus = EventBus();
  TravelButton travel = TravelButton();
  MedicalButton medical = MedicalButton();
  BankButton bank = BankButton();
  ShoppingButton shopping = ShoppingButton();
  FoodButton food = FoodButton();
  EntertainmentButton enter = EntertainmentButton();
  OthersButton others = OthersButton();
  DialogButton dialogButton = DialogButton();
  BackButton back = BackButton();

  final Vector2 buttonSize = Vector2(50.0, 50.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    print("we will load the game assets here.");

    add(Background());

    dialogButton
      ..sprite = await loadSprite(Assets.add)
      ..size = buttonSize
      ..position = Vector2(10, size[1] - buttonSize[1] - 10);
    add(dialogButton);

    back
      ..sprite = await loadSprite(Assets.backButton)
      ..size = buttonSize
      ..position = Vector2(10, 10);
    add(back);

    travel
      ..sprite = await loadSprite(Assets.travel)
      ..size = Vector2(130, 60)
      ..position = Vector2(180, 80);
    add(travel);

    medical
      ..sprite = await loadSprite(Assets.medical)
      ..size = Vector2(130, 60)
      ..position = Vector2(50, 150);
    add(medical);

    bank
      ..sprite = await loadSprite(Assets.bank)
      ..size = Vector2(130, 60)
      ..position = Vector2(20, 300);
    add(bank);

    shopping
      ..sprite = await loadSprite(Assets.shopping)
      ..size = Vector2(130, 60)
      ..position = Vector2(230, 250);
    add(shopping);

    food
      ..sprite = await loadSprite(Assets.food)
      ..size = Vector2(130, 60)
      ..position = Vector2(170, 400);
    add(food);

    enter
      ..sprite = await loadSprite(Assets.entert)
      ..size = Vector2(130, 60)
      ..position = Vector2(220, 600);
    add(enter);

    others
      ..sprite = await loadSprite(Assets.others)
      ..size = Vector2(130, 60)
      ..position = Vector2(40, 480);
    add(others);
  }
}

class RedirectToListEvent {
  final String category;

  RedirectToListEvent({required this.category});
}

class NavigateToNextPageEvent {}

class NavigateToHomepageEvent {}

class DialogButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  bool _isPressed = false;

  @override
  void onTapDown(TapDownEvent event) {
    try {
      print('Button pressed!');

      if (!_isPressed) {
        _isPressed = true;
        // Navigate to the new page
        gameRef!.eventBus.fire(NavigateToNextPageEvent());
      }
    } catch (error) {
      print(error);
    } finally {
      _isPressed = false; // Reset the _isPressed state
    }
  }
}

class BackButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  bool _isPressed = false;

  @override
  void onTapDown(TapDownEvent event) {
    try {
      print('Button pressed!');

      if (!_isPressed) {
        _isPressed = true;
        // Navigate to the new page
        gameRef!.eventBus.fire(NavigateToHomepageEvent());
      }
    } catch (error) {
      print(error);
    } finally {
      _isPressed = false; // Reset the _isPressed state
    }
  }
}

class GameScreen extends StatelessWidget {
  final String matric;
  final ExpensesGame expensesGame;

  GameScreen({Key? key, required this.matric}) : expensesGame = ExpensesGame();

  @override
  Widget build(BuildContext context) {
    expensesGame.eventBus.on<NavigateToNextPageEvent>().listen((event) {
      // Navigate to the new page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddExpenses(
              matric:
                  matric), // Replace NextPage with the actual class you want to navigate to
        ),
      );
    });

    expensesGame.eventBus.on<NavigateToHomepageEvent>().listen((event) {
      // Navigate to the new page
      Navigator.of(context).pop();
    });

    expensesGame.eventBus.on<RedirectToListEvent>().listen((event) {
      // Navigate to the new page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CategoryListScreen(
              matric: matric,
              category: event
                  .category), // Replace NextPage with the actual class you want to navigate to
        ),
      );
    });
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Game Screen'),
      // ),
      body: Center(
        child:
            GameWidget(game: expensesGame), // Use GameWidget to wrap the game
      ),
    );
  }
}
