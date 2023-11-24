import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  Future<String> uploadBackICImageToStorage(File imageFile, id) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$id/back_ic");
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return e.toString();
    }
  }

  Future updateBackImage(id, backIC) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'backIC': backIC,
      'statusBack': "Captured",
    };

    documentReference.update(data);
  }

  Future updateStatusFace(id) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'statusFace': "Captured",
    };

    documentReference.update(data);
  }

  Future updateStatusAcc(id) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'statusAcc': "Captured",
    };

    documentReference.update(data);
  }

  Future<String> getICNumFromFirestore(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String frontIC = data["ic"];
        return frontIC;
      } else {
        // Document does not exist for the given username
        return "Document does not exist";
      }
    } catch (e) {
      print("Error retrieving image URL from Firestore: $e");
      return e.toString();
    }
  }

  Future<String> getStatusStep1(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String statusFace = data["statusFront"];
        return statusFace ?? "Status is null";
      } else {
        // Document does not exist for the given username
        return "Document does not exist";
      }
    } catch (e) {
      print("Error retrieving status from Firestore: $e");
      return e.toString();
    }
  }

  Future<File?> retrieveImageFromFirestore(id, fileName) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String imageUrl = data["frontIC"];

        // Download the image from the URL
        final response = await http.get(Uri.parse(imageUrl));
        final documentDirectory = await getTemporaryDirectory();
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;

          // Save the downloaded image to a local file
          final file = File('${documentDirectory.path}/$fileName');
          await file.writeAsBytes(bytes);

          return file;
        } else {
          // Handle the case where the image couldn't be downloaded
          return null;
        }
      } else {
        // Document does not exist for the given ID
        return null;
      }
    } catch (e) {
      print("Error retrieving image URL from Firestore: $e");
      return null;
    }
  }
}
