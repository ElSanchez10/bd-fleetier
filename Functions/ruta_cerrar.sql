-- Cierra una ruta en ejecución. Si volvieron todos sus coolers queda
-- finalizada; si no, pendiente, y los que faltan quedan pendientes hasta que
-- alguien los devuelva (cooler_devolver). Devuelve el estado en que quedó.
create or replace function ruta_cerrar(p_ruta_id int)
returns estado_ruta
language plpgsql as $$
declare
  v_estado estado_ruta;
begin
  select estado into v_estado from ruta where id = p_ruta_id for update;
  if not found then
    raise exception 'ruta_no_existe';
  end if;
  if v_estado <> 'en_ejecucion' then
    raise exception 'ruta_no_en_ejecucion';
  end if;

  update cooler set estado = 'pendiente'
  where id in (select cooler_id from ruta_cooler where ruta_id = p_ruta_id and not devuelto);

  v_estado := case when found then 'pendiente' else 'finalizada' end;
  update ruta set estado = v_estado where id = p_ruta_id;
  return v_estado;
end;
$$;
