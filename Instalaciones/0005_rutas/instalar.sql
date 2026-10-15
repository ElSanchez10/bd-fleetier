-- =====================================================================
-- Instalación 0005: rutas de reparto, los coolers que llevan y sus
-- problemas. Los cambios de estado los hacen las funciones ruta_* y
-- cooler_devolver (reaplicables.sql).
-- =====================================================================

-- Types
\ir ../../Types/estado_ruta.sql

-- Tables
\ir ../../Tables/ruta.sql
\ir ../../Tables/ruta_cooler.sql
\ir ../../Tables/problema_ruta.sql

-- Constraints
\ir ../../Constraints/ruta.sql
\ir ../../Constraints/ruta_cooler.sql
\ir ../../Constraints/problema_ruta.sql

-- Indexes
\ir ../../Indexes/ruta.sql
\ir ../../Indexes/ruta_cooler.sql
\ir ../../Indexes/problema_ruta.sql
