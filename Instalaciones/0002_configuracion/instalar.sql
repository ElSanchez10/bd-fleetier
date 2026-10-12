-- =====================================================================
-- Instalación 0002: lo que se administra en la pantalla Configuración.
-- Destinos de pedidos especiales, tipos de cooler, tipos de conductor y
-- tipos de evento, con sus datos iniciales. Además, la regla de qué roles
-- pueden tener un local asignado.
-- =====================================================================

-- Types
\ir ../../Types/color.sql
\ir ../../Types/capacidad_cooler.sql

-- Tables
\ir ../../Tables/destino_pedido_especial.sql
\ir ../../Tables/tipo_cooler.sql
\ir ../../Tables/tipo_conductor.sql
\ir ../../Tables/tipo_evento.sql

-- Constraints
\ir ../../Constraints/destino_pedido_especial.sql
\ir ../../Constraints/tipo_cooler.sql
\ir ../../Constraints/tipo_conductor.sql
\ir ../../Constraints/tipo_evento.sql

-- Indexes
\ir ../../Indexes/destino_pedido_especial.sql
\ir ../../Indexes/tipo_cooler.sql
\ir ../../Indexes/tipo_conductor.sql
\ir ../../Indexes/tipo_evento.sql

-- Novedades
\ir ../../Novedades/0002_usuario_local_segun_rol.sql

-- Data
\ir ../../Data/tipo_cooler.sql
\ir ../../Data/tipo_conductor.sql
\ir ../../Data/tipo_evento.sql
