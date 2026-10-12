-- Sesiones iniciadas. El navegador guarda un token en una cookie; aquí queda
-- solo su huella (sha-256), así que leer esta tabla no permite suplantar a nadie.
-- Cerrar sesión, cambiar la contraseña o restablecerla borra las filas.
create table sesion (
  id          uuid        not null default gen_random_uuid(),
  usuario_id  uuid        not null,
  token_hash  text        not null,
  expira_en   timestamptz not null,
  creado_en   timestamptz not null default now()
);
