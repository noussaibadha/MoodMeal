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
        .in_('id', ids); // ✅ corrigé ici aussi

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
      appBar: AppBar(title: const Text("Mes favoris")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : recettesFavoris.isEmpty
              ? const Center(child: Text("Aucune recette enregistrée 😢"))
              : ListView.builder(
                itemCount: recettesFavoris.length,
                itemBuilder: (context, index) {
                  final recette = recettesFavoris[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(recette: recette),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Image.network(
                        recette['image_url'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(recette['nom']),
                      subtitle: Text(
                        "${recette['temps']} min • ${recette['calories']} kcal",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => removeFavori(recette['id']),
                        tooltip: "Retirer des favoris",
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
