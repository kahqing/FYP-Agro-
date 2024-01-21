import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Details/goal_details.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GoalsListBasedCategoryScreen extends StatefulWidget {
  final String id;
  final String category;

  const GoalsListBasedCategoryScreen({
    Key? key,
    required this.id,
    required this.category,
  }) : super(key: key);

  @override
  State<GoalsListBasedCategoryScreen> createState() =>
      _GoalsListBasedCategoryScreenState();
}

class _GoalsListBasedCategoryScreenState
    extends State<GoalsListBasedCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Map<String, dynamic>>> completedGoals;
  late Future<List<Map<String, dynamic>>> inProgressGoals;
  late List<Map<String, dynamic>> currentInProgressGoals = [];
  late List<Map<String, dynamic>> currentCompletedGoals = [];
  Database db = Database();
  DateTime dateNow = DateTime.now();

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  double percentBar(double current, double target) {
    return ((current / target));
  }

  Gradient getCategoryColor(String category) {
    final lowerCaseCategory = category.toLowerCase();

    switch (lowerCaseCategory) {
      case 'travel':
        return const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 255, 159, 41),
            Color.fromARGB(255, 255, 219, 165),
          ],
        );
      case 'special events':
        return const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 253, 67, 67),
            Color.fromARGB(255, 255, 131, 131),
          ],
        );
      case 'entertainment':
        return const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 40, 255, 16),
            Color.fromARGB(255, 134, 255, 144),
          ],
        );
      case 'gifts':
        return const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 255, 149, 216),
            Color.fromARGB(255, 252, 204, 244),
          ],
        );
      case 'others':
        return const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 68, 202, 211),
            Color.fromARGB(255, 155, 252, 255),
          ],
        );
      default:
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 216, 186, 255),
            Color.fromARGB(255, 242, 228, 255),
          ],
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    completedGoals = db.getCompletedGoalList(widget.id, widget.category);
    inProgressGoals = db.getCategoryGoalList(widget.id, widget.category);
  }

  Future<void> refreshData() async {
    List<Map<String, dynamic>> inProgressData =
        await db.getCategoryGoalList(widget.id, widget.category);
    List<Map<String, dynamic>> completedData =
        await db.getCompletedGoalList(widget.id, widget.category);

    setState(() {
      inProgressGoals = Future.value(inProgressData);
      completedGoals = Future.value(completedData);
      currentInProgressGoals = inProgressData;
      currentCompletedGoals = completedData;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'In Progress Goals'),
            Tab(text: 'Completed Goals'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: getCategoryColor(widget.category),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
                future: inProgressGoals,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No in-progress goals.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> goalData = snapshot.data![index];
                          String imageUrl = goalData['imageUrl'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoalDetailsScreen(
                                      id: widget.id,
                                      category: goalData['category'],
                                      title: goalData['title']),
                                ),
                              ).then((value) => refreshData());
                            },
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: Card(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: ListTile(
                                  subtitle: Row(
                                    children: [
                                      imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                imageUrl,
                                                width:
                                                    100, // Adjust the width as needed
                                                height:
                                                    100, // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(), // Handle the case where imageUrl is null

                                      // Display other goal information
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              goalData['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            Text(
                                                'Days Remaining: ${daysBetween(dateNow, DateTime.parse(goalData['endDate']))}'),
                                            Text(
                                                'RM${goalData['currentAmount'].toStringAsFixed(2)} / RM${goalData['target']}'),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: LinearPercentIndicator(
                                                width: 150,
                                                lineHeight: 15.0,
                                                percent: percentBar(
                                                    goalData['currentAmount']
                                                        .toDouble(),
                                                    double.parse(
                                                        goalData['target'])),
                                                center: Text(
                                                  '${(percentBar(goalData['currentAmount'].toDouble(), double.parse(goalData['target'])) * 100).toStringAsFixed(2)}%',
                                                  style:
                                                      TextStyle(fontSize: 10.0),
                                                ),
                                                // trailing: const Icon(
                                                //   Icons
                                                //       .celebration_outlined,
                                                //   size: 18,
                                                // ),
                                                animation: true,
                                                animationDuration: 500,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 218, 218, 218),
                                                progressColor: Color.fromARGB(
                                                    255, 236, 130, 255),
                                                barRadius:
                                                    const Radius.circular(20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: completedGoals,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No completed goals.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> goalData = snapshot.data![index];
                          String imageUrl = goalData['imageUrl'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoalDetailsScreen(
                                      id: widget.id,
                                      category: goalData['category'],
                                      title: goalData['title']),
                                ),
                              ).then((value) => refreshData());
                            },
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: Card(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: ListTile(
                                  subtitle: Row(
                                    children: [
                                      imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                imageUrl,
                                                width:
                                                    100, // Adjust the width as needed
                                                height:
                                                    100, // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(), // Handle the case where imageUrl is null

                                      // Display other goal information
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              goalData['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            Text(
                                                'Days Remaining: ${daysBetween(dateNow, DateTime.parse(goalData['endDate']))}'),
                                            Text(
                                                'RM${goalData['currentAmount'].toStringAsFixed(2)} / RM${goalData['target']}'),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: LinearPercentIndicator(
                                                width: 150,
                                                lineHeight: 15.0,
                                                percent: percentBar(
                                                    goalData['currentAmount']
                                                        .toDouble(),
                                                    double.parse(
                                                        goalData['target'])),
                                                center: Text(
                                                  '${(percentBar(goalData['currentAmount'].toDouble(), double.parse(goalData['target'])) * 100).toStringAsFixed(2)}%',
                                                  style:
                                                      TextStyle(fontSize: 10.0),
                                                ),
                                                // trailing: const Icon(
                                                //   Icons
                                                //       .celebration_outlined,
                                                //   size: 18,
                                                // ),
                                                animation: true,
                                                animationDuration: 500,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 218, 218, 218),
                                                progressColor: Color.fromARGB(
                                                    255, 236, 130, 255),
                                                barRadius:
                                                    const Radius.circular(20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
