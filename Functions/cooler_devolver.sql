-- Un cooler volvió al local (lo leyó la pistola). Se marca devuelto en la ruta
-- que lo tenía, en ejecución o pendiente, y queda disponible. Si era el último
-- que le faltaba a una ruta pendiente, la ruta queda finalizada.
-- Devuelve el id de esa ruta.
create or replace function cooler_devolver(p_cooler_id int)
returns int
language plpgsql as $$
declare
  v_ruta_id int;
  v_estado estado_ruta;
begin
  select r.id, r.estado into v_ruta_id, v_estado
  from ruta_cooler rc
  join ruta r on r.id = rc.ruta_id
  where rc.cooler_id = p_cooler_id
    and not rc.devuelto
    and r.estado in ('en_ejecucion', 'pendiente')
  for update of r, rc;
  if not found then
    raise exception 'cooler_sin_ruta';
  end if;

  update ruta_cooler set devuelto = true, devuelto_en = now()
  where ruta_id = v_ruta_id and cooler_id = p_cooler_id;
  update cooler set estado = 'disponible' where id = p_cooler_id;

  if v_estado = 'pendiente'
     and not exists (select 1 from ruta_cooler where ruta_id = v_ruta_id and not devuelto) then
    update ruta set estado = 'finalizada' where id = v_ruta_id;
  end if;
  return v_ruta_id;
end;
$$;
