-- Un cooler del inventario de un local.
--   nombre  el número con que la gente lo identifica; va escrito en el cooler
--   codigo  lo que lee la pistola: el código de barras de su etiqueta
create table cooler (
  id                 int           generated always as identity,
  nombre             text          not null,
  codigo             text          not null,
  fecha_adquisicion  date          not null,
  tiene_tapa         boolean       not null default false,
  tipo_cooler_id     int           not null,
  estado             estado_cooler not null default 'disponible',
  local_id           int           not null,
  creado_en          timestamptz   not null default now()
);
