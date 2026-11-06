-- Private buckets for product photos and documents.
-- Path convention: {user_id}/{item_id}/filename.ext

insert into storage.buckets (id, name, public)
values
  ('passit-products', 'passit-products', false),
  ('passit-documents', 'passit-documents', false)
on conflict (id) do update set public = excluded.public;

-- Enforce first path segment = auth.uid() for object access
-- split_part(name, '/', 1) is the owning user folder

drop policy if exists "passit_products_select_own" on storage.objects;
drop policy if exists "passit_products_insert_own" on storage.objects;
drop policy if exists "passit_products_update_own" on storage.objects;
drop policy if exists "passit_products_delete_own" on storage.objects;
drop policy if exists "passit_documents_select_own" on storage.objects;
drop policy if exists "passit_documents_insert_own" on storage.objects;
drop policy if exists "passit_documents_update_own" on storage.objects;
drop policy if exists "passit_documents_delete_own" on storage.objects;

create policy "passit_products_select_own"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'passit-products'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "passit_products_insert_own"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'passit-products'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "passit_products_update_own"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'passit-products'
    and split_part(name, '/', 1) = auth.uid()::text
  )
  with check (
    bucket_id = 'passit-products'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "passit_products_delete_own"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'passit-products'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "passit_documents_select_own"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'passit-documents'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "passit_documents_insert_own"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'passit-documents'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "passit_documents_update_own"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'passit-documents'
    and split_part(name, '/', 1) = auth.uid()::text
  )
  with check (
    bucket_id = 'passit-documents'
    and split_part(name, '/', 1) = auth.uid()::text
  );

create policy "passit_documents_delete_own"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'passit-documents'
    and split_part(name, '/', 1) = auth.uid()::text
  );
