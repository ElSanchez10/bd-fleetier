alter table ruta_cooler
  add constraint ruta_cooler_pk primary key (ruta_id, cooler_id),
  add constraint ruta_cooler_devuelto check (devuelto = (devuelto_en is not null)),
  add constraint ruta_cooler_ruta_fk foreign key (ruta_id) references ruta(id),
  add constraint ruta_cooler_cooler_fk foreign key (cooler_id) references cooler(id);
