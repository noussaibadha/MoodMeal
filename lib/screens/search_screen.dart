import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> recettes = [];
  List<String> favorisIds = [];
  List<String> recentSearches = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchRecettes();
    fetchFavoris();
  }

  Future<void> fetchRecettes() async {
    final response = await supabase
        .from('recettes')
        .select()
        .order('nom', ascending: true);

    setState(() {
      recettes = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> fetchFavoris() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('user_favoris')
        .select('recette_id')
        .eq('user_id', user.id);

    setState(() {
      favorisIds = List<String>.from(response.map((r) => r['recette_id']));
    });
  }

  Future<void> toggleFavori(String recetteId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final isLiked = favorisIds.contains(recetteId);

    if (isLiked) {
      await supabase.from('user_favoris').delete().match({
        'user_id': user.id,
        'recette_id': recetteId,
      });
      setState(() {
        favorisIds.remove(recetteId);
      });
    } else {
      await supabase.from('user_favoris').insert({
        'user_id': user.id,
        'recette_id': recetteId,
      });
      setState(() {
        favorisIds.add(recetteId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecettes =
        recettes.where((recette) {
          final nom = recette['nom'].toString().toLowerCase();
          return nom.contains(searchText.toLowerCase());
        }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Qu’est-ce qui te ferait plaisir ?",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value.trim();
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    searchText = value.trim();
                  });
                },
              ),
              const SizedBox(height: 30),
              if (recentSearches.isNotEmpty) ...[
                const Text(
                  "Recherche",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children:
                      recentSearches.map((item) {
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            final recette = recettes.firstWhere(
                              (r) =>
                                  r['nom'].toString().toLowerCase() ==
                                  item.toLowerCase(),
                              orElse: () => {},
                            );
                            if (recette.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          RecipeDetailScreen(recette: recette),
                                ),
                              );
                            }
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() {
                                recentSearches.remove(item);
                              });
                            },
                          ),
                        );
                      }).toList(),
                ),
                const Divider(height: 40),
              ],
              const Text(
                "Suggestions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (filteredRecettes.isEmpty)
                const Text("Aucune recette trouvée 😢"),
              ...filteredRecettes.map(_buildSuggestionCard).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> recette) {
    final isLiked = favorisIds.contains(recette['id']);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              recette['image_url'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 60),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () {
                if (!recentSearches.contains(recette['nom'])) {
                  setState(() => recentSearches.add(recette['nom']));
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recette: recette),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recette['nom'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Prêt en ${recette['temps']} min • ${recette['calories']} kcal",
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () => toggleFavori(recette['id']),
          ),
        ],
      ),
    );
  }
}
