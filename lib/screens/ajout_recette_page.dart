import 'package:flutter/material.dart';
import '../models/recette_model.dart';
import '../services/recette_service.dart';

class AjoutRecettePage extends StatefulWidget {
  const AjoutRecettePage({super.key});

  @override
  State<AjoutRecettePage> createState() => _AjoutRecettePageState();
}

class _AjoutRecettePageState extends State<AjoutRecettePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomCtrl = TextEditingController();
  final TextEditingController imageUrlCtrl = TextEditingController();
  final TextEditingController origineCtrl = TextEditingController();
  final TextEditingController caloriesCtrl = TextEditingController();
  final TextEditingController tempsCtrl = TextEditingController();
  final TextEditingController nbPersonneCtrl = TextEditingController();
  final TextEditingController ingredientsCtrl = TextEditingController(); // séparés par virgule
  final TextEditingController ustensilesCtrl = TextEditingController(); // séparés par virgule
  final TextEditingController instructionsCtrl = TextEditingController();
  final TextEditingController categorieCtrl = TextEditingController();
  final TextEditingController humeurCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController tagsCtrl = TextEditingController();
    


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouvelle recette")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              champ("Nom", nomCtrl),
              champ("Image URL", imageUrlCtrl),
              champ("Origine", origineCtrl),
              champ("Nombre de personnes", nbPersonneCtrl, isNumber: true),
              champ("Calories", caloriesCtrl, isNumber: true),
              champ("Temps (minutes)", tempsCtrl, isNumber: true),
              champ("Catégorie", categorieCtrl),
              champ("Ingrédients (séparés par ,)", ingredientsCtrl),
              champ("Ustensiles (séparés par ,)", ustensilesCtrl),
              champ("Humeur", humeurCtrl),
              champ("Description", descriptionCtrl),
              champ("Tags (ex: végétarien, sans gluten)", tagsCtrl),
              champ("Instructions", instructionsCtrl, maxLines: 4),
              

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final recette = Recette(
                      nom: nomCtrl.text,
                      imageUrl: imageUrlCtrl.text,
                      origine: origineCtrl.text,
                      nbPersonne: int.tryParse(nbPersonneCtrl.text) ?? 1,
                      calories: int.tryParse(caloriesCtrl.text) ?? 0,
                      temps: int.tryParse(tempsCtrl.text) ?? 0,
                      categorieTab: categorieCtrl.text,
                      ingredients: ingredientsCtrl.text.split(',').map((e) => e.trim()).toList(),
                      ustensiles: ustensilesCtrl.text.split(',').map((e) => e.trim()).toList(),
                      humeur: humeurCtrl.text,
                      description: descriptionCtrl.text,
                      tags: tagsCtrl.text.split(',').map((e) => e.trim()).toList(),
                      instructions: instructionsCtrl.text,
                      
                    );

                    await ajouterRecette(recette);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recette ajoutée ! ✅')),
                    );

                    _formKey.currentState!.reset();
                    nomCtrl.clear();
                    imageUrlCtrl.clear();
                    origineCtrl.clear();
                    caloriesCtrl.clear();
                    tempsCtrl.clear();
                    nbPersonneCtrl.clear();
                    ingredientsCtrl.clear();
                    ustensilesCtrl.clear();
                    instructionsCtrl.clear();
                    categorieCtrl.clear();
                    humeurCtrl.clear();
                    descriptionCtrl.clear();
                    tagsCtrl.clear();




                  }
                },
                child: const Text("Ajouter la recette"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget champ(String label, TextEditingController ctrl, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est requis';
          }
          return null;
        },
      ),
    );
  }
}
