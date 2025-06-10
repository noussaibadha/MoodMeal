import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 👉 Fonction de connexion
  void _login() async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showError("Identifiants incorrects.");
      }
    } on AuthException catch (e) {
      if (e.message.contains('Email not confirmed')) {
        _showError("⚠️ Tu dois confirmer ton email avant de te connecter.");
      } else {
        _showError("Erreur : ${e.message}");
      }
    } catch (e) {
      _showError("Erreur inattendue : ${e.toString()}");
    }
  }

  // 👉 Affichage d'une erreur en bas de l’écran
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),

        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          children: [
              const SizedBox(height: 10), // facultatif pour laisser un mini espace
              Image.asset('assets/logo.png', height: 320),
              const SizedBox(height: 24),

              // 👉 Titre "Connexion"
              Text(
                "Connexion",
                style: GoogleFonts.josefinSans(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 42),

              // 👉 Champ Adresse e-mail
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ⬅️ padding intérieur
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(33),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 16),

              // 👉 Champ Mot de passe
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

              // 👉 Bouton "Se connecter"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8A588),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _login,
                child: const Text("Se connecter", style: TextStyle(fontSize: 30)),
              ),

              const SizedBox(height: 30),

              // 👉 Lien "Tu n’as pas de compte ? Inscription"
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.josefinSans(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: "Tu n’as pas de compte ? "),
                        TextSpan(
                          text: "Inscription",
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
        ),
      
    );
  }
}
