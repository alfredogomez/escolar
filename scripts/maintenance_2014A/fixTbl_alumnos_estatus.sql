UPDATE alumnos
SET al_fecbaj = '2014-01-01'
WHERE al_matric NOT IN (SELECT pi_matric FROM padronini)
AND al_estatus = '1'

UPDATE alumnos
SET al_estatus = '3'
WHERE al_matric NOT IN (SELECT pi_matric FROM padronini)
AND al_estatus = '1'