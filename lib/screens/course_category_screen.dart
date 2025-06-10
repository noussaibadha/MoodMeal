import 'package:flutter/material.dart';
import 'course_item_screen.dart'; // ✅ assure-toi que ce fichier existe bien dans /screens

class CourseCategoryScreen extends StatelessWidget {
  const CourseCategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'label': 'Fruits', 'icon': Icons.apple},
    {'label': 'Légumes', 'icon': Icons.eco},
    {'label': 'Produits laitiers', 'icon': Icons.icecream},
    {'label': 'Viande / Poisson', 'icon': Icons.set_meal},
    {'label': 'Épicerie', 'icon': Icons.shopping_basket},
    {'label': 'Boissons', 'icon': Icons.local_drink},
    {'label': 'Hygiène / Entretien', 'icon': Icons.cleaning_services},
    {'label': 'Autres', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma liste de courses'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CourseItemScreen(
                          category: category['label'] as String,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 40,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category['label'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
