-- Días en que un conductor no está disponible o tiene algo anotado
-- (vacaciones, licencia…). Se muestran en su calendario.
create table evento_conductor (
  id              int         generated always as identity,
  conductor_id    int         not null,
  tipo_evento_id  int         not null,
  titulo          text        not null,
  descripcion     text        not null default '',
  -- Ambos días incluidos.
  desde           date        not null,
  hasta           date        not null,
  creado_en       timestamptz not null default now()
);
