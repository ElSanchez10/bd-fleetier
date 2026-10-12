-- Clasificación de los conductores (por ejemplo, según su vehículo).
create table tipo_conductor (
  id         int         generated always as identity,
  nombre     text        not null,
  creado_en  timestamptz not null default now()
);
