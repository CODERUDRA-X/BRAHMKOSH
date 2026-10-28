-- Run this in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.vault_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text,
  kind text not null default 'note' check (kind in ('note','link','task','snippet','other')),
  content text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.vault_items enable row level security;

drop policy if exists "Users can view their own vault items" on public.vault_items;
create policy "Users can view their own vault items"
on public.vault_items for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own vault items" on public.vault_items;
create policy "Users can insert their own vault items"
on public.vault_items for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own vault items" on public.vault_items;
create policy "Users can update their own vault items"
on public.vault_items for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own vault items" on public.vault_items;
create policy "Users can delete their own vault items"
on public.vault_items for delete to authenticated
using (auth.uid() = user_id);

create index if not exists vault_items_user_updated_idx
on public.vault_items (user_id, updated_at desc);

grant select, insert, update, delete on public.vault_items to authenticated;
