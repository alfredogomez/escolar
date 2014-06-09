if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Alumbecad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Alumbecad]
GO

CREATE TABLE [dbo].[Alumbecad] (
	[be_matric] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[be_tipo] [tinyint] NOT NULL ,
	[be_ciclo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL 
) ON [PRIMARY]
GO

