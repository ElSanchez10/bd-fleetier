#!/bin/bash
# Instalador de la base: aplica, en orden, las instalaciones que aún no están
# registradas en control.instalacion, y después reinstala funciones y triggers. La conexión se toma de las variables
# estándar de psql (PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD).
set -euo pipefail
cd "$(dirname "$0")"

export PGOPTIONS="${PGOPTIONS:-} -c client_min_messages=warning"
PSQL=(psql -X -q -v ON_ERROR_STOP=1)

"${PSQL[@]}" -f control.sql

for dir in [0-9]*/; do
    nombre=${dir%/}
    if [[ ! $nombre =~ ^[0-9]{4}_[a-z0-9_]+$ ]]; then
        echo "ERROR: nombre de instalación inválido: $nombre (se espera NNNN_nombre)" >&2
        exit 1
    fi
    if [[ ! -f $nombre/instalar.sql ]]; then
        echo "ERROR: falta $nombre/instalar.sql" >&2
        exit 1
    fi

    aplicada=$("${PSQL[@]}" -At -c "select 1 from control.instalacion where nombre = '$nombre'")
    if [[ -n $aplicada ]]; then
        echo "== $nombre: ya aplicada"
        continue
    fi

    # Una sola transacción: si algo falla, la instalación completa se revierte
    # y no queda registrada.
    echo "== $nombre: aplicando"
    "${PSQL[@]}" --single-transaction \
        -f "$nombre/instalar.sql" \
        -c "insert into control.instalacion (nombre) values ('$nombre')"
done

# Funciones y triggers: se reinstalan en cada corrida, ya con todas las
# instalaciones aplicadas, así siempre calzan con el esquema vigente.
echo "== reaplicables"
"${PSQL[@]}" --single-transaction -f reaplicables.sql

echo "Instalación terminada."
