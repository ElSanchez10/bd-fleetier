-- Una salida de reparto desde un local, con un conductor y los coolers que lleva.
--   fecha    cuándo sale; la elige quien la registra
--   ordenes  órdenes de pedido que lleva
create table ruta (
  id            int         generated always as identity,
  local_id      int         not null,
  conductor_id  int,
  fecha         timestamptz not null,
  ordenes       int         not null,
  estado        estado_ruta not null default 'en_espera',
  creado_en     timestamptz not null default now()
);
