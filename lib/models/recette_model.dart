class Recette {
  final String nom;
  final String? imageUrl;
  final int nbPersonne;
  final int calories;
  final int temps;
  final int likes;
  final List<String> ingredients;
  final List<String> ustensiles;
  final String instructions;
  final String? categorieTab;
  final String? origine;
  final String? humeur;
  final String? description;
  final List<String>? tags;

  


  Recette({
    required this.nom,
    this.imageUrl,
    required this.nbPersonne,
    required this.calories,
    required this.temps,
    this.likes = 0,
    required this.ingredients,
    required this.ustensiles,
    required this.instructions,
    this.categorieTab,
    this.origine,
    this.humeur,
    this.description,
    this.tags,


  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'image_url': imageUrl,
      'nb_personne': nbPersonne,
      'calories': calories,
      'temps': temps,
      'likes': likes,
      'ingredients': ingredients,
      'ustensiles': ustensiles,
      'instructions': instructions,
      'categorie_tab': categorieTab,
      'origine': origine,
      'humeur': humeur,
      'description': description,
      'tags': tags,


    };
  }
}
