// ✅ lib/services/course_item_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseItemService {
  static final _client = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getItems(String categorie) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('course_items')
        .select()
        .eq('user_id', userId)
        .eq('categorie', categorie)
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addItem(String categorie, String nom) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('course_items').insert({
      'user_id': userId,
      'categorie': categorie,
      'nom': nom,
      'checked': false,
    });
  }

  static Future<void> deleteItem(String id) async {
    await _client.from('course_items').delete().eq('id', id);
  }

  static Future<void> toggleCheck(String id, bool checked) async {
    await _client
        .from('course_items')
        .update({'checked': checked})
        .eq('id', id);
  }
}
