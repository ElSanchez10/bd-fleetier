-- Tipos de evento del calendario de un conductor: vacaciones, licencia…
create table tipo_evento (
  id         int         generated always as identity,
  nombre     text        not null,
  color      color       not null,
  creado_en  timestamptz not null default now()
);
