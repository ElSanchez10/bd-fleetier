alter table evento_conductor
  add constraint evento_conductor_pk primary key (id),
  add constraint evento_conductor_fechas check (hasta >= desde),
  add constraint evento_conductor_conductor_fk foreign key (conductor_id) references conductor(id),
  add constraint evento_conductor_tipo_evento_fk foreign key (tipo_evento_id) references tipo_evento(id);
