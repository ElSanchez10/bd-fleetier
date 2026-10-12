create unique index usuario_email_uk on usuario (lower(email));
create index usuario_local_idx on usuario (local_id);
