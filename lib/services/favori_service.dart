import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriService {
  static final _client = Supabase.instance.client;

  static Future<void> likeRecette(String userId, String recetteId) async {
    await _client.from('user_favoris').insert({
      'user_id': userId,
      'recette_id': recetteId,
    });
  }

  static Future<void> unlikeRecette(String userId, String recetteId) async {
    await _client.from('user_favoris').delete().match({
      'user_id': userId,
      'recette_id': recetteId,
    });
  }

  static Future<List<String>> getFavorisIds(String userId) async {
    final response = await _client
        .from('user_favoris')
        .select('recette_id')
        .eq('user_id', userId);

    return List<String>.from(response.map((e) => e['recette_id']));
  }
}
