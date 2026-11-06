# PASSIT (Flutter)

PASSIT mobile app — Material 3, **Bloc**, **go_router**, **Supabase Auth**.

## State management — auth

The app uses a dedicated **`AuthBloc`** (`lib/auth/`) for sign-in, sign-up, sign-out, and session state. Other app-wide state can stay in cubits later; auth is isolated so routing and profile stay testable and the session listener has a single owner.

`AuthBloc` listens to **`Supabase.instance.client.auth.onAuthStateChange`** and updates `PassitAuthState`; **`go_router`** uses a `GoRouterRefreshStream` on `authBloc.stream` so redirects stay in sync when the session changes.

## Supabase configuration (no secrets in repo)

Use **`--dart-define`** at run/build time (see [`.env.example`](.env.example) for the variable names):

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_OR_PUBLISHABLE_KEY
```

The Supabase Flutter SDK accepts this key as **`publishableKey`** (same value as the anon key in the dashboard).

Apply SQL migrations from the repo root [`../supabase/migrations/`](../supabase/migrations/) in order. **`20251106100002_profile_on_signup.sql`** creates `public.profiles` and a trigger so each new `auth.users` row gets a matching profile.

## Local development and email confirmation

If **Confirm email** is enabled in Supabase, new users may not get a session until they confirm — which blocks quick local testing.

For local development you can **disable email confirmation**:

Supabase Dashboard → **Authentication** → **Providers** → **Email** → turn off **Confirm email** (re-enable before production).

## Useful commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

## Security notes

- Use only the **anon / publishable** client key in the app — never the **service role** key.
