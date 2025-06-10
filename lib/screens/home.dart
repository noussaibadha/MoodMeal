import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recette_model.dart';
import '../services/recette_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une recette"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final recette = Recette(
              nom: 'Riz crémeux aux champignons & herbes',
              imageUrl: 'https://qumylksbtceqmdndibqx.supabase.co/storage/v1/object/public/recettes-images//riz_cremeux_champignons.png',
              nbPersonne: 2,
              calories: 350,
              temps: 20,
              ingredients: [
                'Riz arborio',
                'Champignons de Paris',
                'Crème légère',
                'Ail',
                'Oignon',
                'Herbes',
                'Huile d’olive',
              ],
              ustensiles: ['Poêle', 'Casserole'],
              instructions: '1. Cuire les oignons\n2. Ajouter le riz...',
              categorieTab: 'plat',
              origine: 'française',
            );

            ajouterRecette(recette);
          },
          child: const Text('Ajouter recette test'),
        ),
      ),
    );
  }
}
