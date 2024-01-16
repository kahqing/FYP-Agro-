import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Category%20List/goals_list.dart';
import 'package:flutter/material.dart';

class GoalsCategoryListScreen extends StatefulWidget {
  final String id;
  const GoalsCategoryListScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<GoalsCategoryListScreen> createState() =>
      _GoalsCategoryListScreenState();
}

class _GoalsCategoryListScreenState extends State<GoalsCategoryListScreen> {
  final List<String> goalCategories = [
    'Travel',
    'Special Events',
    'Entertainment',
    'Gifts',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 162, 18, 18),
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Goal Categories',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: goalCategories.length,
          itemBuilder: (context, index) {
            final category = goalCategories[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () {
                  print('Selected category: $category');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoalsListBasedCategoryScreen(
                        id: widget.id,
                        category: category,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 255, 200, 200),
                          Color.fromARGB(255, 255, 240, 230),
                        ],
                      ),
                    ),
                    child: ListTile(
                      title: Text(category),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                      // Add more details as needed
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
