import 'dart:io';
import 'package:agro_plus_app/EC%20Part/models/auction.dart';
import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_upload/form_handler.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_menu.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/upload_product';
  final String sellerId;
  final Product? product;
  final Auction? auction;

  const EditProductScreen({
    required this.sellerId,
    this.product,
    this.auction,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  DateTime datepicked = DateTime.now();
  TimeOfDay timepicked = TimeOfDay.now();
  TextEditingController productNameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  late final formHandler =
      FormHandler(ProductProvider(sellerId: widget.sellerId), isEditMode: true);

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      productNameController.text = widget.product!.name;
      productDescriptionController.text = widget.product!.description;
      priceController.text = widget.product!.price.toString();

      formHandler.productId = widget.product!.id;
      formHandler.productName = widget.product!.name;
      formHandler.brand = widget.product!.brand;
      formHandler.model = widget.product!.model;
      formHandler.productDescription = widget.product!.description;
      formHandler.productType = widget.product!.isFixedPrice
          ? ProductType.fixedPrice
          : ProductType.auction;
      formHandler.category = widget.product!.category;
      formHandler.price = widget.product!.price;
      formHandler.imgURL = widget.product!.image;
      if (!widget.product!.isFixedPrice) {
        formHandler.endTime = widget.auction!.endTime;
        datepicked = formHandler.endTime;
        timepicked = TimeOfDay.fromDateTime(datepicked);
        formHandler.auctionId = widget.auction!.auctionId;
      }
    }
  }

  //function/logic to handle the form submission
  void submitForm() async {
    print('edit button is clicked');
    final bool editStatus =
        await formHandler.submitForm(context, widget.sellerId);

    //if product is added successfully
    if (editStatus) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product is edited successfully.'),
        ),
      );
      //navigate back to seller menu
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
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 56, 38, 106),
        elevation: 5,
        title: const Text(
          'Edit Product',
          style: TextStyle(color: Colors.white),
        ),
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '* All the field are required except brand and model',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildTextField(
                    labelText: 'Product Name',
                    onChanged: (value) {
                      setState(() {
                        formHandler.productName = value;
                      });
                    },
                    controller: productNameController,
                    enabled: true,
                  ),
                  _buildTextField(
                    labelText: 'Brand (optional)',
                    onChanged: (value) {
                      setState(() {
                        formHandler.brand = value;
                      });
                    },
                    controller: brandController,
                    enabled: true,
                  ),
                  _buildTextField(
                    labelText: 'Model (optional)',
                    onChanged: (value) {
                      setState(() {
                        formHandler.model = value;
                      });
                    },
                    controller: modelController,
                    enabled: true,
                  ),
                  _buildTextField(
                    labelText: 'Product Description',
                    onChanged: (value) {
                      setState(() {
                        formHandler.productDescription = value;
                      });
                    },
                    maxLines: 4,
                    controller: productDescriptionController,
                    enabled: true,
                  ),
                  _buildSellingTypeRadioButton(),
                  const SizedBox(height: 10),
                  formHandler.productType == ProductType.auction
                      ? _buildDateTimeWidget(context)
                      : const SizedBox.shrink(),
                  _buildTextField(
                    labelText: formHandler.productType == ProductType.fixedPrice
                        ? "Product Price (RM)"
                        : "Starting Price (RM)",
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        formHandler.price = double.tryParse(value) ?? 0.0;
                      });
                    },
                    controller: priceController,
                    enabled: true,
                  ),
                  _buildDropDownMenuCategory(),
                  Container(
                    margin:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 15),
                    //height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Color of the border
                        width: 1.0, // Width of the border
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display the current image
                        if (formHandler.image != null)
                          Image.file(formHandler.image!),
                        if (formHandler.image == null &&
                            formHandler.imgURL != null)
                          Image.network(
                            formHandler.imgURL!,
                            //height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),

                        // Provide a button to upload a new image
                        ElevatedButton(
                          onPressed: showImagePickerDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(243, 155, 198, 255),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Upload Product Image',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        enabled: enabled, //enable/disable to change the field
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
      margin: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 15),
      height: 62,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Choose Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: formHandler.category ?? 'Clothing and Accessories',
              onChanged: (String? newValue) {
                setState(() {
                  formHandler.category = newValue!;
                });
              },
              items: <String>[
                'Clothing and Accessories',
                'Digital Products',
                'Electronics',
                'Furniture',
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
      margin: const EdgeInsets.only(right: 10, left: 10),
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 133, 125, 125),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Selling Type',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            width: 300,
            child: ListTile(
              title: const Text('Fixed Price'),
              contentPadding: EdgeInsets.zero,
              leading: Radio<bool>(
                  // fillColor: MaterialStateColor.resolveWith(
                  //     (states) => Colors.redAccent),
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
          SizedBox(
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
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeWidget(BuildContext context) {
    DateTime endTime = formHandler.endTime;
    print('End Time: $endTime');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final date = await pickDate();
                  if (date == null) return;

                  setState(() {
                    datepicked = date;
                    formHandler.endTime = datepicked.add(
                      Duration(
                        hours: timepicked.hour,
                        minutes: timepicked.minute,
                      ),
                    );
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Enter End Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range),
                      const SizedBox(width: 10),
                      Text(
                        '${datepicked.year}/${datepicked.month}/${datepicked.day}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  final time = await pickTime();
                  if (time == null) return;

                  setState(() {
                    timepicked = time;
                    formHandler.endTime = datepicked.add(
                      Duration(
                        hours: timepicked.hour,
                        minutes: timepicked.minute,
                      ),
                    );
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Enter End Time",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 10),
                      Text(
                        timepicked.format(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Date and time retrieved from firebase and display as initial value
  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: formHandler.endTime,
        firstDate: datepicked,
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(formHandler.endTime));

  Widget uploadProductButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          submitForm();
        },
        style: ElevatedButton.styleFrom(
            //fixedSize: const Size(300, 50),
            backgroundColor: const Color.fromARGB(255, 56, 38, 106),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
        child: const Text(
          'Edit Product',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
