-- Baja un cooler de una ruta abierta: vuelve a quedar disponible. Uno que ya
-- se devolvió no se puede quitar, porque es parte de lo que pasó en la ruta.
create or replace function ruta_quitar_cooler(p_ruta_id int, p_cooler_id int)
returns void
language plpgsql as $$
declare
  v_estado estado_ruta;
  v_devuelto boolean;
begin
  select estado into v_estado from ruta where id = p_ruta_id for update;
  if not found then
    raise exception 'ruta_no_existe';
  end if;
  if v_estado not in ('en_espera', 'en_ejecucion') then
    raise exception 'ruta_cerrada';
  end if;

  delete from ruta_cooler
  where ruta_id = p_ruta_id and cooler_id = p_cooler_id
  returning devuelto into v_devuelto;
  if not found then
    raise exception 'cooler_no_esta_en_ruta';
  end if;
  if v_devuelto then
    raise exception 'cooler_ya_devuelto';
  end if;

  update cooler set estado = 'disponible' where id = p_cooler_id;
end;
$$;
