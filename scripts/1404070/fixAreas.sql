update asignatura
set as_area = '7'
where as_clave in (
select distinct or_asigna from ordinar
where or_ciclo IN  ('2014A', '2013B')
GO

update asignatura
set as_area = '1'
where as_clave in ('8101', '8102', '8103', '8104', '8203', '8204', '8205', '9101', '9102')
GO

update asignatura
set as_area = '2'
where as_clave in ('8304', '8303', '8305', '8306', '8307', '9303')
GO

update asignatura
set as_area = '3'
where as_clave in ('8301', '8302', '8309', '8310', '8311', '8312')
GO

update asignatura
set as_area = '4'
where as_clave in ('8308', '8401', '8402', '8403', '8404', '8405', '8406', '9304')
GO

update asignatura
set as_area = '5'
where as_clave in ('8201', '8202', '8206', '8207', '8208', '9201', '9202')
GO

update asignatura
set as_area = '6'
where as_clave in ('8407', '8408', '8409', '8410')
GO