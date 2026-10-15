-- Credenciales del conductor en aplicaciones externas (las de reparto, por
-- ejemplo). La contraseña la cifra el back antes de guardarla: quien lea la
-- base o un respaldo no la ve.
create table cuenta_conductor (
  id             int         generated always as identity,
  conductor_id   int         not null,
  cuenta         text        not null,
  usuario        text        not null,
  clave_cifrada  text        not null,
  creado_en      timestamptz not null default now()
);
