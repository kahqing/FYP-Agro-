import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Add%20Goals/add_new_goal.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Category%20List/goals_category_list.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Saving%20Homepage/saving_homepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final String id;

  const BottomNavigationBarScreen({super.key, required this.id});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      SavingHomepageScreen(id: widget.id),
      AddNewGoalScreen(id: widget.id),
      GoalsCategoryListScreen(id: widget.id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home),
      Icon(Icons.add),
      Icon(Icons.category),
    ];
    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          color: Color.fromARGB(255, 127, 18, 18),
          buttonBackgroundColor: Color.fromARGB(255, 255, 82, 24),
          backgroundColor: Colors.transparent,
          height: 50,
          key: navigationKey,
          index: index,
          items: items,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) => setState(() {
            this.index = index;
          }),
        ),
      ),
    );
  }
}
