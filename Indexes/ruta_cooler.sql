-- Un cooler está en una sola ruta sin devolver a la vez.
create unique index ruta_cooler_ocupado on ruta_cooler (cooler_id) where not devuelto;
-- El historial de un cooler.
create index ruta_cooler_cooler_idx on ruta_cooler (cooler_id);
