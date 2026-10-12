-- =====================================================================
-- Instalación 0001: cuentas de usuario, sesiones, ciudades y locales.
-- Es lo mínimo para iniciar sesión; cada módulo de la app (coolers,
-- conductores, rutas…) agrega sus tablas en una instalación propia.
-- Convenciones: nombres en español, snake_case, tablas en singular,
-- claves primarias numéricas que la base asigna en orden (identity).
--
-- La ejecuta Instalaciones/instalar.sh, dentro de una transacción.
-- Las rutas de \ir son relativas a este archivo.
-- No trae usuarios: el primer admin lo crea el back al partir.
-- =====================================================================

-- Extensions
\ir ../../Extensions/unaccent.sql

-- Types
\ir ../../Types/rol_usuario.sql

-- Tables
\ir ../../Tables/ciudad.sql
\ir ../../Tables/local.sql
\ir ../../Tables/usuario.sql
\ir ../../Tables/sesion.sql
\ir ../../Tables/intento_ingreso.sql

-- Constraints (en orden de dependencia: cada FK necesita la PK que referencia)
\ir ../../Constraints/ciudad.sql
\ir ../../Constraints/local.sql
\ir ../../Constraints/usuario.sql
\ir ../../Constraints/sesion.sql
\ir ../../Constraints/intento_ingreso.sql

-- Indexes
\ir ../../Indexes/ciudad.sql
\ir ../../Indexes/local.sql
\ir ../../Indexes/usuario.sql
\ir ../../Indexes/sesion.sql

-- Las funciones y los triggers no se instalan aquí: ver ../reaplicables.sql
