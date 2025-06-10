import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recipe_detail_screen.dart'; // adapte le chemin si besoin


class SuggestionsScreen extends StatefulWidget {
  final String humeur;

  const SuggestionsScreen({Key? key, required this.humeur}) : super(key: key);

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  List<Map<String, dynamic>> recettes = [];
  bool isLoading = true;
  int currentIndex = 0;
  String prenom = '';

  @override
  void initState() {
    super.initState();
    fetchRecettes();
  }

  Future<void> fetchRecettes() async {
    final response = await Supabase.instance.client
        .from('recettes')
        .select()
        .eq('humeur', widget.humeur);

    setState(() {
      recettes = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  Future<void> _loadUserPrenom() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final data = await Supabase.instance.client
          .from('users')
          .select('prenom')
          .eq('id', user.id)
          .single();

      setState(() {
        prenom = data['prenom'] ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final recetteActuelle = recettes[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Titre d'intro
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello, ',
                    style: GoogleFonts.josefinSans(
                      fontSize: 20,
                      color: Color(0xFFF8A588),
                    ),
                  ),
                  TextSpan(
                    text: prenom,
                    style: GoogleFonts.josefinSans(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Voici ce qu’on te suggère vu que tu es ',
                    style: GoogleFonts.josefinSans(fontSize: 18),
                  ),
                  TextSpan(
                    text: widget.humeur.toLowerCase(),
                    style: GoogleFonts.josefinSans(
                      fontSize: 18,
                      color: Color(0xFFBEE7FF),
                    ),
                  ),
                  const TextSpan(text: ' :'),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 🟦 Cartes de recettes côte à côte
            SizedBox(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recettes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final recette = entry.value;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: Container(
                        height: 260,
                        width: 205,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBEE7FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Bloc bleu de fond
                            Positioned(
                              top: 130, // Ajuste la hauteur si besoin
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  children: [
                                    Text(
                                      recette['nom'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.josefinSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      recette['description'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.josefinSans(fontSize: 10),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Prêt en ${recette['temps']} min${(recette['tags'] != null && recette['tags'].isNotEmpty) ? ' • ${recette['tags'].join(', ')}' : ''}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.josefinSans(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Image flottante au-dessus
                            Positioned(
                              top: -60,
                              left: (182 - 200) / 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  recette['image_url'],
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🍽️ Bloc ingrédients
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 76, 184, 214),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingrédients :',
                    style: GoogleFonts.josefinSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List<String>.from(recetteActuelle['ingredients'] ?? [])
                      .map(
                        (ingredient) => Text(
                          '• $ingredient',
                          style: GoogleFonts.josefinSans(fontSize: 14),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recette: recetteActuelle),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBEE7FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Voir plus"),
                    )

                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
