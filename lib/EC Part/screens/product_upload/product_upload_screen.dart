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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product is added successfully.'),
        ),
      );
      //navigate back to seller dashboard
      Navigator.pop(context, true);
    } else {
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
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Color of the border
                        width: 1.0, // Width of the border
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: formHandler.image != null
                        ? Image.file(formHandler.image!)
                        : Center(
                            child: ElevatedButton(
                              onPressed: _showSimpleDialog,
                              child: const Text('Upload Product Image'),
                            ),
                          ),
                  )
                ]),
              ),
            ),
    );
  }

  Future<void> _showSimpleDialog() async {
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
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownMenuCategory() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      height: 62,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
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

  Widget _buildSellingTypeRadioButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
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
                style: TextStyle(fontSize: 17, color: Colors.black54),
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
                  groupValue: formHandler.isFixedPrice,
                  onChanged: (bool? value) {
                    setState(
                      () {
                        formHandler.isFixedPrice = true;
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
                  groupValue: formHandler.isFixedPrice,
                  onChanged: (bool? value) {
                    setState(
                      () {
                        formHandler.isFixedPrice = false;
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
            fixedSize: const Size(300, 60),
            primary: Color.fromARGB(255, 253, 131, 129),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
        child: const Text(
          'Upload New Product',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
