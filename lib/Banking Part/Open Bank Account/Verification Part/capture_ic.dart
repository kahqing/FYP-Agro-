import 'dart:io';

import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/capture_back_ic.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class CaptureICScreen extends StatefulWidget {
  final String id;
  const CaptureICScreen({super.key, required this.id});

  @override
  State<CaptureICScreen> createState() => _CaptureICScreenState();
}

class _CaptureICScreenState extends State<CaptureICScreen> {
  Database db = Database();
  String scannedText = "";
  String scannedICNumFront = "";
  String scannedposcode = "";
  String name = "";
  List<String> states = [];
  String imageUrl = '';
  XFile? imageFile;
  RegExp icPattern = RegExp(r'\b\d{6}-\d{2}-\d{4}\b');

  Future<String> uploadImageToStorage(File imageFile, id) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$id/front_ic");
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return e.toString();
    }
  }

  Future updateFrontImage(id, frontIC, ic) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'frontIC': frontIC,
      'ic': ic,
      'statusFront': "Captured",
    };

    documentReference.update(data);
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
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
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: const Text(
                  "Please capture the front of MyKad.",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              if (imageFile == null)
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 251, 251, 251),
                  ),
                ),
              if (imageFile != null) Image.file(File(imageFile!.path)),
              Visibility(
                visible: imageFile == null,
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
                            getImage(ImageSource.gallery);
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
                visible: imageFile != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
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
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () async {
                            // to check it is Malaysian IC
                            if (scannedText
                                    .toLowerCase()
                                    .contains("warganegara") ||
                                scannedText
                                    .toLowerCase()
                                    .contains("malaysia") ||
                                scannedText
                                    .toLowerCase()
                                    .contains("kadpengenalan")) {
                              imageUrl = await uploadImageToStorage(
                                  File(imageFile!.path), id);

                              await updateFrontImage(
                                  id, imageUrl, scannedICNumFront);

                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          CaptureBackICScreen(id: id)));

                              // const snackBar = SnackBar(
                              //   content: Text(
                              //     "Valid card. GOODDDDDDD!!!!!",
                              //     style: TextStyle(color: Colors.black),
                              //   ),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.only(
                              //         topLeft: Radius.circular(15),
                              //         topRight: Radius.circular(15)),
                              //   ),
                              //   backgroundColor:
                              //       Color.fromARGB(255, 245, 179, 255),
                              // );
                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(snackBar);
                            } else {
                              const snackBar = SnackBar(
                                content: Text(
                                  "Please capture your Identification Card properly.",
                                  style: TextStyle(color: Colors.black),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 245, 179, 255),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
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
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    child: Text(
                      "full text:" +
                          scannedText +
                          "\nic:" +
                          scannedICNumFront +
                          "\nposcode:" +
                          scannedposcode +
                          "\nstate:" +
                          states.join(", ") +
                          "\nname:" +
                          name,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageFile = pickedImage;
        print('{imageFile?.path}');

        getRecognisedText(pickedImage);

        setState(() {});
      }
    } catch (e) {
      imageFile = null;

      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    print("Start Scanning....");
    final inputImage = InputImage.fromFilePath(image.path);
    TextRecognizer textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          scannedText = scannedText + word.text + "";
        }
        scannedText = scannedText + "\n";
      }
    }
    print("Finish Scanning....");
    Match? icNum = icPattern.firstMatch(scannedText);
    if (icNum != null) {
      String icNumber = icNum.group(0)!;
      scannedICNumFront = icNumber; // This will print the matched IC number
    } else {
      scannedICNumFront = "";
    }

    // Define a regular expression pattern for extracting postcode

    // Match? posMatch = posPattern.firstMatch(scannedText);
    // if (posMatch != null) {
    //   String poscode = posMatch.group(0)!;
    //   scannedposcode = poscode; // This will print the matched IC number
    // } else {
    //   scannedposcode = "";
    // }

    // List<String> knownStates = [
    //   "SABAH",
    //   "PAHANG",
    //   "PENANG",
    //   "SELANGOR",
    //   "JOHOR",
    //   "PERAK",
    //   "KEDAH",
    //   "PERLIS",
    //   "TERENGGANU",
    //   "KELANTAN",
    //   "NEGERI SEMBILAN",
    //   "MELAKA"
    // ];

    // // Define a regular expression pattern for extracting state
    // String statePattern = r'\b(?:' + knownStates.join('|') + r')\b';
    // Iterable<Match> stateMatches =
    //     RegExp(statePattern, caseSensitive: false).allMatches(scannedText);
    // List<String> matchedStates =
    //     stateMatches.map((match) => match.group(0)!).toList();
    // states = matchedStates;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
