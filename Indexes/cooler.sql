-- En un mismo local no hay dos coolers con el mismo número.
create unique index cooler_nombre_uk on cooler (local_id, lower(nombre));
create index cooler_tipo_cooler_idx on cooler (tipo_cooler_id);
