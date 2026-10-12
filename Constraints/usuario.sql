alter table usuario
  add constraint usuario_pk primary key (id),
  add constraint usuario_local_fk foreign key (local_id) references local(id);
