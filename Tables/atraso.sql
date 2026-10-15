-- Órdenes de un local que quedaron atrasadas en un día (rezagos).
create table atraso (
  id         int         generated always as identity,
  local_id   int         not null,
  tipo       tipo_atraso not null,
  fecha      date        not null,
  cantidad   int         not null,
  creado_en  timestamptz not null default now()
);
