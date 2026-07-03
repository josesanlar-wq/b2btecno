# tecnoofertas-b2b

Tienda mayorista (B2B) de iPhones — compra mínima 2 unidades por modelo/capacidad.

Usa el mismo proyecto Supabase que `tecnoofertas` (mismo `SURL`/`SKEY` en `index.html`), en tablas nuevas: `b2b_productos`, `b2b_pedidos`, `b2b_pedido_items`. El acceso admin reutiliza la tabla `perfiles` (rol = 'admin') que ya existe en ese proyecto.

## Setup

1. Corre `schema_ddl.sql` en el SQL Editor de Supabase (crea las tablas, RLS y el catálogo semilla de 27 SKUs con precio 0 e inactivos).
2. Abre `index.html`, entra a **Admin** con una cuenta que tenga `rol = 'admin'` en `perfiles`, y carga precio + foto (URL de imagen) por cada modelo/capacidad, luego marca **Activo**.
3. Los productos activos aparecen en el catálogo público. Los pedidos quedan en `b2b_pedidos` / `b2b_pedido_items` para seguimiento manual (no hay pasarela de pago todavía).
