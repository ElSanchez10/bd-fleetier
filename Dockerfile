# Imagen que aplica las instalaciones pendientes. Misma versión que el servicio db.
FROM postgres:16
COPY . /bd
ENTRYPOINT ["/bd/Instalaciones/instalar.sh"]
