create table conductor (
  id                 int         generated always as identity,
  nombre             text        not null,
  -- Sin puntos y con guion: "12345678-K". Así no hay dos formas de escribir el mismo.
  run                text        not null,
  fecha_nacimiento   date        not null,
  -- Los nueve dígitos del celular, sin el +56.
  telefono           text        not null,
  email              text        not null,
  ciudad_id          int         not null,
  tipo_conductor_id  int         not null,
  creado_en          timestamptz not null default now()
);
