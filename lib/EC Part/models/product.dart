import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;
  final bool isFixedPrice;

  final DocumentReference sellerRef;

  Map<String, dynamic>? sellerData;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.isFixedPrice,
    required this.sellerRef,
    this.sellerData,
  });

  //factory method to take DocumentSnapshot and convert to object
  factory Product.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final id = doc.id;
    final sellerRef = data['sellerRef'] as DocumentReference;
    return Product(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      image: data['image'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      isFixedPrice: data['isFixedPrice'] ?? true,
      sellerRef: sellerRef,
    );
  }

  // Factory constructor to create a Product from a map
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    final sellerRef = map['sellerRef'] as DocumentReference;
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: (map['category'] ?? ''),
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      isFixedPrice: map['isFixedPrice'] ?? true,
      sellerRef: sellerRef,
    );
  }

//method to fetch user Data from firebase and set the user data
  Future<void> fetchUserData() async {
    final sellerDoc = await sellerRef.get();
    if (sellerDoc.exists) {
      sellerData = sellerDoc.data() as Map<String, dynamic>;
    }
  }
}
