import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/Components/assets.dart';
import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/congrat.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/material.dart';

class AddExpenses extends StatefulWidget {
  final String matric;
  const AddExpenses({super.key, required this.matric});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

const List<String> list = <String>[
  'Bank',
  'Entertainment',
  'Food',
  'Medical',
  'Shopping',
  'Travel',
  'Others'
];

class _AddExpensesState extends State<AddExpenses> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Database db = Database();

  String selectedCategory = list.first;

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Set the lastDate to be the current date
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.matric;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              "assets/images/expenses_bg.png"), // Replace with your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: SingleChildScrollView(
        // Customize the form layout according to your needs
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  "Spacing",
                  style:
                      TextStyle(color: const Color.fromARGB(0, 255, 255, 255)),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              // Add your dropdown widget
              Container(
                height: 60,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(42, 255, 255, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? value) {
                        // Handle dropdown value change
                        if (value != null) {
                          // Update the state with the new selected value
                          setState(() {
                            selectedCategory = value;
                            categoryController.text = value;
                          });
                        }
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            width: 200,
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Add your title text field
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 60,
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 101, 101, 101)
                            .withOpacity(0.8)),
                    filled: true,
                    fillColor:
                        Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            width: 1, style: BorderStyle.none)),
                    labelText: "Title",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your Title!";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              // Add your amount text field
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 60,
                child: TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 101, 101, 101)
                            .withOpacity(0.8)),
                    filled: true,
                    fillColor:
                        Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                            width: 1, style: BorderStyle.none)),
                    labelText: "Amount",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your Amount!";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              // Add your date text field
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 60,
                child: TextFormField(
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 101, 101, 101).withOpacity(0.8),
                    ),
                    filled: true,
                    fillColor:
                        Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        width: 1,
                        style: BorderStyle.none,
                      ),
                    ),
                    labelText: "Date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please select your Date!";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 120, // Set the desired height
                child: TextFormField(
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4, // Set the number of lines you want to display
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color:
                          Color.fromARGB(255, 101, 101, 101).withOpacity(0.8),
                    ),
                    filled: true,
                    fillColor:
                        Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(width: 1, style: BorderStyle.none),
                    ),
                    labelText: "Description",
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
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
                  // Save button
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await db.addNewExpenses(
                            id,
                            categoryController.text,
                            titleController.text,
                            amountController.text,
                            dateController.text,
                            descController.text);
                        print("Save successfully");

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                CongratulationPage(), // Replace NextPage with the actual class you want to navigate to
                          ),
                        );
                      }
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/save.png',
                        width: 60, // Adjust the width as needed
                        height: 60, // Adjust the height as needed
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      titleController.clear();
                      amountController.clear();
                      dateController.clear();
                      descController.clear();
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/clear.png',
                        width: 60, // Adjust the width as needed
                        height: 60, // Adjust the height as needed
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    ));
  }
}
