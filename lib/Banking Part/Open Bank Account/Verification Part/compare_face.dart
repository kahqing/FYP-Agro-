import 'dart:convert';
import 'dart:io';

import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/done_verification.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/failed_verification.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Future getImage2() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile2 = File(image.path);
      });
    }
  }

  void _compareFaces(id) async {
    print('Starting _compareFaces...');
    final file = await db.retrieveImageFromFirestore(id, 'local_image.jpg');

    if (file == null || imageFile2 == null) {
      // Handle if images are not selected
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.100.11:5000/compare_faces'),
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
          // Faces matched, navigate to a success page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessVerifyScreen(id: id)),
          );
        } else {
          // Faces did not match, navigate to a failure page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FailedVerifiedScreen(id: id)),
          );
        }
      } else {
        // Print the full error message
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      // Print the full error message
      print('Error: $e');
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
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 251, 251, 251),
                    ),
                  ),
                if (imageFile2 != null) Image.file(File(imageFile2!.path)),
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
                                        color: Color.fromARGB(255, 0, 0, 0)),
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
    ));
  }
}
