import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/ekyc_form_2.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/material.dart';

enum Gender { Male, Female }

class EKYCFormScreen extends StatefulWidget {
  final String id;

  const EKYCFormScreen({super.key, required this.id});

  @override
  State<EKYCFormScreen> createState() => _EKYCFormScreenState();
}

class _EKYCFormScreenState extends State<EKYCFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  late Future<Map<String, String>> icFuture;
  late Future<String> addressFuture;
  String frontIC = '';
  String name = '';
  String addressLast = '';
  Database db = Database();
  TextEditingController icController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();

  Gender? selectedGender;

  @override
  void initState() {
    super.initState();
    icFuture = db.getICNumAndNameAndAddressFromFirestore(widget.id);
    // addressFuture = db.getAddress(widget.id);
    getAddress();

    icController = TextEditingController();
    nameController = TextEditingController();
    address1Controller = TextEditingController();

    icFuture.then((icData) {
      setState(() {
        frontIC = icData['frontIC'] ?? '';
        icController.text = frontIC;
        name = icData['name'] ?? '';
        nameController.text = name;
        // addressLast = icData['addressLat'] ?? '';
        // address2Controller.text = addressLast;
        selectedGender = getGenderFromIC(frontIC);
      });
    });

    icFuture.then((icData) {
      String frontIC = icData['frontIC'] ?? '';
      if (frontIC.isNotEmpty && frontIC.length >= 6) {
        String icPrefix = frontIC.substring(0, 6);
        int yearPrefix = int.parse(icPrefix.substring(0, 2));
        int year = (yearPrefix < 30) ? 2000 + yearPrefix : 1900 + yearPrefix;
        int month = int.parse(icPrefix.substring(2, 4));
        int day = int.parse(icPrefix.substring(4, 6));

        DateTime initialDate = DateTime(year, month, day);
        dateController.text = "${initialDate.toLocal()}".split(' ')[0];
        selectedDate = initialDate;
      }
    });
  }

  Future<void> getAddress() async {
    String addressLast = await db.getAddress(widget.id);
    setState(() {
      address1Controller.text = addressLast;
    });
  }

  Gender getGenderFromIC(String ic) {
    int lastDigit = int.parse(ic.substring(ic.length - 1));
    return (lastDigit % 2 == 0) ? Gender.Female : Gender.Male;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? initialDate = selectedDate ?? currentDate;

    Map<String, String> icData = await icFuture;
    String? frontIC = icData['frontIC'];
    String icPrefix = frontIC?.substring(0, 6) ?? '';

    // Use the extracted IC prefix to set the initial date
    if (icPrefix.isNotEmpty) {
      int yearPrefix = int.parse(icPrefix.substring(0, 2));
      int year = (yearPrefix < 30) ? 2000 + yearPrefix : 1900 + yearPrefix;
      int month = int.parse(icPrefix.substring(2, 4));
      int day = int.parse(icPrefix.substring(4, 6));

      initialDate = DateTime(year, month, day);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked?.toLocal()}".split(' ')[0]; // Update dateController
      });
    }
  }

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
                          "Please tell us a little bit about yourself. ",
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
                              child: TextFormField(
                                // readOnly: true,
                                controller: nameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person_2_outlined,
                                      color: Color.fromARGB(255, 91, 91, 91)
                                          .withOpacity(0.7),
                                    ),
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 91, 91, 91)
                                            .withOpacity(0.8)),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.2),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 1, style: BorderStyle.none),
                                    ),
                                    labelText: "Full name as MyKad"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your username!";
                                  } else {
                                    return null;
                                  }
                                },
                                // onChanged: (value) {
                                //   setState(() {
                                //     username = value;
                                //   });
                                // },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                readOnly: true,
                                controller: icController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person_2,
                                      color: Color.fromARGB(255, 91, 91, 91)
                                          .withOpacity(0.7),
                                    ),
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 91, 91, 91)
                                            .withOpacity(0.8)),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(0.2),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 1, style: BorderStyle.none),
                                    ),
                                    labelText: "IC Number"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your IC Number!";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                onTap: () {
                                  _selectDate(context);
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.date_range_outlined,
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
                                  labelText: "Date of Birth",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your DOB!";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: dateController,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: DropdownButtonFormField(
                                borderRadius: BorderRadius.circular(20),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
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
                                  labelText: "Gender",
                                ),
                                value: selectedGender,
                                items: <Gender>[
                                  Gender.Male,
                                  Gender.Female,
                                ].map<DropdownMenuItem<Gender>>((Gender value) {
                                  return DropdownMenuItem<Gender>(
                                    value: value,
                                    child: Text(value == Gender.Male
                                        ? 'Male'
                                        : 'Female'),
                                  );
                                }).toList(),
                                onChanged: (Gender? value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                controller: address1Controller,
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
                                  labelText: "Address",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your address!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 160, 24, 14)),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // String fulladdress =
                                      //     '${address1Controller.text} ${address2Controller.text}';

                                      String genderString =
                                          selectedGender.toString();
                                      db.updateUserInfo1(
                                          name,
                                          dateController.text,
                                          genderString,
                                          address1Controller.text,
                                          id);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EKYCFormSreen2(
                                                    id: id,
                                                    ic: icController.text,
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
