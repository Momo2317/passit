# PASSIT (MVP bootstrap)

Phase 1: Supabase schema + private storage buckets, Flutter app shell (Material 3, go_router tab scaffold, Bloc, Supabase client), Edge Function stubs.

## Repository layout

| Path | Description |
|------|-------------|
| `passit/` | Flutter application |
| `supabase/migrations/` | PostgreSQL migrations (tables, RLS, storage buckets & policies) |
| `supabase/functions/` | Edge Function stubs |

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (SDK 3.24+)
- [Supabase CLI](https://supabase.com/docs/guides/cli) for linking and `db push` / local Postgres

## Supabase — apply migrations

From the repo root (link your project once):

```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

Or run SQL in the Supabase SQL editor in timestamp order under `supabase/migrations/`.

### `product_catalog` access model

- **Authenticated clients:** `SELECT` only (shared GTIN cache for barcode flows).
- **Writes:** intended for service role / Edge Functions / ingestion jobs — no `INSERT`/`UPDATE`/`DELETE` policies for `authenticated`; use the dashboard or service key for backfills.

### Storage buckets

Migrations create **private** buckets `passit-products` and `passit-documents` with policies that require object paths:

```text
{user_id}/{item_id}/...
```

Users may only read/write objects whose first path segment equals `auth.uid()`.

## Flutter app

```bash
cd passit
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

Copy `passit/.env.example` for local tooling if needed; **do not** commit secrets. The sample uses compile-time `--dart-define` so keys are not stored in source control.

### Run tests

```bash
cd passit
flutter test
```

## Edge Functions (stubs)

See `supabase/functions/README.md`. Serve locally:

```bash
supabase functions serve lookup-product
```

## Architecture notes

- Feature-first layout under `passit/lib/features/*` with `data` / `domain` / `presentation` placeholders per the MVP spec.
- Bottom navigation via `go_router` `StatefulShellRoute` and five tab branches.
