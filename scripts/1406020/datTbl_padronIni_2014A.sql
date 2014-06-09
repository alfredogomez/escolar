INSERT INTO padronIni
(pi_ciclo, pi_matric, pi_grupo, pi_semes, pi_turno, pi_capac)
SELECT 
  '2014A' AS pi_ciclo,
  al_matric AS pi_matric,
  al_grupo AS pi_grupo,
  al_semes AS pi_semes,
  al_turno AS pi_turno,
  al_cvecap AS pi_capac	   
FROM   alumnos
WHERE  al_matric IN (
	SELECT DISTINCT or_matric
    FROM   ordinar 
	INNER JOIN alumnos ON al_matric = or_matric
    WHERE  or_ciclo = '2014A') 
AND al_estatus <> '4'