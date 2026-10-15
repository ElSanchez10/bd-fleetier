alter table conductor
  add constraint conductor_pk primary key (id),
  add constraint conductor_run_uk unique (run),
  add constraint conductor_run_formato check (run ~ '^[0-9]{7,8}-[0-9K]$'),
  add constraint conductor_telefono_formato check (telefono ~ '^[0-9]{9}$'),
  add constraint conductor_ciudad_fk foreign key (ciudad_id) references ciudad(id),
  add constraint conductor_tipo_conductor_fk foreign key (tipo_conductor_id) references tipo_conductor(id);
