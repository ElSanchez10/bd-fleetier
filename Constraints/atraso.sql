alter table atraso
  add constraint atraso_pk primary key (id),
  add constraint atraso_cantidad check (cantidad > 0),
  add constraint atraso_local_fk foreign key (local_id) references local(id);
