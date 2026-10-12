-- La cuenta con que se inicia sesión.
--   clave_hash          la contraseña cifrada por el back (nunca en texto plano)
--   debe_cambiar_clave  true mientras tenga la contraseña inicial: al entrar, la
--                       app le exige cambiarla antes de seguir. Vuelve a true
--                       cuando un admin le restablece la contraseña.
--   local_id            el local al que pertenece. Con un local, la cuenta solo
--                       ve y modifica lo de ese local; sin local (nulo), ve todos.
create table usuario (
  id                  int         generated always as identity,
  email               text        not null,
  nombre              text        not null,
  rol                 rol_usuario not null,
  local_id            int,
  clave_hash          text        not null,
  debe_cambiar_clave  boolean     not null default true,
  creado_en           timestamptz not null default now()
);
