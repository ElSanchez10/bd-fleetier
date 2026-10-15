-- Los coolers que lleva una ruta. Una fila sin devolver es la que dice dónde
-- anda el cooler; al devolverlo queda como historia.
create table ruta_cooler (
  ruta_id      int         not null,
  cooler_id    int         not null,
  devuelto     boolean     not null default false,
  devuelto_en  timestamptz
);
