import 'package:flutter/material.dart';

import 'app/passit_app.dart';
import 'bootstrap.dart';
import 'config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  await bootstrapSupabase(config);

  runApp(PassitApp(config: config));
}
