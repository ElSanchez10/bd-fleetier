-- =====================================================================
-- Objetos reaplicables: funciones y triggers.
-- instalar.sh ejecuta este script en CADA corrida, después de las
-- instalaciones pendientes. Todo lo de aquí debe poder ejecutarse muchas
-- veces (create or replace) y se edita en su mismo archivo.
-- El orden importa: primero las funciones, después los triggers que las usan.
-- =====================================================================

-- Functions
-- Las de rutas: primero las que usan las demás.
\ir ../Functions/ruta_asignar_cooler.sql
\ir ../Functions/ruta_quitar_cooler.sql
\ir ../Functions/ruta_iniciar.sql
\ir ../Functions/ruta_cerrar.sql
\ir ../Functions/cooler_devolver.sql
\ir ../Functions/ruta_crear.sql
\ir ../Functions/ruta_editar.sql

-- Triggers
-- (todavía no hay)
