CREATE TABLE padronIni
(
  pi_ciclo VARCHAR(5),
  pi_matric VARCHAR(10),
  pi_grupo VARCHAR(3),
  pi_semes INT,
  pi_turno INT,
  pi_capac INT
  CONSTRAINT pk_padronIniID PRIMARY KEY (pi_ciclo, pi_matric)
)