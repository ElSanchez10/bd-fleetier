alter table destino_pedido_especial
  add constraint destino_pedido_especial_pk primary key (id),
  add constraint destino_pedido_especial_precio_valido check (precio_base >= 0);
