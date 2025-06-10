import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _civilite = 'M.';
  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final numeroController = TextEditingController();
  final passwordController = TextEditingController();

  void _signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final authResponse = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user != null) {
        await Supabase.instance.client.from('users').insert({
          'id': user.id,
          'civilite': _civilite,
          'prenom': prenomController.text.trim(),
          'nom': nomController.text.trim(),
          'numero': numeroController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("\u2709\ufe0f Un email de confirmation t’a été envoyé. Vérifie ta boîte mail."),
            duration: Duration(seconds: 5),
          ),
        );

        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showError("Inscription échouée.");
      }
    } catch (e) {
      _showError("Erreur : \${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        children: [
          const SizedBox(height: 10),

          // 👉 Logo
          Image.asset('assets/logo.png', height: 320),
          const SizedBox(height: 24),

          // 👉 Titre
          Text(
            "Inscription",
            style: GoogleFonts.josefinSans(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // 👉 Choix civilité
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['M.', 'Mme.', 'Autre'].map((val) {
              return Row(
                children: [
                  Radio<String>(
                    value: val,
                    groupValue: _civilite,
                    onChanged: (value) {
                      setState(() {
                        _civilite = value!;
                      });
                    },
                  ),
                  Text(val),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // 👉 Champ prénom
          SizedBox(
            height: 41,
            child: TextField(
              controller: prenomController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                labelText: 'Prénom',
                labelStyle: const TextStyle(color: Color(0xFFB2B2B2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(33),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 👉 Champ nom
          SizedBox(
            height: 41,
            child: TextField(
              controller: nomController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                labelText: 'Nom',
                labelStyle: const TextStyle(color: Color(0xFFB2B2B2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(33),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 👉 Champ email
          SizedBox(
            height: 41,
            child: TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                labelText: 'Adresse e-mail',
                labelStyle: const TextStyle(color: Color(0xFFB2B2B2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(33),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 👉 Champ téléphone
          SizedBox(
            height: 41,
            child: TextField(
              controller: numeroController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                labelText: 'Numéro',
                labelStyle: const TextStyle(color: Color(0xFFB2B2B2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(33),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 👉 Champ mot de passe
          SizedBox(
            height: 41,
            child: TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                labelText: 'Mot de passe',
                labelStyle: const TextStyle(color: Color(0xFFB2B2B2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(33),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // 👉 Bouton S’inscrire
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF8A588),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _signup,
            child: const Text("S’inscrire", style: TextStyle(fontSize: 30)),
          ),

          const SizedBox(height: 30),

          // 👉 Lien Connexion
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.josefinSans(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: "Vous avez déjà un compte ? "),
                    TextSpan(
                      text: "Connexion",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
