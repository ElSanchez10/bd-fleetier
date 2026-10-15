-- Algo que salió mal en una ruta (pedidos no entregados, rechazados…).
--   cantidad  cuántas órdenes afectó
create table problema_ruta (
  id           int         generated always as identity,
  ruta_id      int         not null,
  cantidad     int         not null,
  descripcion  text        not null,
  creado_en    timestamptz not null default now()
);
