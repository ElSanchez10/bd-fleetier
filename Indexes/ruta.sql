-- Un conductor está en una sola ruta abierta a la vez.
create unique index ruta_conductor_ocupado on ruta (conductor_id)
  where estado in ('en_espera', 'en_ejecucion');
-- Los listados filtran por día y local; el conductor ve sus rutas por fecha.
create index ruta_fecha_idx on ruta (fecha);
create index ruta_local_idx on ruta (local_id, fecha);
create index ruta_conductor_idx on ruta (conductor_id, fecha);
