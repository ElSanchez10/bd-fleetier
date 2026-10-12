-- Dos ciudades pueden tener un local con el mismo nombre; una misma ciudad, no.
create unique index local_nombre_uk on local (ciudad_id, lower(nombre));
