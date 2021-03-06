if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LibRegis]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LibRegis]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LibroParcial]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[LibroParcial]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PerioExamen]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PerioExamen]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Prein2006]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Prein2006]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ResOficinas]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ResOficinas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[foliregi]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[foliregi]
GO

CREATE TABLE [dbo].[LibRegis] (
	[lr_noreg] [int] NOT NULL ,
	[lr_folcert] [int] NOT NULL ,
	[lr_zona] [tinyint] NOT NULL ,
	[lr_plantel] [tinyint] NOT NULL ,
	[lr_matric] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[lr_nombre] [char] (60) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[lr_genera] [char] (9) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[lr_fecela] [datetime] NOT NULL ,
	[lr_feccon] [datetime] NOT NULL ,
	[lr_libreg] [int] NOT NULL ,
	[lr_numfoj] [int] NOT NULL ,
	[lr_estatus] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[LibroParcial] (
	[lp_noreg] [int] NOT NULL ,
	[lp_folcert] [int] NOT NULL ,
	[lp_zona] [tinyint] NOT NULL ,
	[lp_plantel] [tinyint] NOT NULL ,
	[lp_matric] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[lp_nombre] [char] (60) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[lp_genera] [char] (9) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[lp_fecela] [datetime] NOT NULL ,
	[lp_feccon] [datetime] NOT NULL ,
	[lp_libreg] [int] NOT NULL ,
	[lp_numfoj] [int] NOT NULL ,
	[lp_estatus] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PerioExamen] (
	[pe_ciclo] [char] (5) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[pe_tipo] [tinyint] NOT NULL ,
	[pe_semes] [tinyint] NOT NULL ,
	[pe_fecini] [smalldatetime] NOT NULL ,
	[pe_fecfin] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Prein2006] (
	[al_matric] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_nombre] [char] (30) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_apaterno] [char] (30) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_amaterno] [char] (30) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_zona] [tinyint] NOT NULL ,
	[al_numplant] [smallint] NOT NULL ,
	[al_grupo] [smallint] NOT NULL ,
	[al_turno] [tinyint] NOT NULL ,
	[al_direcc] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_coloni] [int] NOT NULL ,
	[al_locali] [int] NOT NULL ,
	[al_estado] [tinyint] NOT NULL ,
	[al_codpos] [int] NOT NULL ,
	[al_telefono] [char] (15) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_sexo] [tinyint] NOT NULL ,
	[al_estciv] [tinyint] NOT NULL ,
	[al_nacion] [tinyint] NOT NULL ,
	[al_ocupac] [tinyint] NOT NULL ,
	[al_fecnac] [smalldatetime] NOT NULL ,
	[al_escpro] [smallint] NOT NULL ,
	[al_promed] [real] NOT NULL ,
	[al_fectersec] [smalldatetime] NOT NULL ,
	[al_entcer] [bit] NOT NULL ,
	[al_entact] [bit] NOT NULL ,
	[al_entfot] [bit] NOT NULL ,
	[al_fecing] [smalldatetime] NOT NULL ,
	[al_fecbaj] [smalldatetime] NOT NULL ,
	[al_semes] [tinyint] NOT NULL ,
	[al_medinf] [tinyint] NOT NULL ,
	[al_intasp] [tinyint] NOT NULL ,
	[al_tipobeca] [tinyint] NOT NULL ,
	[al_estatus] [tinyint] NOT NULL ,
	[al_cvecap] [tinyint] NOT NULL ,
	[al_caubaj] [smallint] NOT NULL ,
	[al_fecimp] [smalldatetime] NOT NULL ,
	[al_bacpro] [bit] NOT NULL ,
	[al_curp] [char] (18) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_ceneval] [bit] NOT NULL ,
	[al_email] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_dhimss] [bit] NOT NULL ,
	[al_dhissste] [bit] NOT NULL ,
	[al_segpop] [bit] NOT NULL ,
	[al_Privado] [bit] NOT NULL ,
	[al_filia] [char] (17) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_tiposangre] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_alergias] [char] (35) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_familia] [tinyint] NOT NULL ,
	[al_vivespadres] [bit] NOT NULL ,
	[al_casa] [tinyint] NOT NULL ,
	[al_ingreso] [tinyint] NOT NULL ,
	[al_distancia] [int] NOT NULL ,
	[al_tiempo] [int] NOT NULL ,
	[al_transporte] [tinyint] NOT NULL ,
	[al_trabajas] [bit] NOT NULL ,
	[al_padre] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[al_ciclo] [char] (5) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[Fua] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ResOficinas] (
	[re_nombre] [char] (50) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[re_zona] [tinyint] NOT NULL ,
	[re_fecini] [smalldatetime] NOT NULL ,
	[re_fecfin] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[foliregi] (
	[marca] [tinyint] NOT NULL ,
	[numlibr] [int] NOT NULL ,
	[numreg] [int] NOT NULL 
) ON [PRIMARY]
GO

