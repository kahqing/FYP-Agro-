import 'package:flutter/material.dart';

class OpenBankAccScreen extends StatefulWidget {
  const OpenBankAccScreen({super.key});

  @override
  State<OpenBankAccScreen> createState() => _OpenBankAccScreenState();
}

class _OpenBankAccScreenState extends State<OpenBankAccScreen> {
  @override
  Widget build(BuildContext context) {
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
            backgroundColor:
                const Color.fromARGB(223, 255, 0, 0).withOpacity(1),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
                // title: Text("Verification"),
                background: Container(
              margin: const EdgeInsets.all(20),
              child: const Center(
                  child: Flexible(
                      child: Text(
                          "Please tell us a little bit about yourself. ",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                          textAlign: TextAlign.justify))),
            )),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
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
                            fillColor: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1, style: BorderStyle.none),
                            ),
                            labelText: "Username"),
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
                            fillColor: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1, style: BorderStyle.none),
                            ),
                            labelText: "Username"),
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
                            fillColor: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1, style: BorderStyle.none),
                            ),
                            labelText: "Username"),
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
                            fillColor: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1, style: BorderStyle.none),
                            ),
                            labelText: "Username"),
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
                            fillColor: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  width: 1, style: BorderStyle.none),
                            ),
                            labelText: "Username"),
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
