
--- 01. Criação da tabela tsv_erro_carga_10

IF (NOT EXISTS (select * from INFORMATION_SCHEMA.TABLES 
                where TABLE_SCHEMA = 'dbo'
                and TABLE_NAME = 'tsv_erro_carga_10'))

Begin

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tsv_erro_carga_10](
	[cd_campo] [int] IDENTITY(1,1) NOT NULL,
	[nm_package] [varchar](60) NOT NULL,
	[dc_erro] [text] NULL,
	[dt_erro] [smalldatetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[cd_campo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

End