import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Details/goal_details.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Saving%20Homepage/withdraw_pocket.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:agro_plus_app/General%20Part/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SavingHomepageScreen extends StatefulWidget {
  final String id;

  const SavingHomepageScreen({super.key, required this.id});

  @override
  State<SavingHomepageScreen> createState() => _SavingHomepageScreenState();
}

class _SavingHomepageScreenState extends State<SavingHomepageScreen> {
  Database db = Database();

  late Future<List<Map<String, dynamic>>> inProgressGoals;
  late Future<List<Map<String, dynamic>>> completedGoals;
  late Future<String> tabungAmount;
  DateTime dateNow = DateTime.now();

  @override
  void initState() {
    inProgressGoals = db.getInProgressGoalList(widget.id);

    // fetchTabungAmount();

    super.initState();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  double percentBar(double current, double target) {
    return ((current / target));
  }

  Future<void> refreshData() async {
    inProgressGoals = db.getInProgressGoalList(widget.id);

    // Use await to get the result from db.getTabungAmount
    String tabungAmountResult = await db.getTabungAmount(widget.id);

    // Update the state with the result
    setState(() {
      tabungAmount = Future.value(tabungAmountResult);
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 255, 255), // Change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Savings Goal",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // This will pop the current screen
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomepageScreen(matric: widget.id),
                ),
                (route) => false);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(255, 229, 48, 48),
                        Color.fromARGB(255, 127, 18, 18)
                      ]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<String>(
                      future: db.getTabungAmount(widget.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            backgroundColor: Color.fromARGB(255, 127, 18, 18),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          String tabungAmount = snapshot.data ?? '';
                          return Text(
                            "Pocket: $tabungAmount",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          );
                        }
                      },
                    ),
                    Container(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WithdrawPocketScreen(
                                  id: widget.id,
                                ),
                              ),
                            ).then((value) => refreshData());
                          },
                          child: const Text(
                            "Withdraw",
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "In Progress Goal",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: inProgressGoals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No in-progress goals.'));
                } else {
                  // Display the in-progress goals in cards
                  return Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 50),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
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
                            child: Card(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Color.fromARGB(255, 255, 243, 222),
                                          Color.fromARGB(255, 255, 227, 249)
                                        ])),
                                child: ListTile(
                                  title: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        gradient: getCategoryColor(
                                            goalData['category']),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      '${goalData['category'].toUpperCase()}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      // gap between lines

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
                                          margin:
                                              const EdgeInsets.only(left: 10),
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
                                                    style: TextStyle(
                                                        fontSize: 10.0),
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
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
