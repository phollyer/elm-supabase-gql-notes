create extension if not exists pgcrypto;
create extension if not exists pg_graphql;

-- Enable GraphQL schema introspection and inflect snake_case to camelCase.
comment on schema public is e'@graphql({"introspection": true, "inflect_names": true})';

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_profiles_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

create table if not exists public.notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  body text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_notes_updated_at
before update on public.notes
for each row
execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.notes enable row level security;

grant usage on schema public to authenticated;
grant select, insert, update on public.profiles to authenticated;
grant select, insert, update, delete on public.notes to authenticated;

-- service_role bypasses RLS but still needs table-level grants for introspection.
grant usage on schema public to service_role;
grant select, insert, update, delete on public.profiles to service_role;
grant select, insert, update, delete on public.notes to service_role;

create policy "profiles_select_own"
  on public.profiles
  for select
  using (auth.uid() = id);

create policy "profiles_insert_own"
  on public.profiles
  for insert
  with check (auth.uid() = id);

create policy "profiles_update_own"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "notes_select_own"
  on public.notes
  for select
  using (auth.uid() = user_id);

create policy "notes_insert_own"
  on public.notes
  for insert
  with check (auth.uid() = user_id);

create policy "notes_update_own"
  on public.notes
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "notes_delete_own"
  on public.notes
  for delete
  using (auth.uid() = user_id);
