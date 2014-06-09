UPDATE alumnos
SET al_tipmodal = '2'
WHERE al_matric IN (
  SELECT al_matric
  FROM alumnos
  INNER JOIN planteles ON al_numplant = pl_num
  WHERE al_tipmodal <> '2'
  AND pla_emsad = 1
  AND al_estatus <> '8'
)

UPDATE alumnos
SET al_tipmodal = '1'
WHERE al_matric IN (
  SELECT al_matric
  FROM alumnos
  INNER JOIN planteles ON al_numplant = pl_num
  WHERE al_tipmodal <> '1'
  AND pla_emsad = 0
  AND al_estatus <> '8'
)