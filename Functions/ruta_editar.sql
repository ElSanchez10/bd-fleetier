-- Corrige los datos de una ruta y deja sus coolers como dice p_coolers: quita
-- los que no están y sube los nuevos. Los coolers solo cambian mientras la
-- ruta está abierta, y el local solo mientras no ha partido (sus coolers son
-- de ese local). Quién puede editar una ruta cerrada lo decide el back.
create or replace function ruta_editar(
  p_ruta_id int,
  p_local_id int,
  p_conductor_id int,
  p_fecha timestamptz,
  p_ordenes int,
  p_coolers int[]
)
returns void
language plpgsql as $$
declare
  v_ruta ruta;
begin
  select * into v_ruta from ruta where id = p_ruta_id for update;
  if not found then
    raise exception 'ruta_no_existe';
  end if;
  if p_local_id <> v_ruta.local_id and v_ruta.estado <> 'en_espera' then
    raise exception 'ruta_local_fijo';
  end if;

  -- Primero se quitan (liberan coolers del local anterior), después se cambia
  -- el local y al final se suben los nuevos, que se validan contra él.
  perform ruta_quitar_cooler(p_ruta_id, rc.cooler_id)
  from ruta_cooler rc
  where rc.ruta_id = p_ruta_id and rc.cooler_id <> all (p_coolers);

  update ruta
  set local_id = p_local_id, conductor_id = p_conductor_id, fecha = p_fecha, ordenes = p_ordenes
  where id = p_ruta_id;

  perform ruta_asignar_cooler(p_ruta_id, c)
  from (select distinct unnest(p_coolers) as c) nuevos
  where c not in (select cooler_id from ruta_cooler where ruta_id = p_ruta_id);

  if p_conductor_id is null
     and not exists (select 1 from ruta_cooler where ruta_id = p_ruta_id) then
    raise exception 'ruta_vacia';
  end if;
end;
$$;
