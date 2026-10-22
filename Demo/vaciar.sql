-- Deja la base como recién instalada: borra todo lo que se cargó (de prueba o
-- real) y vuelve los contadores de id a 1. El esquema y control.instalacion no
-- se tocan, así que no hay que reinstalar nada.
--
-- Se conservan los admin, para poder seguir entrando sin reiniciar el back
-- (sus sesiones sí se cierran). Los catálogos que trae la instalación
-- (Data/: tipos de conductor, de cooler y de evento) se vuelven a cargar tal
-- como vienen, por si se editaron.
--
-- Se ejecuta con `Demo/datos.sh vaciar`, que pide confirmación.

-- Primero lo que apunta a otras tablas, después lo apuntado.
delete from ruta_cooler;
delete from problema_ruta;
delete from ruta;
delete from atraso;
delete from caso_excepcional;
delete from pedido_especial;
delete from evento_conductor;
delete from cuenta_conductor;
delete from cooler;
delete from conductor;
delete from sesion;
delete from intento_ingreso;
delete from usuario where rol <> 'admin';
delete from local;
delete from ciudad;
delete from destino_pedido_especial;
delete from tipo_cooler;
delete from tipo_conductor;
delete from tipo_evento;

-- Contadores de id a 1 (salvo usuario, que conserva a los admin).
do $$
declare
  tabla text;
begin
  foreach tabla in array array[
    'problema_ruta', 'ruta', 'atraso', 'caso_excepcional', 'pedido_especial',
    'evento_conductor', 'cuenta_conductor', 'cooler', 'conductor', 'sesion',
    'local', 'ciudad', 'destino_pedido_especial', 'tipo_cooler',
    'tipo_conductor', 'tipo_evento'
  ] loop
    execute format('alter table %I alter column id restart with 1', tabla);
  end loop;
end
$$;

\ir ../Data/tipo_conductor.sql
\ir ../Data/tipo_cooler.sql
\ir ../Data/tipo_evento.sql
