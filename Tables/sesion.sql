-- Sesiones iniciadas. El navegador guarda un token en una cookie; aquí queda
-- solo su huella (sha-256), así que leer esta tabla no permite suplantar a nadie.
-- Cerrar sesión, cambiar la contraseña o restablecerla borra las filas.
create table sesion (
  id          int         generated always as identity,
  usuario_id  int         not null,
  token_hash  text        not null,
  expira_en   timestamptz not null,
  creado_en   timestamptz not null default now()
);
