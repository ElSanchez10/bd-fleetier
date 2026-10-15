alter table caso_excepcional
  add constraint caso_excepcional_pk primary key (id),
  add constraint caso_excepcional_local_fk foreign key (local_id) references local(id),
  add constraint caso_excepcional_conductor_fk foreign key (conductor_id) references conductor(id);
