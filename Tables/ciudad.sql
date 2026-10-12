create table ciudad (
  id         uuid        not null default gen_random_uuid(),
  nombre     text        not null,
  creado_en  timestamptz not null default now()
);
