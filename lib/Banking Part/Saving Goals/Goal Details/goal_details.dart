import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Bottom%20Navigation%20Bar/bottom_navi.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Details/goal_fund.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GoalDetailsScreen extends StatefulWidget {
  final String id;
  final String category;
  final String title;
  const GoalDetailsScreen(
      {super.key,
      required this.id,
      required this.category,
      required this.title});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  Database db = Database();
  DateTime dateNow = DateTime.now();
  double currentAmount = 0.0;

  double percentBar(double current, double target) {
    return ((current / target));
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<void> refreshData() async {
    Map<String, dynamic> goalData =
        await db.getGoalInfo(widget.id, widget.category, widget.title);
    setState(() {
      currentAmount = goalData['currentAmount'] ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete this goal?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          db.deleteGoal(
                              widget.id, widget.category, widget.title);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationBarScreen(id: widget.id),
                            ),
                          );
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future:
                    db.getGoalInfo(widget.id, widget.category, widget.title),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    Map<String, dynamic> goalData = snapshot.data ?? {};
                    String imageUrl = goalData['imageUrl'];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          imageUrl != null
                              ? Material(
                                  elevation: 4.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      imageUrl,
                                      width: 150, // Adjust the width as needed
                                      height:
                                          150, // Adjust the height as needed
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 20),
                          Text(
                            '${goalData['title']}',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${goalData['category']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Target:",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "RM${goalData['target']}",
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Start Date:",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "${goalData['startDate']}",
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "End Date:",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "${goalData['endDate']}",
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Current Amount:",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "RM${goalData['currentAmount']}",
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Days Remaining:",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "${daysBetween(dateNow, DateTime.parse(goalData['endDate']))} days left",
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              width: double.infinity,
                              child: LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 50,
                                lineHeight: 24.0,
                                percent: percentBar(
                                    goalData['currentAmount'].toDouble(),
                                    double.parse(goalData['target'])),
                                center: Text(
                                  '${percentBar(goalData['currentAmount'].toDouble(), double.parse(goalData['target'])) * 100}%',
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                                // trailing: const Icon(
                                //   Icons
                                //       .celebration_outlined,
                                //   size: 18,
                                // ),
                                animation: true,
                                animationDuration: 500,
                                backgroundColor:
                                    const Color.fromARGB(255, 218, 218, 218),
                                progressColor:
                                    const Color.fromARGB(255, 255, 91, 222),
                                barRadius: const Radius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Visibility(
                            visible: goalData['status'] == 'In progress',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 160, 24, 14),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("BACK",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 160, 24, 14),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GoalFundScreen(
                                                  category: widget.category,
                                                  id: widget.id,
                                                  title: widget.title,
                                                ),
                                              ),
                                            )
                                            .then((_) => refreshData());
                                      },
                                      child: const Text("FUND",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: goalData['status'] == 'Completed',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 160, 24, 14),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("BACK",
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
