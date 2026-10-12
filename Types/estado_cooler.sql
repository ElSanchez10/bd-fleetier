-- Dónde está un cooler. El orden es el que usa el listado.
--   disponible     en el local, listo para salir
--   en_espera      asignado a una ruta que todavía no parte
--   en_ruta        salió con una ruta y no ha vuelto
--   pendiente      su ruta terminó y el cooler no volvió
--   no_disponible  fuera de uso por ahora
--   danado         dañado
create type estado_cooler as enum (
  'disponible', 'en_espera', 'en_ruta', 'pendiente', 'no_disponible', 'danado'
);
