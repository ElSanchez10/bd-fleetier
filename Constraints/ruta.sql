alter table ruta
  add constraint ruta_pk primary key (id),
  add constraint ruta_ordenes check (ordenes >= 0),
  -- Solo una ruta que no ha partido puede estar sin conductor.
  add constraint ruta_sin_conductor check (estado = 'en_espera' or conductor_id is not null),
  add constraint ruta_local_fk foreign key (local_id) references local(id),
  add constraint ruta_conductor_fk foreign key (conductor_id) references conductor(id);
