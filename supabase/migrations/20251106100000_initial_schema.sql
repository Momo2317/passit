-- PASSIT Phase 1: core tables, RLS, and helpers
-- Requires: pgcrypto for gen_random_uuid()

create extension if not exists "pgcrypto";

-- -----------------------------------------------------------------------------
-- profiles
-- -----------------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  locale text,
  created_at timestamptz not null default now()
);

comment on table public.profiles is 'App profile row per auth user; RLS limits to own row.';

-- -----------------------------------------------------------------------------
-- product_catalog (shared GTIN cache — read-only for authenticated clients)
-- -----------------------------------------------------------------------------
create table public.product_catalog (
  id uuid primary key default gen_random_uuid(),
  gtin text not null,
  name text,
  brand text,
  model text,
  image_url text,
  source text,
  last_synced_at timestamptz,
  constraint product_catalog_gtin_unique unique (gtin)
);

create index product_catalog_gtin_idx on public.product_catalog (gtin);

comment on table public.product_catalog is
  'Shared barcode/GTIN catalog cache. Authenticated users may SELECT; writes are service-role / backend only.';

-- -----------------------------------------------------------------------------
-- items
-- -----------------------------------------------------------------------------
create table public.items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  catalog_id uuid references public.product_catalog (id) on delete set null,
  name text not null,
  category text,
  brand text,
  model text,
  serial_number text,
  barcode text,
  purchase_date date,
  purchase_price numeric(12, 2),
  currency text,
  retailer text,
  condition text,
  notes text,
  acquisition_source text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index items_user_id_idx on public.items (user_id);
create index items_catalog_id_idx on public.items (catalog_id);
create index items_created_at_idx on public.items (created_at desc);

-- -----------------------------------------------------------------------------
-- item_photos
-- -----------------------------------------------------------------------------
create table public.item_photos (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.items (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  storage_path text not null,
  photo_type text,
  created_at timestamptz not null default now()
);

create index item_photos_item_id_idx on public.item_photos (item_id);
create index item_photos_user_id_idx on public.item_photos (user_id);

-- -----------------------------------------------------------------------------
-- item_documents
-- -----------------------------------------------------------------------------
create table public.item_documents (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.items (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  document_type text,
  original_filename text,
  mime_type text,
  storage_path text not null,
  extracted_data jsonb,
  created_at timestamptz not null default now()
);

create index item_documents_item_id_idx on public.item_documents (item_id);
create index item_documents_user_id_idx on public.item_documents (user_id);

-- -----------------------------------------------------------------------------
-- reminders
-- -----------------------------------------------------------------------------
create table public.reminders (
  id uuid primary key default gen_random_uuid(),
  item_id uuid references public.items (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  reminder_type text,
  due_at timestamptz,
  is_enabled boolean not null default true,
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create index reminders_user_id_idx on public.reminders (user_id);
create index reminders_due_at_idx on public.reminders (due_at);

-- -----------------------------------------------------------------------------
-- updated_at trigger for items
-- -----------------------------------------------------------------------------
create or replace function public.passit_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists items_set_updated_at on public.items;
create trigger items_set_updated_at
  before update on public.items
  for each row
  execute function public.passit_set_updated_at();

-- -----------------------------------------------------------------------------
-- Row Level Security
-- -----------------------------------------------------------------------------
alter table public.profiles enable row level security;
alter table public.product_catalog enable row level security;
alter table public.items enable row level security;
alter table public.item_photos enable row level security;
alter table public.item_documents enable row level security;
alter table public.reminders enable row level security;

-- profiles: own row only
drop policy if exists "profiles_select_own" on public.profiles;
drop policy if exists "profiles_insert_own" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;
drop policy if exists "profiles_delete_own" on public.profiles;

create policy "profiles_select_own"
  on public.profiles for select
  to authenticated
  using (id = auth.uid());

create policy "profiles_insert_own"
  on public.profiles for insert
  to authenticated
  with check (id = auth.uid());

create policy "profiles_update_own"
  on public.profiles for update
  to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "profiles_delete_own"
  on public.profiles for delete
  to authenticated
  using (id = auth.uid());

-- product_catalog: readable shared cache; mutations reserved for service role
drop policy if exists "product_catalog_select_authenticated" on public.product_catalog;

create policy "product_catalog_select_authenticated"
  on public.product_catalog for select
  to authenticated
  using (true);

-- items
drop policy if exists "items_select_own" on public.items;
drop policy if exists "items_insert_own" on public.items;
drop policy if exists "items_update_own" on public.items;
drop policy if exists "items_delete_own" on public.items;

create policy "items_select_own"
  on public.items for select
  to authenticated
  using (user_id = auth.uid());

create policy "items_insert_own"
  on public.items for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "items_update_own"
  on public.items for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "items_delete_own"
  on public.items for delete
  to authenticated
  using (user_id = auth.uid());

-- item_photos
drop policy if exists "item_photos_select_own" on public.item_photos;
drop policy if exists "item_photos_insert_own" on public.item_photos;
drop policy if exists "item_photos_update_own" on public.item_photos;
drop policy if exists "item_photos_delete_own" on public.item_photos;

create policy "item_photos_select_own"
  on public.item_photos for select
  to authenticated
  using (user_id = auth.uid());

create policy "item_photos_insert_own"
  on public.item_photos for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "item_photos_update_own"
  on public.item_photos for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "item_photos_delete_own"
  on public.item_photos for delete
  to authenticated
  using (user_id = auth.uid());

-- item_documents
drop policy if exists "item_documents_select_own" on public.item_documents;
drop policy if exists "item_documents_insert_own" on public.item_documents;
drop policy if exists "item_documents_update_own" on public.item_documents;
drop policy if exists "item_documents_delete_own" on public.item_documents;

create policy "item_documents_select_own"
  on public.item_documents for select
  to authenticated
  using (user_id = auth.uid());

create policy "item_documents_insert_own"
  on public.item_documents for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "item_documents_update_own"
  on public.item_documents for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "item_documents_delete_own"
  on public.item_documents for delete
  to authenticated
  using (user_id = auth.uid());

-- reminders
drop policy if exists "reminders_select_own" on public.reminders;
drop policy if exists "reminders_insert_own" on public.reminders;
drop policy if exists "reminders_update_own" on public.reminders;
drop policy if exists "reminders_delete_own" on public.reminders;

create policy "reminders_select_own"
  on public.reminders for select
  to authenticated
  using (user_id = auth.uid());

create policy "reminders_insert_own"
  on public.reminders for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "reminders_update_own"
  on public.reminders for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "reminders_delete_own"
  on public.reminders for delete
  to authenticated
  using (user_id = auth.uid());
