
-- Replace YOUR_ADMIN_EMAIL with your admin email before running this file.
create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  sku text unique not null,
  name text not null,
  category text,
  colour text,
  size text,
  opening_stock integer not null default 0 check (opening_stock >= 0),
  cost_price numeric(12,2) not null default 0,
  selling_price numeric(12,2) not null default 0,
  reorder_level integer not null default 5,
  image_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.stock_transactions (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  transaction_type text not null check (transaction_type in ('IN','OUT')),
  quantity integer not null check (quantity > 0),
  unit_price numeric(12,2) not null default 0,
  party text,
  reference text,
  notes text,
  created_at timestamptz not null default now(),
  created_by uuid default auth.uid()
);

create or replace view public.inventory_view as
select
  p.id,p.sku,p.name,p.category,p.colour,p.size,p.image_url,
  p.opening_stock
  + coalesce(sum(case when t.transaction_type='IN' then t.quantity else 0 end),0)
  - coalesce(sum(case when t.transaction_type='OUT' then t.quantity else 0 end),0)
  as current_stock,
  p.reorder_level,p.cost_price,p.selling_price
from public.products p
left join public.stock_transactions t on t.product_id=p.id
group by p.id;

alter table public.products enable row level security;
alter table public.stock_transactions enable row level security;

drop policy if exists "admin can manage products" on public.products;
create policy "admin can manage products"
on public.products for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

drop policy if exists "admin can manage transactions" on public.stock_transactions;
create policy "admin can manage transactions"
on public.stock_transactions for all to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

insert into storage.buckets (id,name,public)
values ('product-images','product-images',true)
on conflict (id) do update set public=true;

drop policy if exists "admin uploads product images" on storage.objects;
create policy "admin uploads product images"
on storage.objects for insert to authenticated
with check (bucket_id='product-images' and (auth.jwt() ->> 'email')='YOUR_ADMIN_EMAIL');

drop policy if exists "public reads product images" on storage.objects;
create policy "public reads product images"
on storage.objects for select to public
using (bucket_id='product-images');
