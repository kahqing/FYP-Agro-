import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/ask_virtualcard.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/done_verification.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/info_capture_face.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EKYCFormSreen2 extends StatefulWidget {
  final String id;
  final String ic;
  const EKYCFormSreen2({super.key, required this.id, required this.ic});

  @override
  State<EKYCFormSreen2> createState() => _EKYCFormSreen2State();
}

class _EKYCFormSreen2State extends State<EKYCFormSreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StatusMessage msg = StatusMessage();
  Database db = Database();
  String? selectedReligion;
  List<String> religionOptions = [
    'Islam',
    'Buddhist',
    'Christian',
    'Hindu',
    'Others'
  ];
  String? selectedRace;
  List<String> raceOptions = ['Malay', 'Indian', 'Chinese'];
  String? selectedMaritalStatus;
  List<String> maritalStatusOptions = [
    "Married",
    "Single",
    "Divorced",
    "Widowed"
  ];
  String? selectedOccupation;
  List<String> occupationOptions = [
    'Government employee',
    'Private employee',
    'Self-employed',
    'Student'
  ];

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(top: 8, bottom: 5),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Text(""),
                )),
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Color.fromARGB(255, 229, 48, 48),
                    Color.fromARGB(255, 127, 18, 18)
                  ])),
              child: FlexibleSpaceBar(

                  // title: Text("Verification"),
                  background: Container(
                margin: const EdgeInsets.all(20),
                child: const Center(
                    child: Flexible(
                        child: Text("Let's fill up the form.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontSize: 25),
                            textAlign: TextAlign.center))),
              )),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                          "Please tell us a little bit about your background. ",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: DropdownButtonFormField(
                                borderRadius: BorderRadius.circular(20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_2_outlined,
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.7),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.8),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        width: 1, style: BorderStyle.none),
                                  ),
                                  labelText: "Race",
                                ),
                                value: selectedRace,
                                items: raceOptions.map((String option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedRace = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please choose a race!";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: DropdownButtonFormField(
                                borderRadius: BorderRadius.circular(20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_2_outlined,
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.7),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.8),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        width: 1, style: BorderStyle.none),
                                  ),
                                  labelText: "Religion",
                                ),
                                value: selectedReligion,
                                items: religionOptions.map((String option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedReligion = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please choose a religion!";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: DropdownButtonFormField(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_2_outlined,
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.7),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.8),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        width: 1, style: BorderStyle.none),
                                  ),
                                  labelText: "Marital Status",
                                ),
                                value: selectedMaritalStatus,
                                items:
                                    maritalStatusOptions.map((String option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(
                                      option,
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedMaritalStatus = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please choose a marital status!";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: DropdownButtonFormField(
                                borderRadius: BorderRadius.circular(20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_2_outlined,
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.7),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 91, 91, 91)
                                        .withOpacity(0.8),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        width: 1, style: BorderStyle.none),
                                  ),
                                  labelText: "Occupation",
                                ),
                                value: selectedOccupation,
                                items: occupationOptions.map((String option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedOccupation = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please choose your occupation!";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 160, 24, 14)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              db.updateUserInfo2(
                                  id,
                                  selectedRace,
                                  selectedReligion,
                                  selectedMaritalStatus,
                                  selectedOccupation);

                              db.updateStatusStep1(id);

                              msg.showSuccessMessage("Save successfully!");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AskVirtualCard(
                                            id: id,
                                          )));
                            }
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
