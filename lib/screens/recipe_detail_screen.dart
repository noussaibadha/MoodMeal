import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recette;

  const RecipeDetailScreen({super.key, required this.recette});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  String selectedTab = 'Ingrédients';

  @override
  Widget build(BuildContext context) {
    final recette = widget.recette;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Image + Infos en haut
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFBEE7FF),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
             padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 40),

              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        recette['image_url'],
                        height: 220,
                        width: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _infoBox(Icons.person, "${recette['nb_personne']}", fixedWidth: true),
                        const SizedBox(height: 12),
                        _infoBox(Icons.local_fire_department, "${recette['calories']}kcal", fixedWidth: true),
                        const SizedBox(height: 12),
                        _infoBox(Icons.favorite, "${recette['likes']}", fixedWidth: true),
                        const SizedBox(height: 12),
                        _infoBox(Icons.timer, recette['temps'] != null ? "${recette['temps']}mn" : "--", fixedWidth: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recette['nom'] ?? '',
                style: GoogleFonts.josefinSans(fontSize: 22, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabButton('Ustensiles'),
                  _tabButton('Ingrédients'),
                  _tabButton('Recettes'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView(
                  children: _buildContentForTab(recette),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(IconData icon, String label, {bool fixedWidth = false}) {
    return Container(
      width: fixedWidth ? 100 : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.josefinSans(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _tabButton(String label) {
    final isSelected = label == selectedTab;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBEE7FF) : const Color(0xFFD6EDFF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(label,
            style: GoogleFonts.josefinSans(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            )),
      ),
    );
  }

  List<Widget> _buildContentForTab(Map<String, dynamic> recette) {
    switch (selectedTab) {
      case 'Ustensiles':
        return List<String>.from(recette['ustensiles'] ?? []).map((item) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("• $item", style: GoogleFonts.josefinSans(fontSize: 14)),
          )).toList();

      case 'Recettes':
        return List<String>.from(recette['instructions'] ?? []).asMap().entries.map((entry) =>
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text("Étape ${entry.key + 1} : ${entry.value}", style: GoogleFonts.josefinSans(fontSize: 14)),
          )).toList();

      case 'Ingrédients':
      default:
        return List<String>.from(recette['ingredients'] ?? []).map((item) => _checkItem(item)).toList();
    }
  }


  Widget _checkItem(String text) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool isChecked = false;
      return Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
          Expanded(
            child: Text(text, style: GoogleFonts.josefinSans(fontSize: 14)),
          ),
        ],
      );
    },
  );
}

}