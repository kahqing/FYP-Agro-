import 'dart:convert';
import 'dart:io';

import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/success_page.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/unsuccess_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FaceCompareScreen extends StatefulWidget {
  final String id;
  const FaceCompareScreen({super.key, required this.id});

  @override
  State<FaceCompareScreen> createState() => _FaceCompareScreenState();
}

class _FaceCompareScreenState extends State<FaceCompareScreen> {
  String resultMessage = '';
  File? imageFile1;
  File? imageFile2;

  @override
  void initState() {
    super.initState();

    // _fetchImageFromFirestore();
  }

  // void _fetchImageFromFirestore() async {
  //   // Fetch the image URL and assign it to imageFile1
  //   imageFile1 = await getImageURLFromFirestore(widget.id);
  //   // Trigger a rebuild to reflect the changes in the UI
  //   setState(() {});
  // }

  // Future<File?> getImageURLFromFirestore(id) async {
  //   try {
  //     final CollectionReference collection =
  //         FirebaseFirestore.instance.collection("matric");

  //     DocumentSnapshot document = await collection.doc(id).get();

  //     if (document.exists) {
  //       Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //       String imageUrl = data["frontIC"];
  //       return File(imageUrl);
  //     } else {
  //       // Document does not exist for the given ID
  //       return null; // or return some default File if appropriate
  //     }
  //   } catch (e) {
  //     print("Error retrieving image URL from Firestore: $e");
  //     return null; // or handle the error appropriately
  //   }
  // }

  Future getImage1() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile1 = File(image.path);
      });
    }
  }

  Future getImage2() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile2 = File(image.path);
      });
    }
  }

  void _compareFaces() async {
    print('Starting _compareFaces...');
    if (imageFile1 == null || imageFile2 == null) {
      // Handle if images are not selected
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.105.9.249:5000/compare_faces'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image1', imageFile1!.path),
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

        if (match) {
          // Redirect to the success page
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessScreen(),
            ),
          );
        } else {
          // Update the result message
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UnsuccessScreen(),
            ),
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
        appBar: AppBar(
          title: const Text("Card Scanner"),
          backgroundColor: const Color.fromARGB(255, 135, 27, 19),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
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
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
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
                  if (imageFile1 != null) Image.file(imageFile1!),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () {
                          getImage1();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
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
                  if (imageFile2 != null) Image.file(imageFile2!),
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
                          _compareFaces();
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
                  // if (imageFile2 == null)
                  //   Container(
                  //     width: 300,
                  //     height: 300,
                  //     color: const Color.fromARGB(255, 255, 255, 255),
                  //   ),
                  // if (imageFile2 != null)
                  //   Container(
                  //       margin: const EdgeInsets.symmetric(horizontal: 20),
                  //       child: Image.file(File(imageFile2!.path))),
                  // Visibility(
                  //   visible: imageFile2 == null,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //           margin: const EdgeInsets.symmetric(horizontal: 5),
                  //           padding: const EdgeInsets.only(top: 10),
                  //           child: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               primary: Color.fromARGB(255, 255, 255, 255),
                  //               shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(8.0)),
                  //             ),
                  //             onPressed: () {
                  //               getImage2();
                  //             },
                  //             child: Container(
                  //               margin: const EdgeInsets.symmetric(
                  //                   vertical: 5, horizontal: 5),
                  //               child: const Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: [
                  //                   Center(
                  //                     child: Icon(
                  //                       Icons.camera_alt,
                  //                       size: 30,
                  //                       color: Color.fromARGB(255, 0, 0, 0),
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     "Camera",
                  //                     style: TextStyle(
                  //                         fontSize: 13,
                  //                         color: Color.fromARGB(255, 0, 0, 0)),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // Visibility(
                  //   visible: imageFile2 != null,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //           width: 100,
                  //           margin: const EdgeInsets.symmetric(horizontal: 5),
                  //           padding: const EdgeInsets.only(top: 10),
                  //           child: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               primary: Color.fromARGB(255, 255, 255, 255),
                  //               shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(8.0)),
                  //             ),
                  //             onPressed: () {
                  //               getImage2();
                  //             },
                  //             child: Container(
                  //                 margin: const EdgeInsets.symmetric(
                  //                     vertical: 5, horizontal: 5),
                  //                 child: const Text(
                  //                   "Retake",
                  //                   style: TextStyle(
                  //                       fontSize: 13,
                  //                       color: Color.fromARGB(255, 0, 0, 0)),
                  //                 )),
                  //           )),
                  //       Container(
                  //           width: 100,
                  //           margin: const EdgeInsets.symmetric(horizontal: 5),
                  //           padding: const EdgeInsets.only(top: 10),
                  //           child: ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               primary: Color.fromARGB(255, 255, 255, 255),
                  //               shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(8.0)),
                  //             ),
                  //             onPressed: () async {
                  //               _compareFaces();
                  //             },
                  //             child: Container(
                  //                 margin: const EdgeInsets.symmetric(
                  //                     vertical: 5, horizontal: 5),
                  //                 child: const Text(
                  //                   "Next",
                  //                   style: TextStyle(
                  //                       fontSize: 13,
                  //                       color: Color.fromARGB(255, 0, 0, 0)),
                  //                 )),
                  //           )),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
