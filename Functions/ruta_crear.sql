-- Registra una ruta con sus coolers. Sin iniciar queda pre-cargada (en
-- espera): necesita al menos el conductor o un cooler. Para iniciarla de
-- inmediato se necesita el conductor. Devuelve el id de la ruta.
create or replace function ruta_crear(
  p_local_id int,
  p_conductor_id int,
  p_fecha timestamptz,
  p_ordenes int,
  p_coolers int[],
  p_iniciar boolean
)
returns int
language plpgsql as $$
declare
  v_id int;
begin
  if p_conductor_id is null and coalesce(cardinality(p_coolers), 0) = 0 then
    raise exception 'ruta_vacia';
  end if;

  insert into ruta (local_id, conductor_id, fecha, ordenes)
  values (p_local_id, p_conductor_id, p_fecha, p_ordenes)
  returning id into v_id;

  perform ruta_asignar_cooler(v_id, c) from (select distinct unnest(p_coolers) as c) coolers;
  if p_iniciar then
    perform ruta_iniciar(v_id);
  end if;
  return v_id;
end;
$$;
