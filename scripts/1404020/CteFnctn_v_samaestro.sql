CREATE FUNCTION [dbo].[v_samaestro] (@ciclo VARCHAR(5), @tipexa VARCHAR(1))
RETURNS TABLE
AS
RETURN
select	
CAST(sa_cvemae AS VARCHAR) AS cveMaestro, 
LTRIM(RTRIM(filia.a_paterno)) + ' ' + LTRIM(RTRIM(filia.a_materno)) + ' ' + LTRIM(RTRIM(filia.nombre)) AS nomMaestro, 
CAST(sa_plant AS VARCHAR(3)) + ' - ' + CAST(sa_asigna AS VARCHAR(4)) + ' - ' + LTRIM(RTRIM(as_nombre)) AS asignatura, 
CAST(sa_grupo AS VARCHAR(3)) + 
CASE CAST(sa_turno AS VARCHAR(1))
  WHEN '1' THEN 'M'
  WHEN '2' THEN 'V'
  WHEN '3' THEN 'N'
END AS Grupo, 
AVG(sa_iapro) AS iapro, AVG(sa_fapro) AS fapro, 
SUM(sa_nrep) AS nrep, SUM(sa_nap) AS nap, 
CASE @tipexa
  WHEN '1' THEN
	(select ROUND(STDEV(CAST(ordinar.or_cali01 AS INT)),4)
	 from ordinar
	 where or_asigna = sa_asigna AND or_grupo = sa_grupo AND or_turno = sa_turno AND or_plant = sa_plant AND or_ciclo = @ciclo)
  WHEN '2' THEN
	(select ROUND(STDEV(CAST(ordinar.or_cali02 AS INT)),4)
	 from ordinar
	 where or_asigna = sa_asigna AND or_grupo = sa_grupo AND or_turno = sa_turno AND or_plant = sa_plant AND or_ciclo = @ciclo)
  WHEN '3' THEN
	(select ROUND(STDEV(CAST(ordinar.or_cali03 AS INT)),4)
	 from ordinar
	 where or_asigna = sa_asigna AND or_grupo = sa_grupo AND or_turno = sa_turno AND or_plant = sa_plant AND or_ciclo = @ciclo)
  WHEN '6' THEN
	(select ROUND(STDEV(CAST(ordinar.or_calsem AS INT)),4)
	 from ordinar
	 where or_asigna = sa_asigna AND or_grupo = sa_grupo AND or_turno = sa_turno AND or_plant = sa_plant AND or_ciclo = @ciclo)
END AS sigma, 
sa_plant, sa_zona, as_capac, sa_cvemae
from segacad
inner join asignatura on sa_asigna = as_clave
INNER JOIN filia on filia.matricula = sa_cvemae
where sa_semes = @ciclo
and sa_tipexa = @tipexa
GROUP BY sa_cvemae, sa_plant, sa_zona, sa_asigna, sa_grupo, sa_turno, as_nombre, filia.a_paterno, filia.a_materno, filia.nombre, as_capac