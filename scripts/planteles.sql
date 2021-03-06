if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[planteles]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[planteles]
GO

CREATE TABLE [dbo].[planteles] (
	[pl_zona] [tinyint] NOT NULL ,
	[pl_num] [smallint] NOT NULL ,
	[pl_cvesep] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pl_nombre] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pl_direc] [char] (60) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pl_colonia] [int] NOT NULL ,
	[pl_localida] [int] NOT NULL ,
	[pl_municipi] [smallint] NOT NULL ,
	[pl_codpos] [int] NOT NULL ,
	[pl_telefo] [char] (15) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pl_direct] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pl_ce] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pl_folact] [int] NOT NULL ,
	[pl_adscri] [int] NOT NULL ,
	[pl_marca] [tinyint] NOT NULL ,
	[pl_depend] [smallint] NOT NULL ,
	[pla_emsad] [bit] NOT NULL ,
	[pl_extra1] [char] (30) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pl_extra2] [char] (30) COLLATE Modern_Spanish_CI_AS NOT NULL 
) ON [PRIMARY]
GO

