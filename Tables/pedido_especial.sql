-- Pedidos que un local envía fuera del reparto normal, a un destino especial.
--   cantidad        cuántas órdenes de pedido
--   precio          lo que se cobra; se propone el precio_base del destino
--   extraordinario  fuera de lo acordado; solo lo marcan admin y asistente
create table pedido_especial (
  id              int         generated always as identity,
  local_id        int         not null,
  destino_id      int         not null,
  fecha           date        not null,
  cantidad        int         not null,
  precio          int         not null,
  extraordinario  boolean     not null default false,
  descripcion     text        not null default '',
  creado_en       timestamptz not null default now()
);
