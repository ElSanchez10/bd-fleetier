-- Como en Laravel: encargado y coordinador operan un local, así que siempre
-- tienen uno (sin local verían todos, igual que un admin).
-- "not valid": no revisa las cuentas que ya existen, para que la instalación
-- no falle si alguna quedó sin local; esas se corrigen desde Usuarios, que ya
-- no deja guardarlas sin local.
alter table usuario
  add constraint usuario_local_requerido
  check (rol not in ('encargado', 'coordinador') or local_id is not null) not valid;
