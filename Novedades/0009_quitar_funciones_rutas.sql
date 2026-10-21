-- Las reglas de las rutas y sus coolers pasan al back (OperacionesService):
-- la base se queda con lo que asegura los datos (llaves, checks e índices
-- únicos), no con la lógica del negocio.
drop function if exists ruta_crear(int, int, timestamptz, int, int[], boolean);
drop function if exists ruta_editar(int, int, int, timestamptz, int, int[]);
drop function if exists ruta_iniciar(int);
drop function if exists ruta_cerrar(int);
drop function if exists ruta_asignar_cooler(int, int);
drop function if exists ruta_quitar_cooler(int, int);
drop function if exists cooler_devolver(int);
drop function if exists cooler_liberar(int, estado_cooler);
