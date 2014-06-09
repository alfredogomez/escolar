CREATE TABLE calendarAsueto
(
  cla_ciclo VARCHAR(5),
  cla_fecasueto VARCHAR(4)
  CONSTRAINT pk_asuetoID PRIMARY KEY (cla_ciclo, cla_fecasueto)
)