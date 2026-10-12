-- Solo las cuentas que operan un local (encargado y coordinador) pueden estar
-- asociadas a uno. Admin y asistente ven siempre todos los locales.
alter table usuario
  add constraint usuario_local_segun_rol
  check (local_id is null or rol in ('encargado', 'coordinador'));
