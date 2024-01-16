class CartItem {
  final String productId;
  final String productName;
  final String sellerId;
  final double price;
  final String image;
  int numOfItem;

  CartItem({
    required this.productId,
    required this.productName,
    required this.sellerId,
    required this.price,
    required this.image,
    this.numOfItem = 1,
  });

  // //convert the cart item into Map to pass arg to method in CartProvider
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'sellerId': sellerId,
      'numOfItem': numOfItem,
      'price': price,
      'image': image,
    };
  }
}
