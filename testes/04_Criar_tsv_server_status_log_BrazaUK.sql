
--- 01. Criação da tabela server_status_log_3 para o produto Money

IF (NOT EXISTS (select * from INFORMATION_SCHEMA.TABLES 
              where TABLE_SCHEMA = 'dbo'
              and TABLE_NAME = 'tsv_server_status_log_3'))

Begin

SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[tsv_server_status_log_3](
	[cd_campo] [int] IDENTITY(1,1) NOT NULL,
	[dc_status] [varchar](1000) NULL,
	[dc_comp] [varchar](1000) NULL,
	[dt_execucao] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[cd_campo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, 
IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, 
ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


End

Go