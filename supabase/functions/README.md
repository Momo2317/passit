# Supabase Edge Functions (stubs)

Planned functions from the MVP spec. Implement server-side logic here; do **not** ship AI or service keys to the Flutter client.

| Function | Purpose |
|----------|---------|
| `lookup-product` | Resolve GTIN → catalog fields (Open Food Facts / custom providers). |
| `extract-document` | OCR / invoice extraction pipeline after upload. |
| `delete-user-data` | Account deletion: storage + DB rows for `auth.uid()`. |

Each folder contains a minimal `index.ts` Deno entry so `supabase functions serve <name>` has a starting point.
