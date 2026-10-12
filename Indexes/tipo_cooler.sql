-- Una marca puede tener un tipo por cada capacidad.
create unique index tipo_cooler_marca_capacidad_uk on tipo_cooler (lower(marca), capacidad);
