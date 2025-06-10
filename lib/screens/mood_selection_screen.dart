import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  String prenom = '';

  final List<Map<String, dynamic>> moods = [
    {
      'label': 'Fatigué·e',
      'image': 'assets/moods/fatigue.png',
      'color': Color(0xFFFFF5CC),
      'size': 150.0,
    },
    {
      'label': 'Stressé·e',
      'image': 'assets/moods/stresse.png',
      'color': Color(0xFFBEE7FF),
      'size': 140.0,
    },
    {
      'label': 'Trop faim',
      'image': 'assets/moods/faim.png',
      'color': Color(0xFFFFD5CC),
      'size': 150.0,
    },
    {
      'label': 'Motivé·e',
      'image': 'assets/moods/motive.png',
      'color': Color(0xFFD3FFE5),
      'size': 137.0,
    },
    {
      'label': 'Triste',
      'image': 'assets/moods/triste.png',
      'color': Color(0xFFE0D2FF),
    },
    {
      'label': 'Amoureux·se',
      'image': 'assets/moods/amour.png',
      'color': Color(0xFFFFE6B3),
      'size': 130.0,
    },
    {
      'label': 'Flemme',
      'image': 'assets/moods/flemme.png',
      'color': Color(0xFFCFF5E7),
    },
    {
      'label': 'Grignoter',
      'image': 'assets/moods/grignotage.png',
      'color': Color(0xFFFFDDC1),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPrenom();
  }

  Future<void> _loadUserPrenom() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final data =
          await Supabase.instance.client
              .from('users')
              .select('prenom')
              .eq('id', user.id)
              .single();

      setState(() {
        prenom = data['prenom'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hello, ',
                style: GoogleFonts.josefinSans(
                  fontSize: 20,
                  color: Color(0xFFF8A588),
                ),
              ),
              TextSpan(
                text: prenom,
                style: GoogleFonts.josefinSans(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comment tu te sens aujourd’hui ?',
              style: GoogleFonts.josefinSans(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
                children:
                    moods.map((mood) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/suggestions',
                            arguments: mood['label'],
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: mood['color'],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Image.asset(
                                    mood['image'],
                                    height: mood['size'] ?? 140,
                                    width: mood['size'] ?? 140,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mood['label'],
                                style: GoogleFonts.josefinSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
