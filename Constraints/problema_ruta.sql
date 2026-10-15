alter table problema_ruta
  add constraint problema_ruta_pk primary key (id),
  add constraint problema_ruta_cantidad check (cantidad > 0),
  add constraint problema_ruta_ruta_fk foreign key (ruta_id) references ruta(id);
