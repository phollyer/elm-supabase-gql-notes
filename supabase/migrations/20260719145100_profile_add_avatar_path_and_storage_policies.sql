-- add avatar path to profiles
alter table public.profiles
add column if not exists avatar_path text;

comment on column public.profiles.avatar_path is 'Path in Storage bucket avatar, e.g. <user-id>/avatar.png';

-- create/configure public avatar storage bucket
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
	'avatar',
	'avatar',
	true,
	1048576,
	array['image/png', 'image/jpeg', 'image/gif', 'image/webp']
)
on conflict (id) do update
set
	name = excluded.name,
	public = excluded.public,
	file_size_limit = excluded.file_size_limit,
	allowed_mime_types = excluded.allowed_mime_types;

-- storage policies for avatar bucket
drop policy if exists "avatar_public_read" on storage.objects;
drop policy if exists "avatar_insert_own_folder" on storage.objects;
drop policy if exists "avatar_update_own_folder" on storage.objects;
drop policy if exists "avatar_delete_own_folder" on storage.objects;

-- bucket is public, so anyone can read objects
create policy "avatar_public_read"
	on storage.objects
	for select
	using (bucket_id = 'avatar');

-- authenticated users can upload only into their own top-level folder
create policy "avatar_insert_own_folder"
	on storage.objects
	for insert
	to authenticated
	with check (
		bucket_id = 'avatar'
		and (storage.foldername(name))[1] = auth.uid()::text
	);

-- users can update only objects in their own folder
create policy "avatar_update_own_folder"
	on storage.objects
	for update
	to authenticated
	using (
		bucket_id = 'avatar'
		and (storage.foldername(name))[1] = auth.uid()::text
	)
	with check (
		bucket_id = 'avatar'
		and (storage.foldername(name))[1] = auth.uid()::text
	);

-- users can delete only objects in their own folder
create policy "avatar_delete_own_folder"
	on storage.objects
	for delete
	to authenticated
	using (
		bucket_id = 'avatar'
		and (storage.foldername(name))[1] = auth.uid()::text
	);
