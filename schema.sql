create extension if not exists "uuid-ossp";

create table if not exists products (
  id uuid primary key default uuid_generate_v4(),
  sku text unique not null,
  name text not null,
  category text,
  colour text,
  size text,
  article_details text,
  size_details jsonb default '{}'::jsonb,
  opening_stock integer default 0,
  cost_price numeric default 0,
  selling_price numeric default 0,
  reorder_level integer default 5,
  image_url text,
  gallery_images jsonb default '[]'::jsonb,
  created_at timestamptz default now()
);

create table if not exists stock_transactions (
  id uuid primary key default uuid_generate_v4(),
  product_id uuid references products(id) on delete cascade,
  size text,
  transaction_type text not null,
  quantity integer not null,
  unit_price numeric default 0,
  party text,
  reference text,
  notes text,
  phone text,
  email text,
  address text,
  city text,
  postal_code text,
  order_id text,
  order_type text,
  payment_method text,
  payment_status text,
  proof_screenshot_url text,
  proof_uploaded_at timestamptz,
  referral_code text,
  referral_partner_id uuid,
  created_at timestamptz default now()
);

create table if not exists referral_partners (
  id uuid primary key default uuid_generate_v4(),
  partner_name text not null,
  referral_code text unique not null,
  phone text,
  email text,
  notes text,
  created_at timestamptz default now()
);

alter table products add column if not exists sku text;
alter table products add column if not exists name text;
alter table products add column if not exists category text;
alter table products add column if not exists colour text;
alter table products add column if not exists size text;
alter table products add column if not exists article_details text;
alter table products add column if not exists size_details jsonb default '{}'::jsonb;
alter table products add column if not exists opening_stock integer default 0;
alter table products add column if not exists cost_price numeric default 0;
alter table products add column if not exists selling_price numeric default 0;
alter table products add column if not exists reorder_level integer default 5;
alter table products add column if not exists image_url text;
alter table products add column if not exists gallery_images jsonb default '[]'::jsonb;
alter table products add column if not exists created_at timestamptz default now();

alter table stock_transactions add column if not exists product_id uuid;
alter table stock_transactions add column if not exists size text;
alter table stock_transactions add column if not exists transaction_type text;
alter table stock_transactions add column if not exists quantity integer;
alter table stock_transactions add column if not exists unit_price numeric default 0;
alter table stock_transactions add column if not exists party text;
alter table stock_transactions add column if not exists reference text;
alter table stock_transactions add column if not exists notes text;
alter table stock_transactions add column if not exists phone text;
alter table stock_transactions add column if not exists email text;
alter table stock_transactions add column if not exists address text;
alter table stock_transactions add column if not exists city text;
alter table stock_transactions add column if not exists postal_code text;
alter table stock_transactions add column if not exists order_id text;
alter table stock_transactions add column if not exists order_type text;
alter table stock_transactions add column if not exists payment_method text;
alter table stock_transactions add column if not exists payment_status text;
alter table stock_transactions add column if not exists proof_screenshot_url text;
alter table stock_transactions add column if not exists proof_uploaded_at timestamptz;
alter table stock_transactions add column if not exists referral_code text;
alter table stock_transactions add column if not exists referral_partner_id uuid;
alter table stock_transactions add column if not exists created_at timestamptz default now();

alter table referral_partners add column if not exists partner_name text;
alter table referral_partners add column if not exists referral_code text;
alter table referral_partners add column if not exists phone text;
alter table referral_partners add column if not exists email text;
alter table referral_partners add column if not exists notes text;
alter table referral_partners add column if not exists created_at timestamptz default now();

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'stock_transactions_product_id_fkey'
  ) then
    alter table stock_transactions
      add constraint stock_transactions_product_id_fkey
      foreign key (product_id) references products(id) on delete cascade;
  end if;
end $$;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'stock_transactions_referral_partner_id_fkey'
  ) then
    alter table stock_transactions
      add constraint stock_transactions_referral_partner_id_fkey
      foreign key (referral_partner_id) references referral_partners(id) on delete set null;
  end if;
end $$;

alter table products enable row level security;
alter table stock_transactions enable row level security;
alter table referral_partners enable row level security;

do $$
begin
  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'products' and policyname = 'products_select'
  ) then
    create policy products_select on products for select using (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'products' and policyname = 'products_insert'
  ) then
    create policy products_insert on products for insert with check (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'products' and policyname = 'products_update'
  ) then
    create policy products_update on products for update using (true) with check (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'products' and policyname = 'products_delete'
  ) then
    create policy products_delete on products for delete using (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'stock_transactions' and policyname = 'transactions_select'
  ) then
    create policy transactions_select on stock_transactions for select using (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'stock_transactions' and policyname = 'transactions_insert'
  ) then
    create policy transactions_insert on stock_transactions for insert with check (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'stock_transactions' and policyname = 'transactions_update'
  ) then
    create policy transactions_update on stock_transactions for update using (true) with check (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'stock_transactions' and policyname = 'transactions_delete'
  ) then
    create policy transactions_delete on stock_transactions for delete using (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'referral_partners' and policyname = 'referral_partners_select'
  ) then
    create policy referral_partners_select on referral_partners for select using (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'referral_partners' and policyname = 'referral_partners_insert'
  ) then
    create policy referral_partners_insert on referral_partners for insert with check (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'referral_partners' and policyname = 'referral_partners_update'
  ) then
    create policy referral_partners_update on referral_partners for update using (true) with check (true);
  end if;

  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'referral_partners' and policyname = 'referral_partners_delete'
  ) then
    create policy referral_partners_delete on referral_partners for delete using (true);
  end if;
end $$;