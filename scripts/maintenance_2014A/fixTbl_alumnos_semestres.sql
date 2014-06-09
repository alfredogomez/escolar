SELECT DISTINCT al_matric, MAX(or_semest) AS ord, MAX(al_semes) AS alu
--INTO #tabla
FROM alumnos
INNER JOIN ordinar ON or_matric = al_matric
WHERE al_estatus = '1'
AND or_ciclo = @ciclo
GROUP BY al_matric

DECLARE @matricula AS VARCHAR(10)
DECLARE @tblordina AS INT
DECLARE @tblalumno AS INT
DECLARE alumno CURSOR FOR
  SELECT al_matric, ord FROM #tabla
  WHERE ord <> alu
OPEN alumno
FETCH NEXT FROM alumno INTO @matricula, @tblordina
WHILE @@FETCH_STATUS = 0
BEGIN
  UPDATE alumnos
  SET al_semes = @tblordina
  WHERE al_matric = @matricula
  AND al_semes <> @tblordina
  FETCH NEXT FROM alumno INTO @matricula, @tblordina
END
CLOSE alumno
DEALLOCATE alumno

DROP TABLE #tabla