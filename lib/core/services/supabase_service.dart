
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://dfivgusthhcxwdiprasx.supabase.co',
      publishableKey: 'sb_publishable_BugPFVkDi5iXhYfP9DBacQ_AHoDvIM6',
    );
  }
}
