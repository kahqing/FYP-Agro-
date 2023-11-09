class Cart {
  final String productId;
  final String productName;
  final double price;
  final String image;
  int numOfItem;

  Cart({
    required this.productId,
    required this.productName,
    required this.price,
    required this.image,
    this.numOfItem = 1,
  });

  // //convert the cart obj into Map to pass arg to method in CartProvider
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'numOfItem': numOfItem,
      'price': price,
    };
  }
}

// class Cart {
//   final String productId;
//   final Product product;
//   int numOfItem;

//   Cart({
//     required this.productId,
//     required this.product,
//     this.numOfItem = 1,
//   });


// }
