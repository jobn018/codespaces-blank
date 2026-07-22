update storage.buckets
set public = true
where id = 'product-images';

insert into storage.buckets (id, name, public)
select 'payment-proofs', 'payment-proofs', true
where not exists (
  select 1 from storage.buckets where id = 'payment-proofs'
);

update storage.buckets
set public = true
where id = 'payment-proofs';

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'product_images_select'
  ) then
    create policy product_images_select
    on storage.objects
    for select
    to public
    using (bucket_id = 'product-images');
  end if;
end $$;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'payment_proofs_select'
  ) then
    create policy payment_proofs_select
    on storage.objects
    for select
    to public
    using (bucket_id = 'payment-proofs');
  end if;
end $$;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'payment_proofs_insert'
  ) then
    create policy payment_proofs_insert
    on storage.objects
    for insert
    to public
    with check (bucket_id = 'payment-proofs');
  end if;
end $$;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'product_images_insert'
  ) then
    create policy product_images_insert
    on storage.objects
    for insert
    to authenticated
    with check (bucket_id = 'product-images');
  end if;
end $$;
