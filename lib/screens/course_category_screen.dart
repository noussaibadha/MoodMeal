import 'package:flutter/material.dart';
import 'course_item_screen.dart';

class CourseCategoryScreen extends StatelessWidget {
  const CourseCategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'label': 'Fruits & Légumes', 'emoji': '🍏🥦', 'color': Color(0xFF9DE7D7)},
    {'label': 'Produits laitiers', 'emoji': '🧀🥛', 'color': Color(0xFFFFF7D4)},
    {
      'label': 'Viandes & poissons',
      'emoji': '🍗🐟',
      'color': Color(0xFFFFC5B3),
    },
    {'label': 'Pain & Féculents', 'emoji': '🥐🍞', 'color': Color(0xFFFFE099)},
    {
      'label': 'Épices & Assaisonnements',
      'emoji': '🧂🍋',
      'color': Color(0xFFD8B4F8),
    },
    {'label': 'Boissons', 'emoji': '🧃🥤', 'color': Color(0xFFFFDADA)},
    {
      'label': 'Hygiène / Entretien',
      'emoji': '🧼🧽',
      'color': Color(0xFFB2E4FF),
    },
    {'label': 'Autres', 'emoji': '🛒✨', 'color': Color(0xFFEAEAEA)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Liste de course',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.separated(
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CourseItemScreen(category: category['label']),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: category['color'],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Text(
                      category['emoji'],
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        category['label'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
