alter table cuenta_conductor
  add constraint cuenta_conductor_pk primary key (id),
  add constraint cuenta_conductor_conductor_fk foreign key (conductor_id) references conductor(id);
