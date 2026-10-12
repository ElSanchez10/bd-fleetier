-- Ingresos fallidos recientes por correo, para frenar a quien prueba
-- contraseñas. `desde` es el momento del primer fallo de la racha; el back
-- bloquea el correo al llegar al máximo y borra la fila al ingresar bien.
-- Se guarda también para correos que no tienen cuenta, así el bloqueo no
-- revela cuáles existen.
create table intento_ingreso (
  email   text        not null,
  fallos  int         not null default 1,
  desde   timestamptz not null default now()
);
