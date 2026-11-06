import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const url = SupabaseConfig.url;
  const publishableKey = SupabaseConfig.publishableKey;
  if (url.isEmpty || publishableKey.isEmpty) {
    debugPrint(
      'Supabase: missing SUPABASE_URL or SUPABASE_ANON_KEY. '
      'Pass them via --dart-define (see README and .env.example).',
    );
  } else {
    await Supabase.initialize(
      url: url,
      publishableKey: publishableKey,
    );
  }

  runApp(const PassitApp());
}
