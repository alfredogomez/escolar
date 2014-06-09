UPDATE alumnos
SET al_cvecap = '0'
WHERE al_semes IN ('1', '2')
AND al_cvecap <> '0'

SELECT distinct al_matric, al_cvecap AS capAlu, as_capac AS capAsi
into #tabla
from alumnos
inner join ordinar on al_matric = or_matric
inner join asignatura on or_asigna = as_clave
where or_ciclo = '2014A'
and as_capac <> '0'
and al_estatus = '1'
order by al_matric

DECLARE @matricula AS VARCHAR(10)
DECLARE @tblasigna AS INT
DECLARE alumno CURSOR FOR
  SELECT al_matric, capAsi FROM #tabla
  WHERE capAlu <> capAsi
OPEN alumno
FETCH NEXT FROM alumno INTO @matricula, @tblasigna
WHILE @@FETCH_STATUS = 0
BEGIN
  UPDATE alumnos
  SET al_cvecap = @tblasigna
  WHERE al_matric = @matricula
  FETCH NEXT FROM alumno INTO @matricula, @tblasigna
END
CLOSE alumno
DEALLOCATE alumno

DROP TABLE #tabla