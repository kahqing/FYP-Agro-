import 'dart:io';

import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/capture_back_ic.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  StatusMessage msg = StatusMessage();
  bool isLoading = false;
  bool isCapturing = false;
  String scannedText = "";
  String scannedName = "";
  String scannedICNumFront = "";
  String scannedposcode = "";
  String district = "";
  String username = "";
  List<String> states = [];
  String imageUrl = '';
  XFile? imageFile;
  RegExp icPattern = RegExp(r'\b\d{6}-\d{2}-\d{4}\b');
  // RegExp posPattern = RegExp(r'\b\d{5}\b');
  RegExp namePattern = RegExp(r'\b(?:([A-Z][a-z]+)\s+)+\b');

  // Future<bool> compareAddress(id) async {
  //   final address = await db.getAddress(id);

  //   final List<String> scannedWords =
  //       scannedText.toLowerCase().split(RegExp(r'\s+'));
  //   final List<String> addressWords =
  //       address.toLowerCase().split(RegExp(r'\s+'));

  //   for (String word in scannedWords) {
  //     if (!addressWords.contains(word)) {
  //       return false;
  //     }
  //   }

  //   return true;
  // }

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

  Future updateFrontImage(id, name, frontIC, addressLast, ic) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'frontIC': frontIC,
      'ic': ic,
      'name': name,
      'addressLat': addressLast,
      'statusFront': "Captured",
    };

    documentReference.update(data);
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
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
                  if (imageFile != null)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(imageFile!.path),
                          width: 350,
                          height: 350,
                          fit: BoxFit.cover,
                        )),
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
                                getImage(ImageSource.camera);
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
                                getImage(ImageSource.camera);
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
                                setState(() {
                                  isLoading = true; // Set loading state to true
                                });
                                try {
                                  if (scannedText
                                          .toLowerCase()
                                          .contains("warganegara") ||
                                      scannedText
                                          .toLowerCase()
                                          .contains("malaysia") ||
                                      scannedText
                                          .toLowerCase()
                                          .contains("kadpengenalan")) {
                                    String addressLast =
                                        "$scannedposcode ${states.join(", ")}";
                                    imageUrl = await uploadImageToStorage(
                                        File(imageFile!.path), id);

                                    await updateFrontImage(
                                        id,
                                        username,
                                        imageUrl,
                                        addressLast,
                                        scannedICNumFront);

                                    msg.showSuccessMessage("Valid IC!");

                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                CaptureBackICScreen(id: id)));
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
                                } catch (error) {
                                  msg.showUnsuccessMessage(
                                      "Failed to create: $error");
                                } finally {
                                  setState(() {
                                    isLoading =
                                        false; // Set loading state to false
                                  });
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
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Column(
                  //   children: [
                  //     Container(
                  //       child: Text(
                  //         "full text:" +
                  //             scannedText +
                  //             "\nic:" +
                  //             scannedICNumFront +
                  //             "\nposcode:" +
                  //             scannedposcode +
                  //             "\nstate:" +
                  //             states.join(", ") +
                  //             "\nusername: $username" +
                  //             "district: $district",
                  //         style: const TextStyle(fontSize: 20),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
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
        Visibility(
          visible: isCapturing,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: SpinKitFadingCube(
                size: 50,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  void getImage(ImageSource source) async {
    try {
      setState(() {
        isCapturing = true; // Set capturing state to true
      });

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
    } finally {
      setState(() {
        isCapturing = false; // Set capturing state to false
      });
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
          scannedText = scannedText + word.text + " ";
        }
        scannedText = scannedText + "\n";
      }
    }

    print("Finish Scanning....");

    Match? icNum = icPattern.firstMatch(scannedText);
    if (icNum != null) {
      String icNumber = icNum.group(0)!;
      scannedICNumFront = icNumber; // This will print the matched IC number

      // Testing for finding the username
      int icPosition = scannedText.indexOf(icNumber);

      if (icPosition != -1) {
        // Extract the text after the IC number
        String textAfterIC =
            scannedText.substring(icPosition + icNumber.length).trim();

        // Now, you can further process textAfterIC to find the user name
        List<String> lines = textAfterIC.split('\n');

        // Iterate through the lines to find a valid username
        String userName = "";
        for (int i = 0; i < lines.length; i++) {
          userName = lines[i].trim();
          // Check if the user name has at least two parts
          List<String> nameParts = userName.split(' ');
          if (nameParts.length >= 3) {
            setState(() {
              username = userName;
            });

            print("User Name: $userName");
            break; // Exit the loop if a valid username is found
          }
        }

        if (userName.isEmpty || userName.split(' ').length < 3) {
          print("Invalid username format");
        }

        // Extracting the address and postcode
        // Extracting the address, postcode, and district

        RegExp addressPattern = RegExp(r'\b\d{5}\b\s*(\S.*)');
        Match? posMatch = addressPattern.firstMatch(textAfterIC);

        if (posMatch != null) {
          String poscode = posMatch.group(0)!; // Group 1 contains the postcode
          scannedposcode = poscode;

          // Extracting the state
          String statePattern =
              r'\b(?:SABAH|PAHANG|PENANG|SELANGOR|JOHOR|PERAK|KEDAH|PERLIS|TERENGGANU|KELANTAN|NEGERI SEMBILAN|MELAKA|WILAYAH PERSEKUTUAN)\b';
          Iterable<Match> stateMatches =
              RegExp(statePattern, caseSensitive: false)
                  .allMatches(textAfterIC);
          List<String> matchedStates =
              stateMatches.map((match) => match.group(0)!).toList();
          states = matchedStates;
        }
      }
    } else {
      scannedICNumFront = "";
    }

    // Define a regular expression pattern for extracting postcode

    //   Match? posMatch = posPattern.firstMatch(scannedText);
    //   if (posMatch != null) {
    //     String poscode = posMatch.group(0)!;
    //     scannedposcode = poscode; // This will print the matched IC number
    //   } else {
    //     scannedposcode = "";
    //   }

    //   List<String> knownStates = [
    //     "SABAH",
    //     "PAHANG",
    //     "PENANG",
    //     "SELANGOR",
    //     "JOHOR",
    //     "PERAK",
    //     "KEDAH",
    //     "PERLIS",
    //     "TERENGGANU",
    //     "KELANTAN",
    //     "NEGERI SEMBILAN",
    //     "MELAKA"
    //   ];

    //   // Define a regular expression pattern for extracting state
    //   String statePattern = r'\b(?:' + knownStates.join('|') + r')\b';
    //   Iterable<Match> stateMatches =
    //       RegExp(statePattern, caseSensitive: false).allMatches(scannedText);
    //   List<String> matchedStates =
    //       stateMatches.map((match) => match.group(0)!).toList();
    //   states = matchedStates;

    //   setState(() {});
    // }

    @override
    void initState() {
      super.initState();
    }
  }
}
