--- ALUMNOS
CREATE TRIGGER alumnos_trigger1 On dbo.alumnos
FOR  UPDATE
AS
  UPDATE DBO.alumnos set fua=getdate() from dbo.alumnos a,inserted i 
	where a.al_matric=i.al_matric
go
CREATE TRIGGER alumnos_trigger2  ON dbo.alumnos
FOR  DELETE 
AS
   insert bajas select  'alumnos',al_matric,getdate()  from deleted
go
--- ORDINARIOS
CREATE TRIGGER ordinar_trigger1 On dbo.ordinar
FOR  UPDATE
AS
   UPDATE DBO.ordinar set fua=getdate() from dbo.ordinar a,inserted i 
	where a.or_matric=i.or_matric and a.or_asigna=i.or_asigna and a.or_semest=i.or_semest  
go

CREATE TRIGGER ordinar_trigger2  ON dbo.ordinar
FOR  DELETE 
AS
   insert bajas select  'ordinar',(OR_MATRIC+''+CONVERT(VARCHAR(4),OR_ASIGNA)+''+CONVERT(VARCHAR(1),OR_SEMEST)),getdate()  from deleted
go
--- PADRES
CREATE TRIGGER padres_trigger1 On dbo.padres
FOR  UPDATE
AS
   UPDATE DBO.padres set fua=getdate() from dbo.padres a,inserted i 
	where a.pad_matric=i.pad_matric 
go

CREATE TRIGGER padres_trigger2  ON dbo.padres
FOR  DELETE 
AS
   insert bajas select  'padres',pad_matric,getdate()  from deleted
go
--- EXTRAORDINARIOS
CREATE TRIGGER extraord_trigger1 On dbo.extraord
FOR  UPDATE
AS
   UPDATE DBO.extraord set fua=getdate() from dbo.extraord a,inserted i 
	where a.ex_matric=i.ex_matric and a.ex_asigna=i.ex_asigna and a.ex_semest=i.ex_semest  and a.ex_tipext=i.ex_tipext
go
CREATE TRIGGER extraord_trigger2  ON dbo.extraord
FOR  DELETE 
AS
   insert bajas select  'extraord',(ex_MATRIC+''+CONVERT(VARCHAR(4),ex_ASIGNA)+''+CONVERT(VARCHAR(1),ex_SEMEST)),getdate()  from deleted
go
--- SEGACAD
CREATE TRIGGER segacad_trigger1 On dbo.segacad
FOR  UPDATE
AS
   UPDATE DBO.segacad set fua=getdate() from dbo.segacad a,inserted i 
	where a.sa_zona=i.sa_zona and a.sa_plant=i.sa_plant and a.sa_sem=i.sa_sem and a.sa_asigna=i.sa_asigna
go

CREATE TRIGGER segacad_trigger2  ON dbo.segacad
FOR  DELETE 
AS
   insert bajas select  'segacad',(sa_zona+convert (varchar(3),sa_plant)+convert(VARCHAR(4),sa_ASIGNA)+convert(VARCHAR(1),sa_SEM)),getdate()  from deleted
go





