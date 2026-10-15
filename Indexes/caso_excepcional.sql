-- Los listados filtran por día y local.
create index caso_excepcional_fecha_idx on caso_excepcional (fecha);
create index caso_excepcional_local_idx on caso_excepcional (local_id, fecha);
create index caso_excepcional_conductor_idx on caso_excepcional (conductor_id, fecha);
