-- Algo fuera de lo común que pasó con un conductor en un local (un choque,
-- un reclamo…), anotado para tenerlo a la vista.
create table caso_excepcional (
  id            int         generated always as identity,
  local_id      int         not null,
  conductor_id  int         not null,
  fecha         date        not null,
  descripcion   text        not null,
  creado_en     timestamptz not null default now()
);
