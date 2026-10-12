create table ciudad (
  id         int         generated always as identity,
  nombre     text        not null,
  creado_en  timestamptz not null default now()
);
