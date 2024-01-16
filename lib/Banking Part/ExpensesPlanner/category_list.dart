import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/specific_expense.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/material.dart';

class CategoryListScreen extends StatefulWidget {
  final String matric;
  final String category;
  const CategoryListScreen(
      {super.key, required this.matric, required this.category});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  Database db = Database();
  List<Map<String, dynamic>> expensesList = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore based on widget.category
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    expensesList = await db.getExpensesList(widget.matric, widget.category);
    setState(() {});
  }

  Future<void> refreshData() async {
    expensesList = await db.getExpensesList(widget.matric, widget.category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    expensesList.sort((a, b) => b['date'].compareTo(a['date']));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/list_bg.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: expensesList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Text(
                        widget.category,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: expensesList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpecificExpenseScreen(
                                      id: widget.matric,
                                      category: widget.category,
                                      title: expensesList[index]['title'],
                                      amount: expensesList[index]['amount']),
                                ),
                              ).then((value) => refreshData());
                            },
                            child: Card(
                              elevation: 3, // Set the elevation for the card
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10), // Set margin as needed
                              child: ListTile(
                                title: Text(
                                  '${expensesList[index]['title']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('${expensesList[index]['date']}'),
                                        Text(
                                          'RM ${expensesList[index]['amount']}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Image.asset(
                            'assets/images/back.png',
                            width: 60, // Adjust the width as needed
                            height: 60, // Adjust the height as needed
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: Color.fromARGB(255, 205, 114, 114)),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'No expenses found for ${widget.category} category',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Image.asset(
                          'assets/images/back.png',
                          width: 50, // Adjust the width as needed
                          height: 50, // Adjust the height as needed
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
