#!/bin/bash
# Carga o borra los datos de prueba. Corre dentro de la imagen del instalador
# (servicio `datos` del docker-compose), con la conexión en las variables
# estándar de psql (PGHOST, PGDATABASE, PGUSER, PGPASSWORD).
#
#   datos.sh cargar          carga Demo/cargar.sql (solo sobre una base sin datos)
#   datos.sh vaciar <base>   deja la base como recién instalada; <base> es el
#                            nombre de la base, como confirmación
#
# Desde la carpeta del repo, en el servidor:
#   docker compose --env-file <archivo .env> run --rm --build datos cargar
#   docker compose --env-file <archivo .env> run --rm --build datos vaciar fleetier
set -euo pipefail
cd "$(dirname "$0")"

export PGOPTIONS="${PGOPTIONS:-} -c client_min_messages=warning"
PSQL=(psql -X -q -v ON_ERROR_STOP=1 --single-transaction)

case "${1:-}" in
  cargar)
    "${PSQL[@]}" -f cargar.sql
    echo "Datos de prueba cargados en $PGDATABASE."
    ;;
  vaciar)
    # Borra datos reales igual que los de prueba: se confirma escribiendo el
    # nombre de la base, para no hacerlo por error ni contra otra base.
    if [[ "${2:-}" != "$PGDATABASE" ]]; then
      echo "Para vaciar, confirma con el nombre de la base: datos.sh vaciar $PGDATABASE" >&2
      exit 1
    fi
    "${PSQL[@]}" -f vaciar.sql
    echo "Base $PGDATABASE vaciada: quedan el esquema, los catálogos de la instalación y los admin."
    ;;
  *)
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
    ;;
esac
