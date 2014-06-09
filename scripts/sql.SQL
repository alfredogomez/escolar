-----------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[creabajas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[creabajas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE dbo.creabajas

	(
		@fua varchar(10)
	)

AS
       SET DATEFORMAT dmy
       if exists (select * from bescolar..sysobjects where id = object_id(N'[bajas]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
       drop table BESCOLAR..bajas
       
   CREATE TABLE BESCOLAR..bajas (
	[tabla] [char] (20) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[llave] [char] (20) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[fecha] [datetime] NOT NULL 
   ) ON [PRIMARY]

    insert BESCOLAR..bajas select * from ESCOLAR..bajas where ESCOLAR..bajas.fecha>@fua

	RETURN 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[creabitacora]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[creabitacora]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create  PROCEDURE dbo.creabitacora

	(
		@tabla varchar(10),
		@fua varchar(10)
	)

AS
      declare @sql varchar(255)
      declare @sql0 varchar(255)
      SET DATEFORMAT dmy
      select @sql0 = 'truncate table BESCOLAR..'+@tabla
      select @sql = ' insert BESCOLAR..'+@tabla+' select * from ESCOLAR..'+@tabla+' where ESCOLAR..'+@tabla+'.fua>'+@fua
      execute (@sql0+@sql)
	RETURN 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
--------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[bajas]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[bajas]
GO

CREATE TABLE [dbo].[bajas] (
	[tabla] [char] (20) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[llave] [char] (20) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[fecha] [datetime] NOT NULL 
) ON [PRIMARY]
GO
-----------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[transferir]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[transferir]
GO

CREATE TABLE [dbo].[transferir] (
	[tabla] [char] (20) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[regstransf] [int] NULL 
) ON [PRIMARY]
GO

-------------------
