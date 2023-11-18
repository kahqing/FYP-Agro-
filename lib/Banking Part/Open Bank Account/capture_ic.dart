import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';

class CaptureICScreen extends StatefulWidget {
  const CaptureICScreen({super.key});

  @override
  State<CaptureICScreen> createState() => _CaptureICScreenState();
}

class _CaptureICScreenState extends State<CaptureICScreen> {
  XFile? imageFront;
  dynamic? _pickerror;
  String extracted = "";

  void getICFront(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);

      if (pickedImage != null) {
        imageFront = pickedImage;

        recognizedText(pickedImage);

        print(extracted);
        setState(() {});
      }
    } catch (e) {
      setState(() {
        _pickerror = e;
        print(e);
      });
    }
  }

  void recognizedText(XFile image) async {
    extracted = await FlutterTesseractOcr.extractText(image.path);
  }

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
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  child: const Text(
                    "Please capture the front of IC.",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                if (imageFront == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                if (imageFront != null)
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.file(File(imageFront!.path))),
                Visibility(
                  visible: imageFront == null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              getICFront(ImageSource.camera);
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
                    ],
                  ),
                ),
                Visibility(
                  visible: imageFront != null,
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
                              getICFront(ImageSource.camera);
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
                              if (extracted
                                  .toLowerCase()
                                  .contains("Malaysia")) {
                                const snackBar = SnackBar(
                                  content: Text(
                                    "Valid Card!!!",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 186, 235, 102),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                const snackBar = SnackBar(
                                  content: Text(
                                    "Noooo invalid Card!!!",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 186, 235, 102),
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
                SizedBox(height: 20),
                Container(
                  child: Text(extracted.toString()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
