alter table sesion
  add constraint sesion_pk primary key (id),
  add constraint sesion_token_uk unique (token_hash),
  add constraint sesion_usuario_fk foreign key (usuario_id) references usuario(id) on delete cascade;
