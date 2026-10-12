-- Registro de instalaciones aplicadas. Lo ejecuta instalar.sh en cada corrida.
create schema if not exists control;

create table if not exists control.instalacion (
  nombre          text        primary key,
  fecha_aplicada  timestamptz not null default now()
);
