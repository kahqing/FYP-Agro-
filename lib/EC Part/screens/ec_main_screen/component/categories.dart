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
              "https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fclothes-rack.png?alt=media&token=5b776595-89e4-489e-ad44-442ded04b925&_gl=1*x26j28*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODkxMTkyNy40MS4xLjE2OTg5MTIyNjcuNjAuMC4w",
          "text": "Clothing",
          "category": "Clothing"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fpc.png?alt=media&token=cc46d262-5c56-41f9-a102-5b97c8088736&_gl=1*1ff45c6*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODkxMTkyNy40MS4xLjE2OTg5MTIzMDkuMTguMC4w",
          "text": "Computer and Tech",
          "category": "Computer and Tech"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fgranola.png?alt=media&token=021ba9e6-344a-4feb-9f34-4b8f7b4db36c&_gl=1*1w5tc3r*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODkxMTkyNy40MS4xLjE2OTg5MTIyODMuNDQuMC4w",
          "text": "Food and Drinks",
          "category": "Food and Drinks"
        },
      ],
      categoriesRow2: const [
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fbook.png?alt=media&token=284bd19b-b076-4fba-beb2-aa3f50c7249e&_gl=1*1r5kz56*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODk5ODc0MC40Ny4xLjE2OTg5OTk4MjMuMzMuMC4w",
          "text": "Books",
          "category": "Books"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Finterior-design.png?alt=media&token=c78f48f1-ce7c-4617-8043-63f665231e0c&_gl=1*13owfje*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODkxMTkyNy40MS4xLjE2OTg5MTI1NTUuNy4wLjA.",
          "text": "Furniture",
          "category": "Furniture"
        },
        {
          "icon":
              "https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fothers.png?alt=media&token=4ae4a65b-c5fd-4b55-a425-99e1e065ed53&_gl=1*pe762r*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODk5ODc0MC40Ny4xLjE2OTg5OTk4MDIuNTQuMC4w",
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
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            SizedBox(height: 15), // Add spacing between rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      child: Container(
        width: 120, // Adjust the width of category card
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20), // Adjust for the icon
              height: 80, // Adjust for the icon
              width: 80,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 97, 97),
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
