-- Sube un cooler a una ruta abierta. El cooler debe estar disponible y ser del
-- local de la ruta. Queda en espera o en ruta, según si la ruta ya partió.
create or replace function ruta_asignar_cooler(p_ruta_id int, p_cooler_id int)
returns void
language plpgsql as $$
declare
  v_ruta ruta;
  v_cooler cooler;
begin
  select * into v_ruta from ruta where id = p_ruta_id for update;
  if not found then
    raise exception 'ruta_no_existe';
  end if;
  if v_ruta.estado not in ('en_espera', 'en_ejecucion') then
    raise exception 'ruta_cerrada';
  end if;

  select * into v_cooler from cooler where id = p_cooler_id for update;
  if not found then
    raise exception 'cooler_no_existe';
  end if;
  if v_cooler.local_id <> v_ruta.local_id then
    raise exception 'cooler_de_otro_local';
  end if;
  if v_cooler.estado <> 'disponible' then
    raise exception 'cooler_no_disponible';
  end if;

  insert into ruta_cooler (ruta_id, cooler_id) values (p_ruta_id, p_cooler_id);
  update cooler
  set estado = case when v_ruta.estado = 'en_espera' then 'en_espera' else 'en_ruta' end::estado_cooler
  where id = p_cooler_id;
end;
$$;
