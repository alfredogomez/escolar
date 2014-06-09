SELECT DISTINCT 
  LTRIM(RTRIM(filia.a_paterno))+' '+LTRIM(RTRIM(filia.a_materno))+' '+LTRIM(RTRIM(filia.nombre)) AS Maestro, 
  or_maest AS M_Incorrecta, 
  filia2.matricula AS M_Correcta
FROM ordinar
INNER JOIN filia ON or_maest = filia.Matricula
LEFT OUTER JOIN filia2 ON filia2.NOMBRE = LTRIM(RTRIM(filia.a_paterno))+' '+LTRIM(RTRIM(filia.a_materno))+' '+LTRIM(RTRIM(filia.nombre))
WHERE filia2.matricula <> filia.matricula