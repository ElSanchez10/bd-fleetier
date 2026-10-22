-- Datos de prueba para ver la app con algo adentro: ciudades, locales,
-- usuarios, conductores, coolers, rutas de hoy y de las dos semanas pasadas, y
-- algunos registros diarios. No es una instalación: se carga a mano con
-- `Demo/datos.sh cargar` y se borra con `Demo/datos.sh vaciar`.
--
-- Las fechas se calculan desde hoy (hora de Chile), así que el inicio siempre
-- muestra rutas del día. Los estados de rutas y coolers siguen las mismas
-- reglas que aplica el back (OperacionesService):
--   ruta en_espera    → sus coolers en_espera
--   ruta en_ejecucion → sus coolers sin devolver en_ruta
--   ruta pendiente    → quedó algún cooler sin devolver, que queda pendiente
--   ruta finalizada   → todos devueltos; los devueltos quedan disponibles
--
-- Usuarios de prueba (además del admin que crea el back con ADMIN_CORREO),
-- todos con la contraseña `fleetier-demo-2026` y sin obligación de cambiarla:
--   asistente@fleetier.cl              asistente
--   encargado.providencia@fleetier.cl  encargado de Providencia
--   coordinador.maipu@fleetier.cl      coordinador de Maipú
--
-- Las cuentas de los conductores (cuenta_conductor) no se cargan: van cifradas
-- con CLAVE_CUENTAS, que la base no conoce. Se crean desde la app.

do $$
declare
  zona constant text := 'America/Santiago';
  hoy  constant date := (now() at time zone 'America/Santiago')::date;
  clave constant text :=
    'scrypt$fHkYnvxZHSnL3_uWRwmVkg$crOtssSsEgNqFk89iiSViwwQ7BmGRecEjWfWsI3PMqVdLFg05HBa5ecNFCUs_0vVT4jC-tOt6omG_IPJzq7WAA';
  santiago int; valparaiso int; concepcion int;
  providencia int; maipu int; vina int; conce int;
  conductores int[];
  locales int[];
  ruta_id int;
  c1 int; c2 int;
  dia int;
  i int;
