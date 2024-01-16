import 'dart:io';

import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Bottom%20Navigation%20Bar/bottom_navi.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddNewGoalScreen extends StatefulWidget {
  final String id;
  const AddNewGoalScreen({super.key, required this.id});

  @override
  State<AddNewGoalScreen> createState() => _AddNewGoalScreenState();
}

const List<String> list = <String>[
  'Gifts',
  'Entertainment',
  'Special Events',
  'Travel',
  'Others'
];

class _AddNewGoalScreenState extends State<AddNewGoalScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  DateTime startdate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Database db = Database();
  StatusMessage msg = StatusMessage();
  String selectedCategory = list.first;
  File? _image;

  Future<void> _pickImage(ImageSource method) async {
    final pickedFile = await ImagePicker().pickImage(source: method);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (picked != null) {
      selectedDate = picked;
      dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  void initState() {
    super.initState();

    startdateController.text = "${DateTime.now().toLocal()}".split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              Color.fromARGB(255, 255, 243, 222),
              Color.fromARGB(255, 255, 227, 249)
            ])),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          size: 40,
                        ),
                        onPressed: () {
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    ),
                    _image == null
                        ? Container(
                            width: 150,
                            height: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1,
                                  color: const Color.fromARGB(255, 99, 99, 99)),
                              color: Color.fromARGB(255, 207, 207, 207),
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_size_select_actual_outlined,
                                      color: Color.fromARGB(255, 158, 158, 158),
                                      size: 50,
                                    ),
                                    Text(
                                      "No Image",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 158, 158, 158),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1,
                                  color: const Color.fromARGB(255, 99, 99, 99)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _image!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 40,
                      ),
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Goal Info",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 60,
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 101, 101, 101)
                              .withOpacity(0.8)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 1, style: BorderStyle.none)),
                      labelText: "Goal Name",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Goal Name!";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 60,
                  child: TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 101, 101, 101)
                              .withOpacity(0.8)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 1, style: BorderStyle.none)),
                      labelText: "Target",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Target!";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Goal Duration",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 60,
                  child: TextFormField(
                    readOnly: true,
                    controller: startdateController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 101, 101, 101)
                              .withOpacity(0.8)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 1, style: BorderStyle.none)),
                      labelText: "Start Date",
                    ),
                  ),
                ),
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
                          color: const Color.fromARGB(255, 101, 101, 101)
                              .withOpacity(0.8)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              width: 1, style: BorderStyle.none)),
                      labelText: "End Date",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select your End Date!";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Goal Category",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
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
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
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
                Container(
                  margin: const EdgeInsets.only(bottom: 70, top: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 160, 24, 14),
                      ),
                      onPressed: () async {
                        int duration = daysBetween(startdate, selectedDate);
                        try {
                          if (_formKey.currentState!.validate()) {
                            await db.createGoals(
                                widget.id,
                                titleController.text,
                                amountController.text,
                                startdateController.text,
                                dateController.text,
                                categoryController.text,
                                duration,
                                _image);

                            msg.showSuccessMessage("Created Successfully!");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BottomNavigationBarScreen(id: widget.id),
                              ),
                            );
                          } else {
                            msg.showUnsuccessMessage("Failed to create!");
                          }
                        } catch (error) {
                          // Handle and show error message
                          msg.showUnsuccessMessage("Failed to create: $error");
                        }
                      },
                      child: const Text(
                        "CREATE",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
