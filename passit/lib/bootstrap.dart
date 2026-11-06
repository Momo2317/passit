import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';

/// Initializes Supabase when [AppConfig] includes URL and anon key.
///
/// In widget tests, [AppConfig.hasSupabaseConfig] is false and this is a no-op
/// so tests do not require network or a real project.
Future<void> bootstrapSupabase(AppConfig config) async {
  if (!config.hasSupabaseConfig) {
    if (kDebugMode) {
      debugPrint(
        'bootstrapSupabase: SUPABASE_URL / SUPABASE_ANON_KEY not set; '
        'running without Supabase (tests or missing --dart-define).',
      );
    }
    return;
  }

  await Supabase.initialize(
    url: config.supabaseUrl,
    publishableKey: config.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}
