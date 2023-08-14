
--- Caso o campo não exista o campo na tabela então será adicionado

 If not exists (Select top 1 T.name AS Tabela,C.name AS Coluna
                from sys.sysobjects as T (nolock)
                inner join sys.all_columns AS C (NOLOCK) ON T.id = C.object_id AND T.XTYPE = 'U'
                Where T.name = 'ttp_cambio_operacao_problema' and C.NAME = 'dt_cadastro')

   ALTER TABLE dbo.ttp_cambio_operacao_problema 
   ADD dt_cadastro smalldatetime NULL

 If not exists (Select top 1 T.name AS Tabela,C.name AS Coluna
                from sys.sysobjects as T (nolock)
                inner join sys.all_columns AS C (NOLOCK) ON T.id = C.object_id AND T.XTYPE = 'U'
                Where T.name = 'ttp_cambio_operacao_problema' and C.NAME = 'cd_carga')

   ALTER TABLE dbo.ttp_cambio_operacao_problema 
   ADD cd_carga int NULL