import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const supabaseUrl = 'https://qumylksbtceqmdndibqx.supabase.co';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1bXlsa3NidGNlcW1kbmRpYnF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg0NjQ3NjEsImV4cCI6MjA2NDA0MDc2MX0.hAXPnA3QOxySYvhv0ckwcgsZ9a3yqoYbPLlmdzukipU';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
