-- Los listados filtran por día y local.
create index pedido_especial_fecha_idx on pedido_especial (fecha);
create index pedido_especial_local_idx on pedido_especial (local_id, fecha);
create index pedido_especial_destino_idx on pedido_especial (destino_id);
