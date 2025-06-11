import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'recipe_detail_screen.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> recettesFavoris = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavoris();
  }

  Future<void> loadFavoris() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final favorisResponse = await supabase
        .from('user_favoris')
        .select('recette_id')
        .eq('user_id', user.id);

    final ids = List<String>.from(favorisResponse.map((e) => e['recette_id']));

    if (ids.isEmpty) {
      setState(() {
        recettesFavoris = [];
        isLoading = false;
      });
      return;
    }

    final recettesResponse = await supabase
        .from('recettes')
        .select()
        .in_('id', ids);

    setState(() {
      recettesFavoris = List<Map<String, dynamic>>.from(recettesResponse);
      isLoading = false;
    });
  }

  Future<void> removeFavori(String recetteId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('user_favoris').delete().match({
      'user_id': user.id,
      'recette_id': recetteId,
    });

    setState(() {
      recettesFavoris.removeWhere((r) => r['id'] == recetteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Les plats enregistrés"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : recettesFavoris.isEmpty
              ? const Center(child: Text("Aucune recette enregistrée 😢"))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: recettesFavoris.length,
                itemBuilder: (context, index) {
                  final recette = recettesFavoris[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getColorByIndex(index),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            recette['image_url'],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, _, __) =>
                                    const Icon(Icons.broken_image, size: 70),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recette['nom'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Prêt en ${recette['temps']} min • ${recette['calories']} kcal",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => removeFavori(recette['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  Color _getColorByIndex(int index) {
    final colors = [
      const Color(0xFFB0D9FF),
      const Color(0xFFFFD3D3),
      const Color(0xFFFFBFA7),
      const Color(0xFFD3FBC7),
      const Color(0xFFA7E9D2),
    ];
    return colors[index % colors.length];
  }
}
