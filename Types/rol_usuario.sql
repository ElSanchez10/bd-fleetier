-- Qué puede hacer cada cuenta. Los permisos de cada rol los define el back.
--   admin        todo, incluidas las cuentas y la configuración
--   asistente    consulta la operación y administra a los conductores
--   encargado    opera las rutas y los coolers de su local
--   coordinador  opera las rutas; no crea coolers
create type rol_usuario as enum ('admin', 'asistente', 'encargado', 'coordinador');
