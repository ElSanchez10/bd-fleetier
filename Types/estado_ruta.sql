-- En qué va una ruta. Solo lo cambian las funciones ruta_*.
--   en_espera     pre-cargada: tiene conductor o coolers, pero no ha partido
--   en_ejecucion  salió; sus coolers están en ruta
--   pendiente     se cerró con coolers que no han vuelto
--   finalizada    se cerró y volvieron todos sus coolers
create type estado_ruta as enum ('en_espera', 'en_ejecucion', 'pendiente', 'finalizada');
