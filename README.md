# bd-dsl

Base de datos (Postgres 16) de DSL. Todo cambio de esquema entra por una
instalación de este repositorio; nada se crea a mano.

## Estructura

| Carpeta | Contenido |
|---|---|
| `Extensions/` | extensiones de Postgres |
| `Types/` | tipos enumerados |
| `Tables/` | `create table`: columnas, `not null` y defaults |
| `Constraints/` | PK, FK, unique y checks, un archivo por tabla |
| `Indexes/` | índices, un archivo por tabla |
| `Data/` | datos iniciales |
| `Functions/` | funciones (`create or replace`); las instala `reaplicables.sql` |
| `Novedades/` | cambios sobre objetos ya instalados (`alter`, migración de datos) |
| `Instalaciones/` | scripts mayores y el instalador |

Carpetas que se crean cuando haga falta: `Triggers/` (`create or replace`) y
`Consultas/` (consultas de ejemplo; no se instalan).

### Rutas

Los estados de las rutas y de sus coolers solo los cambian las funciones de
`Functions/`: `ruta_crear`, `ruta_editar`, `ruta_asignar_cooler`,
`ruta_quitar_cooler`, `ruta_iniciar`, `ruta_cerrar` y `cooler_devolver`. Cada
una valida la regla que le toca y, si falla, lanza un error con un código
(`ruta_cerrada`, `cooler_no_disponible`…) que el back entrega al front. Dos
índices únicos parciales impiden que un conductor tenga dos rutas abiertas
(`ruta_conductor_ocupado`) y que un cooler esté en dos rutas sin devolver
(`ruta_cooler_ocupado`).

### Registros diarios

Junto con las rutas, en Actividad se anotan los pedidos especiales
(`pedido_especial`, a un destino de `destino_pedido_especial`), los atrasos de
órdenes (`atraso`, de despacho o de picking) y los casos excepcionales de un
conductor (`caso_excepcional`). Son registros sueltos, sin estados: la base solo
valida cantidades y referencias.

Convenciones: nombres en español, `snake_case` y tablas en singular.

Las claves primarias son números que la base asigna en orden
(`int generated always as identity`), no `uuid`: en esta app los números se le
muestran a la gente ("ruta 152", "cooler 37") y salen en las exportaciones.
Que se puedan adivinar no importa, porque toda la API exige sesión y valida
qué puede ver cada cuenta.

## Instalaciones

Cada carpeta `Instalaciones/NNNN_nombre/` tiene un `instalar.sql`: el script
mayor que ejecuta, con `\ir`, los scripts menores del resto del repositorio.

`Instalaciones/instalar.sh` hace dos cosas en cada corrida:

1. Recorre las instalaciones en orden y aplica solo las que no están
   registradas en la tabla `control.instalacion`. Cada una corre en una
   transacción: si un script falla, se revierte completa y no queda registrada.
2. Ejecuta `Instalaciones/reaplicables.sql`, que reinstala todas las funciones y
   triggers (`create or replace`).

Las funciones y los triggers no van dentro de las instalaciones porque su
archivo se edita en el tiempo: una instalación antigua terminaría instalando
una versión nueva de la función sobre un esquema que todavía no la soporta.
Reinstalándolos al final, siempre calzan con el esquema vigente.

Cada módulo de la app agrega sus tablas en una instalación propia. La `0001`
trae solo lo necesario para iniciar sesión: cuentas, sesiones, ciudades y
locales. No trae usuarios: el primer admin lo crea el back al partir.

### Agregar un cambio

1. Crear o editar los scripts menores:
   - Objeto nuevo (tabla, tipo, índice…): su archivo en `Tables/`, `Types/`,
     `Constraints/`, `Indexes/`, etc.
   - Cambio a una tabla ya instalada: un script en `Novedades/`
     (`Novedades/0005_cooler_observacion.sql`). El archivo original no se toca.
   - Función o trigger nuevo: su archivo, y una línea en `reaplicables.sql`.
   - Cambio a una función o trigger: se edita su mismo archivo y nada más.
2. Si hubo tablas, tipos, datos o novedades, crear
   `Instalaciones/NNNN_nombre/instalar.sql` con el número siguiente y listar los
   scripts en orden de dependencia.
3. Push a `main`: el servidor lo aplica.

Una instalación ya aplicada no se modifica: no se volvería a ejecutar.

## Despliegue

Jenkins ejecuta el `Jenkinsfile` en cada push a `main` (revisa el repo cada 5
minutos): levanta `db` y corre `migrar`, que aplica las instalaciones
pendientes. Si una instalación falla, el pipeline falla y la base queda como
estaba.

Configuración en Jenkins, una sola vez:

1. Credencial de tipo *Secret file* con id `dsl-env`: un archivo con las
   variables de `.env.example` de este repositorio y de `back-dsl`, con una
   clave larga en `DB_PASSWORD`. La usan los dos pipelines.
2. Job de tipo *Pipeline* → *Pipeline script from SCM* → este repositorio, rama
   `main`, script `Jenkinsfile`.

En un servidor sin Jenkins:

```bash
cp .env.example .env    # y definir DB_PASSWORD
docker compose up -d --wait db
docker compose run --rm --build migrar
```

La clave solo se usa al crear el volumen. Cambiarla después en el `.env` no
cambia la de la base: hay que cambiarla también con `alter user`.

Nunca usar `docker compose down -v`: borra el volumen con los datos.

### Conectar el back

El back se une a la red de este proyecto (`dsl_interna`) y usa `dsl-db` como
host. La base no está en la red `proxy`.

### Cliente SQL

El puerto de la base se publica donde diga `DB_PUBLICAR` en el `.env` del
servidor; sin esa variable solo responde en la propia máquina
(`127.0.0.1:5434`). En la caja de arena vale `10.8.0.1:5434`: se entra desde un
equipo conectado a la VPN. No responde desde la red local ni desde internet.

Consola SQL en el servidor:

```bash
docker exec -it dsl-db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
```

## Probar en local

`../local.sh base` crea una base temporal (puerto 55433) y le aplica las
instalaciones; `../local.sh borrar` la elimina. No toca la base desplegada.

## Respaldo

Pendiente: se agrega antes de cargar datos reales.
