//import 'package:agro_app/screens/product_listing/listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/category_listing_screen.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryRows(
      categoriesRow1: const [
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/agroplus-app.appspot.com/o/icons%2Fclothing.png?alt=media&token=3d76b293-6ec0-400c-9a82-852bedac206d",
          "text": "Clothing and Accessories",
          "category": "Clothing and Accessories"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/agroplus-app.appspot.com/o/icons%2Fgadgets.png?alt=media&token=5c717525-2798-4468-9636-cef440060161",
          "text": "Digital Products",
          "category": "Digital Products"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/agroplus-app.appspot.com/o/icons%2Felectronics.png?alt=media&token=3f610e72-0e19-456b-811e-ba7147e20b29",
          "text": "Electronics",
          "category": "Electronics"
        },
      ],
      categoriesRow2: const [
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/agroplus-app.appspot.com/o/icons%2Fbook.png?alt=media&token=c6bb9823-1dfa-4e9b-86ac-e9f443e046c2",
          "text": "Books",
          "category": "Books"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/agroplus-app.appspot.com/o/icons%2Ffurnitures.png?alt=media&token=1ff1ecb6-91cd-4272-9184-358537c99fcc",
          "text": "Furniture",
          "category": "Furniture"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/agroplus-app.appspot.com/o/icons%2Fothers.png?alt=media&token=a55e048b-f74e-4be2-aa8e-e3a03a2f157c",
          "text": "Others",
          "category": "Others"
        },
      ],
    );
  }
}

class CategoryRows extends StatelessWidget {
  final List<Map<String, dynamic>> categoriesRow1;
  final List<Map<String, dynamic>> categoriesRow2;

  CategoryRows({
    required this.categoriesRow1,
    required this.categoriesRow2,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              categoriesRow1.length,
              (index) => CategoryCard(
                icon: categoriesRow1[index]["icon"],
                text: categoriesRow1[index]["text"],
                categoryName: categoriesRow1[index]["category"],
              ),
            ),
          ),
          const SizedBox(height: 15), // Add spacing between rows
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              categoriesRow2.length,
              (index) => CategoryCard(
                icon: categoriesRow2[index]["icon"],
                text: categoriesRow2[index]["text"],
                categoryName: categoriesRow2[index]["category"],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.categoryName,
  }) : super(key: key);

  final String? icon, text, categoryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          CategoryProductsScreen.routeName,
          arguments: {'categoryName': categoryName},
        );
      },
      child: SizedBox(
        width: 120, // Adjust the width of category card
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20), // Adjust for the icon
              height: 80, // Adjust for the icon
              width: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 239, 97, 97),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.network(
                icon!,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 10),
            Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
