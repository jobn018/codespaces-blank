update storage.buckets
set public = true
where id = 'product-images';

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
      and policyname = 'product_images_insert'
  ) then
    create policy product_images_insert
    on storage.objects
    for insert
    to authenticated
    with check (bucket_id = 'product-images');
  end if;
end $$;
