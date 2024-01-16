import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/done_verification.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/states_branches.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectBranchScreen extends StatefulWidget {
  final String id;

  const SelectBranchScreen({super.key, required this.id});

  @override
  State<SelectBranchScreen> createState() => _SelectBranchScreenState();
}

class _SelectBranchScreenState extends State<SelectBranchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Database db = Database();
  String? selectedState;
  String? selectedBranch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color.fromARGB(255, 229, 48, 48),
              Color.fromARGB(255, 127, 18, 18)
            ])),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  'Select the branch',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Dropdown for States
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(20),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: Color.fromARGB(255, 91, 91, 91)
                                .withOpacity(0.7),
                          ),
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 91, 91, 91)
                                .withOpacity(0.8),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 1, style: BorderStyle.none),
                          ),
                          labelText: "States",
                        ),
                        value: selectedState,
                        onChanged: (String? value) {
                          setState(() {
                            selectedState = value;
                            selectedBranch = null;
                          });
                        },
                        items: statesAndBranches.keys.map((String state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please choose a state!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Dropdown for Branches (based on selected state)
                    if (selectedState != null)
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(20),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.house_outlined,
                              color: Color.fromARGB(255, 91, 91, 91)
                                  .withOpacity(0.7),
                            ),
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 91, 91, 91)
                                  .withOpacity(0.8),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1, style: BorderStyle.none),
                            ),
                            labelText: "Branch",
                          ),
                          value: selectedBranch,
                          onChanged: (String? value) {
                            setState(() {
                              selectedBranch = value;
                            });
                          },
                          items: statesAndBranches[selectedState!]!
                              .map((String branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text(branch),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please choose a branch!";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      selectedBranch = '$selectedBranch, $selectedState';
                      db.updateBranch(selectedBranch, widget.id);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  SuccessVerifyScreen(id: widget.id)));
                    }
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.black),
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
