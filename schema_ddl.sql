-- B2B: catálogo mayorista de iPhones (mínimo 2 unidades por pedido)
-- Vive en el mismo proyecto Supabase que tecnoofertas (nwtxmqgwwsturjikbmvh),
-- reutiliza la tabla perfiles(id, rol, nombre) ya existente para el acceso admin.

create table if not exists b2b_productos (
  id bigint generated always as identity primary key,
  modelo text not null,
  capacidad text not null,
  precio numeric(10,2) not null default 0,
  foto_url text,
  orden int not null default 0,
  activo boolean not null default false,
  created_at timestamptz not null default now(),
  unique (modelo, capacidad)
);

create table if not exists b2b_pedidos (
  id bigint generated always as identity primary key,
  empresa text not null,
  contacto text not null,
  email text not null,
  telefono text,
  notas text,
  total numeric(10,2) not null default 0,
  estado text not null default 'nuevo',
  created_at timestamptz not null default now()
);

create table if not exists b2b_pedido_items (
  id bigint generated always as identity primary key,
  pedido_id bigint not null references b2b_pedidos(id) on delete cascade,
  producto_id bigint references b2b_productos(id),
  modelo text not null,
  capacidad text not null,
  cantidad int not null check (cantidad >= 2),
  precio_unitario numeric(10,2) not null,
  subtotal numeric(10,2) not null
);

alter table b2b_productos enable row level security;
alter table b2b_pedidos enable row level security;
alter table b2b_pedido_items enable row level security;

-- Catálogo público: cualquiera puede leer solo los productos activos (storefront sin login)
create policy "b2b_productos_select_active" on b2b_productos
  for select using (activo = true);

-- Admin (perfiles.rol = 'admin') puede leer/crear/editar/borrar todo, incluidos inactivos
create policy "b2b_productos_admin_all" on b2b_productos
  for all
  using (exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'))
  with check (exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'));

-- Pedidos: cualquiera puede crear (checkout sin login), solo admin puede leer/editar
create policy "b2b_pedidos_insert_public" on b2b_pedidos
  for insert with check (true);

create policy "b2b_pedidos_admin_full" on b2b_pedidos
  for all
  using (exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'))
  with check (exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'));

create policy "b2b_pedido_items_insert_public" on b2b_pedido_items
  for insert with check (true);

create policy "b2b_pedido_items_admin_full" on b2b_pedido_items
  for all
  using (exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'))
  with check (exists (select 1 from perfiles where perfiles.id = auth.uid() and perfiles.rol = 'admin'));

-- Seed: 9 modelos x 3 capacidades, precio 0 e inactivo hasta que el admin fije precio y active
insert into b2b_productos (modelo, capacidad, orden, precio, activo) values
('iPhone 13', '128GB', 1, 0, false),
('iPhone 13', '256GB', 2, 0, false),
('iPhone 13', '512GB', 3, 0, false),
('iPhone 13 Pro', '128GB', 4, 0, false),
('iPhone 13 Pro', '256GB', 5, 0, false),
('iPhone 13 Pro', '512GB', 6, 0, false),
('iPhone 13 Pro Max', '128GB', 7, 0, false),
('iPhone 13 Pro Max', '256GB', 8, 0, false),
('iPhone 13 Pro Max', '512GB', 9, 0, false),
('iPhone 14', '128GB', 10, 0, false),
('iPhone 14', '256GB', 11, 0, false),
('iPhone 14', '512GB', 12, 0, false),
('iPhone 14 Pro', '128GB', 13, 0, false),
('iPhone 14 Pro', '256GB', 14, 0, false),
('iPhone 14 Pro', '512GB', 15, 0, false),
('iPhone 14 Pro Max', '128GB', 16, 0, false),
('iPhone 14 Pro Max', '256GB', 17, 0, false),
('iPhone 14 Pro Max', '512GB', 18, 0, false),
('iPhone 15', '128GB', 19, 0, false),
('iPhone 15', '256GB', 20, 0, false),
('iPhone 15', '512GB', 21, 0, false),
('iPhone 15 Pro', '128GB', 22, 0, false),
('iPhone 15 Pro', '256GB', 23, 0, false),
('iPhone 15 Pro', '512GB', 24, 0, false),
('iPhone 15 Pro Max', '128GB', 25, 0, false),
('iPhone 15 Pro Max', '256GB', 26, 0, false),
('iPhone 15 Pro Max', '512GB', 27, 0, false)
on conflict (modelo, capacidad) do nothing;
