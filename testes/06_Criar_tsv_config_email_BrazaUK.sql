

IF (NOT EXISTS (select * from INFORMATION_SCHEMA.TABLES 
                where TABLE_SCHEMA = 'dbo'
                and TABLE_NAME = 'tsv_config_email_3'))

Begin

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[tsv_config_email_3](
	[cd_campo] [int] NOT NULL,
	[dc_ident] [char](25) NOT NULL,
	[vl_campo] [char](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[cd_campo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

End


