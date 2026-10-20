-- Desde dónde se abrió cada sesión y cuándo se usó por última vez, para
-- mostrarlas en "Administrar Cuenta" (como las "Sesiones del Navegador" de la
-- versión Laravel). `navegador` es el User-Agent tal como llegó.
alter table sesion
  add column navegador        text,
  add column ip               text,
  add column ultima_actividad timestamptz not null default now();
