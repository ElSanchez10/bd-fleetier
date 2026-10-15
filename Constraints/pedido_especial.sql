alter table pedido_especial
  add constraint pedido_especial_pk primary key (id),
  add constraint pedido_especial_cantidad check (cantidad > 0),
  add constraint pedido_especial_precio check (precio >= 0),
  add constraint pedido_especial_local_fk foreign key (local_id) references local(id),
  add constraint pedido_especial_destino_fk foreign key (destino_id) references destino_pedido_especial(id);
