UPDATE alumnos
SET al_ciclo = '2013B'
WHERE al_matric IN (
  SELECT pi_matric FROM padronini
  WHERE pi_semes = '2'
)
AND al_ciclo <> '2013B'

UPDATE alumnos
SET al_ciclo = '2012B'
WHERE al_matric IN (
  SELECT pi_matric FROM padronini
  WHERE pi_semes = '4'
)
AND al_ciclo <> '2012B'

UPDATE alumnos
SET al_ciclo = '2011B'
WHERE al_matric IN (
  SELECT pi_matric FROM padronini
  WHERE pi_semes = '6'
)
AND al_ciclo <> '2011B'