-- Un local desde donde salen las rutas y donde se guardan los coolers.
create table local (
  id         int         generated always as identity,
  ciudad_id  int         not null,
  nombre     text        not null,
  direccion  text        not null,
  creado_en  timestamptz not null default now()
);
