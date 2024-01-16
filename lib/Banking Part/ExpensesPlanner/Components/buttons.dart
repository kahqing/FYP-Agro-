import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/game_homepage.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class TravelButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  TravelButton();

  @override
  void onTapDown(TapDownEvent event) {
    final String buttonName = 'Travel';
    try {
      print('Travel Button pressed!');
      gameRef!.eventBus.fire(RedirectToListEvent(category: buttonName));
    } catch (error) {
      print(error);
    } finally {}
  }
}

class MedicalButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  MedicalButton();

  @override
  void onTapDown(TapDownEvent event) {
    final String buttonName = 'Medical';
    try {
      print('Medical Button pressed!');
      gameRef!.eventBus.fire(RedirectToListEvent(category: buttonName));
    } catch (error) {
      print(error);
    } finally {}
  }
}

class BankButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  BankButton();

  @override
  void onTapDown(TapDownEvent event) {
    final String buttonName = 'Bank';
    try {
      print('Bank Button pressed!');
      gameRef!.eventBus.fire(RedirectToListEvent(category: buttonName));
    } catch (error) {
      print(error);
    } finally {}
  }
}

class ShoppingButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  ShoppingButton();

  @override
  void onTapDown(TapDownEvent event) {
    final String buttonName = 'Shopping';
    try {
      print('Shopping Button pressed!');
      gameRef!.eventBus.fire(RedirectToListEvent(category: buttonName));
    } catch (error) {
      print(error);
    } finally {}
  }
}

class FoodButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  FoodButton();

  @override
  void onTapDown(TapDownEvent event) {
    final String buttonName = 'Food';
    try {
      print('Food Button pressed!');
      gameRef!.eventBus.fire(RedirectToListEvent(category: buttonName));
    } catch (error) {
      print(error);
    } finally {}
  }
}

class EntertainmentButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  EntertainmentButton();

  @override
  void onTapDown(TapDownEvent event) {
    final String buttonName = 'Entertainment';
    try {
      print('Entertainment Button pressed!');
      gameRef!.eventBus.fire(RedirectToListEvent(category: buttonName));
    } catch (error) {
      print(error);
    } finally {}
  }
}

class OthersButton extends SpriteComponent
    with TapCallbacks, HasGameRef<ExpensesGame> {
  OthersButton();

  @override
  void onTapDown(TapDownEvent event) {
    final String buttonName = 'Others';
    try {
      print('Others Button pressed!');
      gameRef!.eventBus.fire(RedirectToListEvent(category: buttonName));
    } catch (error) {
      print(error);
    } finally {}
  }
}
