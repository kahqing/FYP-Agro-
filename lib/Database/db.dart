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
      'statusAcc': "Active",
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

  Future<String> getaddressLast(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String addresslast = data["addressLast"];
        return addresslast;
      } else {
        // Document does not exist for the given username
        return "Document does not exist";
      }
    } catch (e) {
      print("Error retrieving address from Firestore: $e");
      return e.toString();
    }
  }

  Future<Map<String, String>> getICNumAndNameAndAddressFromFirestore(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String frontIC = data["ic"];
        String name = data["name"];
        String addressLast = data["addressLat"];

        // Return a map containing frontIC, name, and addressLast
        return {"frontIC": frontIC, "name": name, "addressLat": addressLast};
      } else {
        // Document does not exist for the given id
        return {"error": "Document does not exist"};
      }
    } catch (e) {
      print("Error retrieving data from Firestore: $e");
      return {"error": e.toString()};
    }
  }

  Future<String> getAddress(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String frontIC = data["address"];
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
        String statusStep1 = data["statusStep1"];
        return statusStep1;
      } else {
        // Document does not exist for the given username
        return "Document does not exist";
      }
    } catch (e) {
      print("Error retrieving status from Firestore: $e");
      return e.toString();
    }
  }

  Future updateStatusStep1(id) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'statusStep1': "Done",
    };

    documentReference.update(data);
  }

  Future<String> getStatusAcc(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String statusAcc = data["statusAcc"];
        return statusAcc;
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

  // Future<void> createUserInfo(
  //     ic, name, dob, gender, address1, address2, id) async {
  //   try {
  //     final CollectionReference userCollection =
  //         FirebaseFirestore.instance.collection("user");

  //     final DocumentReference userDoc = userCollection.doc(id);
  //     final CollectionReference categoryCollection =
  //         userDoc.collection("accinfo");

  //     // Add the goal to the specific category
  //     await categoryCollection.add({
  //       'ic': ic,
  //       'name': name,
  //       'dob': dob,
  //       "gender": gender,
  //       'address1': address1,
  //       'address2': address2
  //     });
  //   } catch (error) {
  //     print("Error saving user info: $error");
  //     throw error; // Rethrow the error to handle it in the calling code
  //   }
  // }

  Future updateUserInfo1(name, dob, gender, address, id) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'dob': dob,
      "gender": gender,
      'newAddress': address,
    };

    try {
      await documentReference.update(data);
      print('Update successful');
      // You can return a success indicator if needed
    } catch (e) {
      print('Error updating document: $e');
      // You can return an error indicator or rethrow the error if needed
      throw e;
    }
  }

  Future<void> updateUserInfo2(String id, String? race, String? religion,
      String? maritalStatus, String? occupation) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'race': race ?? "", // Provide a default value if null
      'religion': religion ?? "", // Provide a default value if null
      'maritalStatus': maritalStatus ?? "", // Provide a default value if null
      'occupation': occupation ?? "", // Provide a default value if null
    };

    await documentReference.update(data);
  }

  Future updateUserInfo(
      id, ic, race, religion, maritalStatus, occupation) async {
    final CollectionReference goalCollection = FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .collection("accinfo");

    final QuerySnapshot querySnapshot =
        await goalCollection.where("ic", isEqualTo: ic).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot document = querySnapshot.docs.first;
      DocumentReference documentReference = document.reference;

      Map<String, dynamic> data = <String, dynamic>{
        'race': race,
        'religion': religion,
        'maritalStatus': maritalStatus,
        'occupation': occupation,
      };
      await documentReference.update(data);
      print('User info updated successfully');
    } else {
      print('Document does not exist for user with id $id and ic $ic');
      throw Exception('Document not found');
    }
  }

  Future updateCardType(cardType, id) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'PhysicalCard': cardType,
    };

    try {
      await documentReference.update(data);
      print('Update successful');
      // You can return a success indicator if needed
    } catch (e) {
      print('Error updating document: $e');
      // You can return an error indicator or rethrow the error if needed
      throw e;
    }
  }

  Future updateBranch(branch, id) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'branch': branch,
    };

    try {
      await documentReference.update(data);
      print('Update successful');
      // You can return a success indicator if needed
    } catch (e) {
      print('Error updating document: $e');
      // You can return an error indicator or rethrow the error if needed
      throw e;
    }
  }

  // Future<> getBalance(id) async {
  //   try {
  //     final CollectionReference collection =
  //         FirebaseFirestore.instance.collection("user");

  //     DocumentSnapshot document = await collection.doc(id).get();

  //     if (document.exists) {
  //       Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //       double balance = data["balance"] ?? 0.0;
  //       return balance;
  //     } else {
  //       return 0.0; // You can change this default value based on your logic
  //     }
  //   } catch (e) {
  //     print("Error retrieving balance from Firestore: $e");
  //     return 0.0; // You can change this default value based on your logic
  //   }
  // }

  Future<String> getBalance(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        var balance = data["balance"].toStringAsFixed(2);
        String balanceAmount = balance.toString();
        return balanceAmount;
      } else {
        return "Document does not exist";
      }
    } catch (e) {
      print("Error retrieving balance from Firestore: $e");
      return e.toString();
    }
  }

  Future updateAccNum(id, accNum) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      'accNum': accNum,
    };

    documentReference.update(data);
  }

  Future<String> getAccNum(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String accNum = data["accNum"];
        return accNum;
      } else {
        return "Document does not exist";
      }
    } catch (e) {
      print("Error retrieving accNum from Firestore: $e");
      return e.toString();
    }
  }

  //Expenses Game
  Future<void> addNewExpenses(
      matric, category, title, amount, date, description) async {
    final CollectionReference ref = FirebaseFirestore.instance
        .collection("user")
        .doc(matric)
        .collection(category);
    ref.doc().set({
      'category': category,
      'title': title,
      'amount': amount,
      'date': date,
      'description': description
    });
  }

  Future<List<Map<String, dynamic>>> getExpensesList(
      String id, String category) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection(category);

      QuerySnapshot querySnapshot = await collection.get();

      List<Map<String, dynamic>> expensesList = [];

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          expensesList.add(data);
        }
      });

      return expensesList;
    } catch (e) {
      print("Error retrieving expenses from Firestore: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getExpenseInfo(
      String id, String category, String title, amount) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection(category)
          .where('title', isEqualTo: title)
          .where('amount', isEqualTo: amount)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return data;
      } else {
        return {"error": "Document not found"};
      }
    } catch (e) {
      print("Error retrieving data from Firestore: $e");
      return {"error": e.toString()};
    }
  }

  Future<double> getTotalExpensesByCategory(String id, String category) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection(category);

      QuerySnapshot querySnapshot = await collection.get();

      List<Map<String, dynamic>> expensesList = [];

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        if (document.exists) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

          if (data != null) {
            expensesList.add(data);
          }
        }
      });

      double totalAmount = expensesList.fold(0.0, (previous, current) {
        String amountString = current['amount']?.toString() ?? '0.0';
        double amount = double.tryParse(amountString) ?? 0.0;
        return previous + amount;
      });

      return totalAmount;
    } catch (e) {
      print("Error retrieving expenses from Firestore: $e");
      return 0.0; // Return 0.0 in case of an error
    }
  }

  Future<void> deleteExpenses(
      String id, String category, String title, amount) async {
    try {
      final CollectionReference goalCollection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection(category);

      final QuerySnapshot querySnapshot = await goalCollection
          .where('title', isEqualTo: title)
          .where('amount', isEqualTo: amount)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot document = querySnapshot.docs.first;
        if (document.exists) {
          await document.reference.delete();
          print("Expense deleted successfully");
        } else {
          print("Expense does not exist");
        }
      } else {
        print("No matching Expense found");
      }
    } catch (e) {
      print("Error deleting Expense: $e");
    }
  }

  Future<void> createGoals(
      String id,
      String name,
      String target,
      String startDate,
      String endDate,
      String category,
      int duration,
      File? image) async {
    try {
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection("user");

      final DocumentReference userDoc = userCollection.doc(id);
      final CollectionReference categoryCollection =
          userDoc.collection("goals");

      // Upload the image to Firebase Storage
      String imageUrl = await uploadGoalImage(id, image);

      // Add the goal to the specific category
      await categoryCollection.add({
        'category': category,
        'title': name,
        'target': target,
        "days": duration,
        'startDate': startDate,
        'endDate': endDate,
        'currentAmount': 0,
        'status': "In progress",
        'coinCollected': 0,
        'imageUrl': imageUrl
      });
    } catch (error) {
      print("Error creating goal: $error");
      throw error; // Rethrow the error to handle it in the calling code
    }
  }

  Future<String> uploadGoalImage(String userId, File? image) async {
    if (image == null) {
      return ""; // No image to upload
    }

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("goal_images")
        .child(userId)
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    final UploadTask uploadTask = storageReference.putFile(image);

    await uploadTask;

    final String imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
  }

  Future<dynamic> getGoalsInfo(id, category, title) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals")
          .where('title', isEqualTo: title)
          .where('category', isEqualTo: category)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        double currentAmount = data["currentAmount"];

        return currentAmount;
      } else {
        return {"error": "Document not found"};
      }
    } catch (e) {
      print("Error retrieving data from Firestore: $e");
      return {"error": e.toString()};
    }
  }

  Future<String> getTabungAmount(id) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String tabungAmount = data["tabungAmount"];
        return tabungAmount;
      } else {
        return "Document does not exist";
      }
    } catch (e) {
      print("Error retrieving tabung amount from Firestore: $e");
      return e.toString();
    }
  }

  // Future<List<Map<String, dynamic>>> getInProgressGoalList(String id) async {
  //   try {
  //     final CollectionReference goalCollection = FirebaseFirestore.instance
  //         .collection("user")
  //         .doc(id)
  //         .collection("goals");

  //     final QuerySnapshot querySnapshot =
  //         await goalCollection.where("status", isEqualTo: "In progress").get();

  //     List<Map<String, dynamic>> inProgressList = [];

  //     for (final DocumentSnapshot document in querySnapshot.docs) {
  //       Map<String, dynamic> goalData = document.data() as Map<String, dynamic>;

  //       // Fetch image URL or reference and add it to the data
  //       // For example, if you store image URLs
  //       String imageUrl =
  //           goalData['imageUrl']; // Change 'imageUrl' to the actual field name
  //       // You might want to add additional logic to load the image using the URL

  //       // Add other fields you need
  //       inProgressList.add({
  //         'title': goalData['title'],
  //         'target': goalData['target'],
  //         'currentAmount': goalData['currentAmount'],
  //         'category': goalData['category'],
  //         'status': goalData['status'],
  //         'imageUrl': imageUrl, // Add the image URL or reference here
  //       });
  //     }

  //     return inProgressList;
  //   } catch (e) {
  //     print("Error retrieving in-progress goals from Firestore: $e");
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>> getInProgressGoalList(String id) async {
    try {
      final CollectionReference goalCollection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals");

      final QuerySnapshot querySnapshot =
          await goalCollection.where("status", isEqualTo: "In progress").get();

      List<Map<String, dynamic>> inProgressList = [];

      for (final DocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> goalData = document.data() as Map<String, dynamic>;

        inProgressList.add(goalData);
      }

      return inProgressList;
    } catch (e) {
      print("Error retrieving in-progress goals from Firestore: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCompletedGoalList(
      String id, category) async {
    try {
      final CollectionReference goalCollection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals");

      final QuerySnapshot querySnapshot = await goalCollection
          .where("category", isEqualTo: category)
          .where("status", isEqualTo: "Completed")
          .get();

      List<Map<String, dynamic>> completedList = [];

      for (final DocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> goalData = document.data() as Map<String, dynamic>;

        completedList.add(goalData);
      }

      return completedList;
    } catch (e) {
      print("Error retrieving completed goals from Firestore: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCategoryGoalList(
      String id, category) async {
    try {
      final CollectionReference goalCollection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals");

      final QuerySnapshot querySnapshot = await goalCollection
          .where("category", isEqualTo: category)
          .where("status", isEqualTo: "In progress")
          .get();

      List<Map<String, dynamic>> categoryList = [];

      for (final DocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> goalData = document.data() as Map<String, dynamic>;

        categoryList.add(goalData);
      }

      return categoryList;
    } catch (e) {
      print("Error retrieving category list from Firestore: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllGoalList(String id) async {
    try {
      final CollectionReference goalCollection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals");

      QuerySnapshot querySnapshot = await goalCollection.get();

      List<Map<String, dynamic>> allGoals = [];

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          allGoals.add(data);
        }
      });

      return allGoals;
    } catch (e) {
      print("Error retrieving in-progress goals from Firestore: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getGoalInfo(
      String id, String category, String title) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals")
          .where('category', isEqualTo: category)
          .where('title', isEqualTo: title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return data;
      } else {
        return {"error": "Document not found"};
      }
    } catch (e) {
      print("Error retrieving data from Firestore: $e");
      return {"error": e.toString()};
    }
  }

  Future<void> updateTabungAmount(
      String id, double amount, bool isWithdrawal) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    try {
      final DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Parse tabungAmount as a double
          double currentTabungAmount =
              double.tryParse(data['tabungAmount'] ?? '0.0') ?? 0.0;

          // Update tabungAmount based on withdrawal or reload
          double updatedTabungAmount = isWithdrawal
              ? currentTabungAmount - amount
              : currentTabungAmount + amount;

          // Convert updatedTabungAmount back to string
          String updatedTabungAmountString =
              updatedTabungAmount.toStringAsFixed(2);

          Map<String, dynamic> newTabungAmount = {
            'tabungAmount': updatedTabungAmountString
          };
          await documentReference.update(newTabungAmount);
          print('Tabung updated successfully');
        } else {
          print('Data is null for user with id $id');
        }
      } else {
        print('Document does not exist for user with id $id');
      }
    } catch (e) {
      print('Error updating tabungAmount: $e');
    }
  }

  Future<void> updateBalance(
      String id, double amount, bool isWithdrawal) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(id);

    try {
      final DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          double currentBalance = (data['balance'] ?? 0).toDouble();

          double updatedBalance =
              isWithdrawal ? currentBalance - amount : currentBalance + amount;

          Map<String, dynamic> newBalance = {'balance': updatedBalance};
          await documentReference.update(newBalance);
        } else {
          print('Data is null for user with id $id');
        }
      } else {
        print('Document does not exist for user with id $id');
      }
    } catch (e) {
      print('Error updating balance: $e');
    }
  }

  Future<void> updateCurrentAmount(
      String id, double amount, String category, String title) async {
    try {
      final CollectionReference goalCollection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals");

      final QuerySnapshot querySnapshot = await goalCollection
          .where("category", isEqualTo: category)
          .where("title", isEqualTo: title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        DocumentReference documentReference = document.reference;

        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        double currentAmount = (data['currentAmount'] ?? 0).toDouble();
        double updatedAmount = currentAmount + amount;

        Map<String, dynamic> newAmount = {'currentAmount': updatedAmount};
        await documentReference.update(newAmount);
        print('Amount updated successfully');
      } else {
        print(
            'Document does not exist for user with id $id, category $category, and title $title');
        // You might want to throw an exception or provide feedback to the user
        throw Exception('Document not found');
      }
    } catch (e) {
      print('Error updating currentAmount: $e');
      // Handle the error or provide feedback to the user
      throw Exception('Error updating amount: $e');
    }
  }

  Future updateStatusGoal(String id, String category, String title) async {
    final CollectionReference goalCollection = FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .collection("goals");

    final QuerySnapshot querySnapshot = await goalCollection
        .where("category", isEqualTo: category)
        .where("title", isEqualTo: title)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot document = querySnapshot.docs.first;
      DocumentReference documentReference = document.reference;

      Map<String, dynamic> newStatus = {'status': 'Completed'};
      await documentReference.update(newStatus);
      print('Amount updated successfully');
    } else {
      print(
          'Document does not exist for user with id $id, category $category, and title $title');
      throw Exception('Document not found');
    }
  }

  Future<void> deleteGoal(String id, String category, String title) async {
    try {
      final CollectionReference goalCollection = FirebaseFirestore.instance
          .collection("user")
          .doc(id)
          .collection("goals");

      final QuerySnapshot querySnapshot = await goalCollection
          .where("category", isEqualTo: category)
          .where("title", isEqualTo: title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot document = querySnapshot.docs.first;
        if (document.exists) {
          await document.reference.delete();
          print("Goal deleted successfully");
        } else {
          print("Goal does not exist");
        }
      } else {
        print("No matching goals found");
      }
    } catch (e) {
      print("Error deleting goal: $e");
    }
  }
}
