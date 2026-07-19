-- add soft delete support so notes can be restored after deletion
alter table public.notes
add column deleted_at timestamptz;

-- replace existing select policy so deleted notes are hidden by default
drop policy if exists "notes_select_own_active" on public.notes;

-- active notes policy
create policy "notes_select_own_active"
  on public.notes
  for select
  using (auth.uid() = user_id and deleted_at is null);

-- trashed notes policy
create policy "notes_select_own_trashed"
  on public.notes
  for select
  using (auth.uid() = user_id and deleted_at is not null);

create or replace function public.set_deleted_at()
returns trigger
language plpgsql
as $$
begin
  new.deleted_at = now();
  return new;
end;
$$;

create trigger set_notes_deleted_at
before update on public.notes
for each row
when (old.deleted_at is null and new.deleted_at is not null)
execute function public.set_deleted_at();