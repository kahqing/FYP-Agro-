import 'dart:io';

import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_upload/form_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductUploadScreen extends StatefulWidget {
  static String routeName = '/upload_product';
  final String sellerUserId;
  ProductUploadScreen({required this.sellerUserId});

  @override
  State<ProductUploadScreen> createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  late final formHandler =
      FormHandler(ProductProvider(matric: widget.sellerUserId));

  //function/logic to handle the form submission
  void submitForm() async {
    final bool uploadStatus =
        await formHandler.submitForm(context, widget.sellerUserId);

    //if product is added successfully
    if (uploadStatus) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product is added successfully.'),
        ),
      );
      //navigate back to seller dashboard
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form data is not valid.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text('Upload Product'),
      ),
      bottomNavigationBar: uploadProductButton(),
      body: formHandler.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  _buildTextField(
                    labelText: 'Product Name',
                    onChanged: (value) {
                      setState(() {
                        formHandler.productName = value;
                      });
                    },
                  ),
                  _buildTextField(
                    labelText: 'Product Description',
                    onChanged: (value) {
                      setState(() {
                        formHandler.productDescription = value;
                      });
                    },
                    maxLines: 4,
                  ),
                  _buildSellingTypeRadioButton(),
                  const SizedBox(height: 10),
                  formHandler.productType == ProductType.auction
                      ? _buildDateTimeWidget()
                      : const SizedBox.shrink(),
                  _buildTextField(
                    labelText: 'Product Price',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        formHandler.price = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  _buildDropDownMenuCategory(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Color of the border
                        width: 1.0, // Width of the border
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: formHandler.image != null
                        ? Image.file(formHandler.image!)
                        : Center(
                            child: ElevatedButton(
                              onPressed: showImagePickerDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 182, 182),
                                elevation: 3,
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(30.0),
                                // ),
                              ),
                              child: const Text(
                                'Upload Product Image',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                  )
                ]),
              ),
            ),
    );
  }

  Future<void> showImagePickerDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Image Source'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  pickImage();
                  Navigator.pop(context);
                },
                child: const Text('Pick image from gallery'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  captureImage();
                  Navigator.pop(context);
                },
                child: const Text('Capture image using camera'),
              ),
            ],
          );
        });
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected'),
        ),
      );
      return;
    }
    final selectedImage = File(image.path);

    setState(() => formHandler.image = selectedImage);
  }

  Future<void> captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected'),
        ),
      );
      return;
    }
    final selectedImage = File(image.path);
    setState(() => formHandler.image = selectedImage);
  }

  Widget _buildTextField({
    required String labelText,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownMenuCategory() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      height: 62,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: formHandler.category,
              onChanged: (String? newValue) {
                setState(() {
                  formHandler.category = newValue!;
                });
              },
              items: <String>[
                'Clothing',
                'Computer and Tech',
                'Furniture',
                'Food and Drinks',
                'Books',
                'Others',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeWidget() {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: _buildDateTimePicker(
        labelText: 'Select Auction End Date',
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        onDateChanged: (DateTime date) {
          setState(() {
            selectedDate = date;
          });
        },
        onTimeChanged: (TimeOfDay time) {
          setState(() {
            selectedTime = time;
          });
          formHandler.endTime = selectedDate.add(
            Duration(
              hours: selectedTime.hour,
              minutes: selectedTime.minute,
            ),
          );
        },
      ),
    );
  }

  //Method to show the auction details dialog
  Future<void> showAuctionDialog() async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Auction Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildDateTimePicker(
                labelText: 'Select Date and Time',
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onDateChanged: (DateTime date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                onTimeChanged: (TimeOfDay time) {
                  setState(() {
                    selectedTime = time;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add any validation logic here if needed
                formHandler.endTime = selectedDate.add(
                  Duration(
                    hours: selectedTime.hour,
                    minutes: selectedTime.minute,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build date and time picker
  Widget _buildDateTimePicker({
    required String labelText,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required Function(DateTime) onDateChanged,
    required Function(TimeOfDay) onTimeChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null && pickedDate != selectedDate) {
              onDateChanged(pickedDate);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.date_range),
                const SizedBox(width: 10),
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );

            if (pickedTime != null && pickedTime != selectedTime) {
              onTimeChanged(pickedTime);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Select Auction End Time',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(
                  selectedTime.format(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellingTypeRadioButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Selling Type',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ),
          Container(
            height: 30,
            width: 300,
            child: ListTile(
              title: const Text('Fixed Price'),
              contentPadding: EdgeInsets.zero,
              leading: Radio<bool>(
                  value: true,
                  groupValue: formHandler.productType == ProductType.fixedPrice,
                  onChanged: (bool? value) {
                    setState(
                      () {
                        formHandler.productType = ProductType.fixedPrice;
                      },
                    );
                  }),
            ),
          ),
          Container(
            height: 30,
            width: 300,
            child: ListTile(
              title: const Text('Auction'),
              contentPadding: EdgeInsets.zero,
              leading: Radio<bool>(
                  value: false,
                  groupValue: formHandler.productType == ProductType.fixedPrice,
                  onChanged: (bool? value) {
                    setState(
                      () {
                        formHandler.productType = ProductType.auction;
                        //showAuctionDialog();
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadProductButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: submitForm,
        style: ElevatedButton.styleFrom(
            //fixedSize: const Size(300, 50),
            backgroundColor: const Color.fromARGB(255, 197, 0, 0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
        child: const Text(
          'Upload New Product',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
