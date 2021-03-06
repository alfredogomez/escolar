if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[padres]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[padres]
GO

CREATE TABLE [dbo].[padres] (
	[pad_matric] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_padre] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_domic] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_colonia] [int] NOT NULL ,
	[pad_locali] [int] NOT NULL ,
	[pad_estado] [tinyint] NOT NULL ,
	[pad_ocupad] [tinyint] NOT NULL ,
	[pad_codpos] [int] NOT NULL ,
	[pad_telefo] [char] (15) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_emptra] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_domtra] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_loctra] [int] NOT NULL ,
	[pad_esttra] [tinyint] NOT NULL ,
	[pad_puesto] [char] (35) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_nivest] [tinyint] NOT NULL ,
	[pad_teltra] [char] (15) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_madre] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_mempresa] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_mdomtra] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_mpuesto] [char] (35) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pad_mloctra] [int] NOT NULL ,
	[pad_mnivest] [tinyint] NOT NULL ,
	[pad_mocup] [tinyint] NOT NULL ,
	[pad_mestra] [tinyint] NOT NULL ,
	[pad_mcodpos] [int] NOT NULL ,
	[pad_mteltra] [char] (15) COLLATE Modern_Spanish_CI_AS NOT NULL 
) ON [PRIMARY]
GO

