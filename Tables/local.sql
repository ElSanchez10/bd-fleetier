-- Un local desde donde salen las rutas y donde se guardan los coolers.
create table local (
  id         uuid        not null default gen_random_uuid(),
  ciudad_id  uuid        not null,
  nombre     text        not null,
  direccion  text        not null,
  creado_en  timestamptz not null default now()
);
