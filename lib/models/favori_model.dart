class Favori {
  final String userId;
  final String recetteId;

  Favori({required this.userId, required this.recetteId});

  Map<String, dynamic> toMap() => {'user_id': userId, 'recette_id': recetteId};

  static Favori fromMap(Map<String, dynamic> map) =>
      Favori(userId: map['user_id'], recetteId: map['recette_id']);
}
