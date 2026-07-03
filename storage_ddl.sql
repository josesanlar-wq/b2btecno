-- Crea el bucket público para fotos de producto y sus políticas.
-- Seguro de correr varias veces (idempotente).

insert into storage.buckets (id, name, public)
values ('b2b-fotos', 'b2b-fotos', true)
on conflict (id) do nothing;

drop policy if exists "b2b_fotos_public_read" on storage.objects;
create policy "b2b_fotos_public_read" on storage.objects
  for select using (bucket_id = 'b2b-fotos');

drop policy if exists "b2b_fotos_admin_write" on storage.objects;
create policy "b2b_fotos_admin_write" on storage.objects
  for all
  using (bucket_id = 'b2b-fotos' and exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'))
  with check (bucket_id = 'b2b-fotos' and exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'));
