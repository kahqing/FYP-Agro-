import 'dart:convert';
import 'dart:io';

import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/done_verification.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/ekyc_form_1.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/failed_verification.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VerifyFaceScreen extends StatefulWidget {
  final String id;

  const VerifyFaceScreen({super.key, required this.id});

  @override
  State<VerifyFaceScreen> createState() => _VerifyFaceScreenState();
}

class _VerifyFaceScreenState extends State<VerifyFaceScreen> {
  String resultMessage = '';
  File? imageFile1;
  File? imageFile2;
  Database db = Database();
  StatusMessage msg = StatusMessage();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future getImage2() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile2 = File(image.path);
      });
    }
  }

  void _compareFaces(id) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    print('Starting _compareFaces...');
    final file = await db.retrieveImageFromFirestore(id, 'local_image.jpg');

    if (file == null || imageFile2 == null) {
      // Handle if images are not selected
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.105.8.223:5000/compare_faces'),
    );

    // Use the locally saved image for comparison
    request.files.add(
      await http.MultipartFile.fromPath('image1', file.path),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image2', imageFile2!.path),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedResponse = json.decode(responseData);

        // Check if faces matched
        bool match = decodedResponse['match'][0];

        setState(() {
          resultMessage = match ? "Faces Matched" : "Face does not match";
        });

        if (match) {
          await db.updateStatusFace(id);
          msg.showSuccessMessage("Face Validated.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EKYCFormScreen(id: id)),
          );
        } else {
          msg.showUnsuccessMessage("Face does not match.");

          // const snackBar = SnackBar(
          //   content: Text(
          //     "Failed.",
          //     style: TextStyle(color: Colors.black),
          //   ),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          //   ),
          //   backgroundColor: Color.fromARGB(255, 245, 179, 255),
          // );
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        // Print the full error message
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Print the full error message
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
    print('Finished _compareFaces...');
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   title: const Text("Card Scanner"),
        //   elevation: 0,
        //   backgroundColor: const Color.fromARGB(255, 135, 27, 19),
        // ),
        body: Stack(
      children: [
        Container(
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
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: const Text(
                        "Please capture your face.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (imageFile2 == null)
                      Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 210, 210, 210),
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
                                      color: Color.fromARGB(255, 158, 158, 158),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    if (imageFile2 != null)
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(imageFile2!.path),
                            width: 350,
                            height: 350,
                            fit: BoxFit.cover,
                          )),
                    Visibility(
                      visible: imageFile2 == null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                onPressed: () {
                                  getImage2();
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: imageFile2 != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 100,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                onPressed: () {
                                  getImage2();
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: const Text(
                                      "Retake",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    )),
                              )),
                          Container(
                              width: 100,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                onPressed: () async {
                                  _compareFaces(id);
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: const Text(
                                      "Next",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    )),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(resultMessage),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) // Display loading overlay when isLoading is true
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SpinKitFadingCube(
                size: 50,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
      ],
    ));
  }
}
