-- El calendario pide los eventos de un conductor que tocan un rango de días.
create index evento_conductor_conductor_idx on evento_conductor (conductor_id, desde);
create index evento_conductor_tipo_evento_idx on evento_conductor (tipo_evento_id);
