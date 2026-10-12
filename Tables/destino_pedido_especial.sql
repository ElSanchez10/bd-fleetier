-- Destinos de los pedidos especiales (los que van fuera del reparto normal).
-- precio_base es el precio que se propone al registrar un pedido a ese
-- destino; cada pedido guarda el suyo.
create table destino_pedido_especial (
  id           int         generated always as identity,
  nombre       text        not null,
  precio_base  int         not null,
  creado_en    timestamptz not null default now()
);
