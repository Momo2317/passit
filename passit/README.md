# PASSIT — Flutter app

This directory holds the mobile client. Project-wide docs (Supabase migrations, Edge stubs, and how to run everything together) live in the repository root [`README.md`](../README.md).

Quick start:

```bash
cd passit
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_ANON_KEY
```

See also [`.env.example`](.env.example).
