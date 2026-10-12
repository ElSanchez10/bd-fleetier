create table tipo_cooler (
  id         int              generated always as identity,
  marca      text             not null,
  capacidad  capacidad_cooler not null,
  color      color            not null,
  creado_en  timestamptz      not null default now()
);
