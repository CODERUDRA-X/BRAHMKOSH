-- BRAHMKOSH: private, per-user Supabase storage
-- Run in Supabase Dashboard -> SQL Editor.
-- This removes existing policies on this table and replaces them with
-- user-scoped policies. Review existing data/policies before running.

create extension if not exists pgcrypto;

create table if not exists public.vault_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 180),
  kind text not null default 'note'
    check (kind in ('note','link','task','snippet','other')),
  content text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists vault_items_user_id_idx on public.vault_items(user_id);
create index if not exists vault_items_updated_at_idx on public.vault_items(updated_at desc);
alter table public.vault_items enable row level security;

do $$
declare p record;
begin
  for p in select policyname from pg_policies
    where schemaname='public' and tablename='vault_items'
  loop
    execute format('drop policy if exists %I on public.vault_items', p.policyname);
  end loop;
end $$;

create policy "Users can read own vault items" on public.vault_items
  for select to authenticated using (auth.uid() = user_id);
create policy "Users can insert own vault items" on public.vault_items
  for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can update own vault items" on public.vault_items
  for update to authenticated using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "Users can delete own vault items" on public.vault_items
  for delete to authenticated using (auth.uid() = user_id);

grant select, insert, update, delete on public.vault_items to authenticated;
revoke all on public.vault_items from anon;

create or replace function public.set_vault_items_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists vault_items_set_updated_at on public.vault_items;
create trigger vault_items_set_updated_at before update on public.vault_items
for each row execute function public.set_vault_items_updated_at();