begin
  -- Solo sobre una base sin datos propios: así no se duplica nada si se corre
  -- dos veces. Para volver a cargar, primero `vaciar`.
  if exists (select 1 from ciudad) or exists (select 1 from conductor)
     or exists (select 1 from cooler) or exists (select 1 from ruta) then
    raise exception 'La base ya tiene datos: primero hay que vaciarla (Demo/datos.sh vaciar).';
  end if;

  -- --- Configuración ---

  insert into ciudad (nombre) values ('Santiago') returning id into santiago;
  insert into ciudad (nombre) values ('Valparaíso') returning id into valparaiso;
  insert into ciudad (nombre) values ('Concepción') returning id into concepcion;

  insert into local (ciudad_id, nombre, direccion)
    values (santiago, 'Providencia', 'Av. Providencia 1234') returning id into providencia;
  insert into local (ciudad_id, nombre, direccion)
    values (santiago, 'Maipú', 'Av. Pajaritos 3050') returning id into maipu;
  insert into local (ciudad_id, nombre, direccion)
    values (valparaiso, 'Viña del Mar', 'Av. Libertad 890') returning id into vina;
  insert into local (ciudad_id, nombre, direccion)
    values (concepcion, 'Concepción Centro', 'Barros Arana 456') returning id into conce;
  locales := array[providencia, maipu, vina, conce];

  insert into tipo_cooler (marca, capacidad, color) values ('Igloo', 'pequeno', 'azul');

  insert into destino_pedido_especial (nombre, precio_base) values
    ('Rancagua', 25000),
    ('San Antonio', 30000),
    ('Talca', 40000);

  -- --- Usuarios ---

  insert into usuario (email, nombre, rol, local_id, clave_hash, debe_cambiar_clave) values
    ('asistente@fleetier.cl', 'Andrea Asistente', 'asistente', null, clave, false),
    ('encargado.providencia@fleetier.cl', 'Esteban Encargado', 'encargado', providencia, clave, false),
    ('coordinador.maipu@fleetier.cl', 'Carla Coordinadora', 'coordinador', maipu, clave, false);

  -- --- Conductores ---

  insert into conductor (nombre, run, fecha_nacimiento, telefono, email, ciudad_id, tipo_conductor_id)
  select c.nombre, c.run, c.nacimiento, c.telefono, c.email, c.ciudad,
         (select id from tipo_conductor where nombre = c.tipo)
  from (values
    ('Juan Pérez',      '15234871-1', date '1983-04-12', '912345678', 'juan.perez@correo.cl',      santiago,   'Auto'),
    ('María González',  '16987452-2', date '1987-09-30', '923456789', 'maria.gonzalez@correo.cl',  santiago,   'Camión'),
    ('Pedro Soto',      '17456329-2', date '1989-01-05', '934567891', 'pedro.soto@correo.cl',      santiago,   'Auto'),
    ('Camila Rojas',    '18321765-8', date '1992-06-18', '945678912', 'camila.rojas@correo.cl',    santiago,   'Auto'),
    ('Diego Muñoz',     '19876543-0', date '1996-11-22', '956789123', 'diego.munoz@correo.cl',     valparaiso, 'Camión'),
    ('Valentina Díaz',  '20145876-5', date '1999-03-14', '967891234', 'valentina.diaz@correo.cl',  valparaiso, 'Auto'),
    ('Jorge Fuentes',   '12765432-8', date '1975-08-02', '978912345', 'jorge.fuentes@correo.cl',   concepcion, 'Camión'),
    ('Fernanda Silva',  '21543987-9', date '2001-12-09', '989123456', 'fernanda.silva@correo.cl',  concepcion, 'Auto')
  ) as c(nombre, run, nacimiento, telefono, email, ciudad, tipo);
  select array_agg(id order by id) into conductores from conductor;

  insert into evento_conductor (conductor_id, tipo_evento_id, titulo, descripcion, desde, hasta) values
    (conductores[7], (select id from tipo_evento where nombre = 'Vacaciones'),
     'Vacaciones de verano', 'Vuelve el lunes siguiente.', hoy - 2, hoy + 5),
    (conductores[8], (select id from tipo_evento where nombre = 'Licencia'),
     'Licencia médica', '', hoy - 1, hoy + 1),
    (conductores[6], (select id from tipo_evento where nombre = 'Libre'),
     'Día libre', '', hoy + 3, hoy + 3);

  -- --- Coolers: seis por local, con códigos fijos de ocho dígitos ---

  for i in 1 .. array_length(locales, 1) loop
    insert into cooler (nombre, codigo, fecha_adquisicion, tiene_tapa, tipo_cooler_id, local_id)
    select n::text,
           lpad((10000000 * i + 1000 * n + 17 * n * i)::text, 8, '0'),
           hoy - (30 * n + 7 * i),
           n % 3 <> 0,
           (select id from tipo_cooler order by id offset (n % 3) limit 1),
           locales[i]
    from generate_series(1, 6) as n;
  end loop;

  -- Algunos fuera de uso.
  update cooler set estado = 'danado'
   where local_id = maipu and nombre = '6';
  update cooler set estado = 'no_disponible'
   where local_id = conce and nombre = '5';

  -- --- Historial: rutas finalizadas de los últimos 14 días ---

  for dia in 1 .. 14 loop
    for i in 1 .. array_length(locales, 1) loop
      continue when (dia + i) % 3 = 0;   -- no todos los locales salen todos los días
      insert into ruta (local_id, conductor_id, fecha, ordenes, estado)
      values (locales[i], conductores[1 + (dia + i) % 8],
              ((hoy - dia) + time '09:00' + (i * interval '30 minutes')) at time zone zona,
              10 + (dia * 7 + i * 3) % 25, 'finalizada')
      returning id into ruta_id;
      insert into ruta_cooler (ruta_id, cooler_id, devuelto, devuelto_en)
      select ruta_id, k.id, true,
             ((hoy - dia) + time '17:30' + (k.n * interval '10 minutes')) at time zone zona
      from (select id, row_number() over (order by id) as n
              from cooler
             where local_id = locales[i] and estado = 'disponible'
             order by id offset (dia % 3) limit 2) as k;
    end loop;
  end loop;

  -- Ayer en Viña: una ruta que quedó pendiente, con un cooler sin devolver.
  insert into ruta (local_id, conductor_id, fecha, ordenes, estado)
  values (vina, conductores[5], ((hoy - 1) + time '10:15') at time zone zona, 22, 'pendiente')
  returning id into ruta_id;
  select id into c1 from cooler where local_id = vina and nombre = '1';
  select id into c2 from cooler where local_id = vina and nombre = '2';
  insert into ruta_cooler (ruta_id, cooler_id, devuelto, devuelto_en) values
    (ruta_id, c1, true, ((hoy - 1) + time '18:05') at time zone zona),
    (ruta_id, c2, false, null);
  update cooler set estado = 'pendiente' where id = c2;
  insert into problema_ruta (ruta_id, cantidad, descripcion)
  values (ruta_id, 2, 'Dos pedidos con dirección incorrecta.');

  -- --- Hoy ---

  -- Providencia: una en ejecución (un cooler ya devuelto), una en espera con
  -- conductor y coolers, y una en espera sin conductor todavía.
  insert into ruta (local_id, conductor_id, fecha, ordenes, estado)
  values (providencia, conductores[1], (hoy + time '08:30') at time zone zona, 18, 'en_ejecucion')
  returning id into ruta_id;
  insert into ruta_cooler (ruta_id, cooler_id, devuelto, devuelto_en)
  select ruta_id, id, nombre = '1',
         case when nombre = '1' then (hoy + time '11:40') at time zone zona end
  from cooler where local_id = providencia and nombre in ('1', '2', '3');
  update cooler set estado = 'en_ruta'
   where local_id = providencia and nombre in ('2', '3');
  insert into problema_ruta (ruta_id, cantidad, descripcion)
  values (ruta_id, 1, 'Cliente no estaba en el domicilio.');

  insert into ruta (local_id, conductor_id, fecha, ordenes, estado)
  values (providencia, conductores[2], (hoy + time '13:00') at time zone zona, 12, 'en_espera')
  returning id into ruta_id;
  insert into ruta_cooler (ruta_id, cooler_id)
  select ruta_id, id from cooler where local_id = providencia and nombre in ('4', '5');
  update cooler set estado = 'en_espera'
   where local_id = providencia and nombre in ('4', '5');

  insert into ruta (local_id, conductor_id, fecha, ordenes, estado)
  values (providencia, null, (hoy + time '16:00') at time zone zona, 8, 'en_espera');

  -- Maipú: una en ejecución con dos coolers en ruta.
  insert into ruta (local_id, conductor_id, fecha, ordenes, estado)
  values (maipu, conductores[3], (hoy + time '09:00') at time zone zona, 20, 'en_ejecucion')
  returning id into ruta_id;
  insert into ruta_cooler (ruta_id, cooler_id)
  select ruta_id, id from cooler where local_id = maipu and nombre in ('1', '2');
  update cooler set estado = 'en_ruta'
   where local_id = maipu and nombre in ('1', '2');

  -- --- Registros diarios ---

  insert into atraso (local_id, tipo, fecha, cantidad) values
    (providencia, 'despacho', hoy - 1, 3),
    (providencia, 'picking',  hoy - 2, 5),
    (maipu,       'despacho', hoy - 3, 2),
    (vina,        'picking',  hoy - 1, 4),
    (conce,       'despacho', hoy - 5, 1);

  insert into caso_excepcional (local_id, conductor_id, fecha, descripcion) values
    (providencia, conductores[1], hoy - 2, 'Retiro fuera de horario por pedido urgente.'),
    (vina,        conductores[5], hoy - 4, 'Cambio de vehículo por falla mecánica.');

  insert into pedido_especial (local_id, destino_id, fecha, cantidad, precio, extraordinario, descripcion)
  select p.local, (select id from destino_pedido_especial where nombre = p.destino),
         p.fecha, p.cantidad, p.precio, p.extra, p.descripcion
  from (values
    (providencia, 'Rancagua',    hoy - 1, 3, 75000,  false, ''),
    (maipu,       'San Antonio', hoy - 3, 1, 45000,  true,  'Entrega el mismo día.'),
    (conce,       'Talca',       hoy - 6, 2, 80000,  false, '')
  ) as p(local, destino, fecha, cantidad, precio, extra, descripcion);
end
$$;
