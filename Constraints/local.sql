alter table local
  add constraint local_pk primary key (id),
  add constraint local_ciudad_fk foreign key (ciudad_id) references ciudad(id);
