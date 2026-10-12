alter table cooler
  add constraint cooler_pk primary key (id),
  add constraint cooler_codigo_uk unique (codigo),
  add constraint cooler_tipo_cooler_fk foreign key (tipo_cooler_id) references tipo_cooler(id),
  add constraint cooler_local_fk foreign key (local_id) references local(id);
