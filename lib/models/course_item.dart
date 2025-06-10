class CourseItem {
  final String id;
  final String userId;
  final String categorie;
  final String nom;
  final bool checked;
  final DateTime createdAt;

  CourseItem({
    required this.id,
    required this.userId,
    required this.categorie,
    required this.nom,
    required this.checked,
    required this.createdAt,
  });

  factory CourseItem.fromMap(Map<String, dynamic> map) {
    return CourseItem(
      id: map['id'],
      userId: map['user_id'],
      categorie: map['categorie'],
      nom: map['nom'],
      checked: map['checked'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'categorie': categorie,
      'nom': nom,
      'checked': checked,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
