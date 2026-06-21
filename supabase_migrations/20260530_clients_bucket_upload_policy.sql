-- Storage RLS for the public `clients` bucket.
--
-- The bucket had NO authenticated-write policy, so portal document uploads and
-- message attachments (both target `clients/{uid}/...`) failed at runtime with
-- "new row violates row-level security policy". This grants each authenticated
-- user insert/read/delete on their own top-level folder, mirroring the
-- existing `chat-attachments` policy. (Public reads already work via the
-- bucket's public URLs.)

drop policy if exists "Users can upload own client files" on storage.objects;
create policy "Users can upload own client files"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'clients'
    and (storage.foldername(name))[1] = (auth.uid())::text
  );

drop policy if exists "Users can read own client files" on storage.objects;
create policy "Users can read own client files"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'clients'
    and (storage.foldername(name))[1] = (auth.uid())::text
  );

drop policy if exists "Users can delete own client files" on storage.objects;
create policy "Users can delete own client files"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'clients'
    and (storage.foldername(name))[1] = (auth.uid())::text
  );
