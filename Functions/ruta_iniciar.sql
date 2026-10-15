-- La ruta parte: necesita conductor, y sus coolers pasan a estar en ruta.
create or replace function ruta_iniciar(p_ruta_id int)
returns void
language plpgsql as $$
declare
  v_ruta ruta;
begin
  select * into v_ruta from ruta where id = p_ruta_id for update;
  if not found then
    raise exception 'ruta_no_existe';
  end if;
  if v_ruta.estado <> 'en_espera' then
    raise exception 'ruta_ya_iniciada';
  end if;
  if v_ruta.conductor_id is null then
    raise exception 'ruta_sin_conductor';
  end if;

  update ruta set estado = 'en_ejecucion' where id = p_ruta_id;
  update cooler set estado = 'en_ruta'
  where id in (select cooler_id from ruta_cooler where ruta_id = p_ruta_id and not devuelto);
end;
$$;
