CREATE FUNCTION [dbo].[v_lnmaestro_1] (@ciclo VARCHAR(5))
RETURNS TABLE
AS
RETURN
SELECT	LTRIM(RTRIM(CAST(MATRICULA AS VARCHAR))) AS cveMaestro, 
		LTRIM(RTRIM(A_paterno))+ ' ' +LTRIM(RTRIM(a_materno)) + ' ' + LTRIM(RTRIM(nombre)) AS nomMaestro, 
		LTRIM(RTRIM(or_zona))+ ' - ' +LTRIM(RTRIM(or_plant)) + ' - ' + LTRIM(RTRIM(or_asigna)) + ' - ' + LTRIM(RTRIM(as_nombre)) AS asignatura , 
		CAST(or_grupo AS VARCHAR(3)) + 
		CASE CAST(or_turno AS VARCHAR(1))
			WHEN '1' THEN 'M'
			WHEN '2' THEN 'V'
			WHEN '3' THEN 'N'
		END AS Grupo,
		COUNT(DISTINCT(or_matric)) AS Alumnos, 
		or_zona AS Zona, 
		or_plant AS Plantel, 
		LTRIM(RTRIM(or_asigna)) AS Clave, 
		or_grupo AS Gpo, 
		or_turno AS Turno
FROM	ordinar
INNER JOIN	asignatura ON or_asigna = as_clave
LEFT OUTER JOIN	filia ON or_maest = Matricula
WHERE	or_matric IN (
			SELECT distinct ordinar.or_matric
			FROM ordinar
			INNER 
			JOIN alumnos ON al_matric = or_matric
			WHERE or_ciclo = @ciclo
			AND al_estatus = '1' )
AND		or_ciclo = @ciclo
AND		or_cali01 = ''
GROUP BY or_plant, or_asigna, or_grupo, or_turno, as_nombre, or_maest, a_paterno, a_materno, nombre, matricula, or_zona