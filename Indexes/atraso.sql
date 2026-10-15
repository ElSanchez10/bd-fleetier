-- Los listados filtran por día y local.
create index atraso_fecha_idx on atraso (fecha);
create index atraso_local_idx on atraso (local_id, fecha);
