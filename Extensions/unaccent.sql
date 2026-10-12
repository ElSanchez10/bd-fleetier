-- Quita tildes y diéresis de un texto. La usan las búsquedas por nombre del
-- back para que "concepcion" encuentre "Concepción".
create extension if not exists unaccent;
