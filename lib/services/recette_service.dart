import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recette_model.dart';

Future<void> ajouterRecette(Recette recette) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('recettes').insert(recette.toJson());

  if (response.error != null) {
    print('❌ Erreur Supabase : ${response.error!.message}');
  } else {
    print('✅ Recette ajoutée avec succès');
  }
}
