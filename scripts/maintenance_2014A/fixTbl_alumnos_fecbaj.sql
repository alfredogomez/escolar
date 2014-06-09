UPDATE alumnos
SET al_fecbaj = '1900-01-01 00:00:00'
WHERE al_estatus <> '3'
AND al_fecbaj <> '1900-01-01 00:00:00'