
---- Adicionar campo na tabel de Cliente 'BrazaUK'

 If not exists (Select top 1 T.name AS Tabela,C.name AS Coluna
                from sys.sysobjects as T (nolock)
                inner join sys.all_columns AS C (NOLOCK) ON T.id = C.object_id AND T.XTYPE = 'U'
                Where T.name = 'tcl_cliente' and C.NAME = 'brazauk')

   ALTER TABLE dbo.tcl_cliente 
   ADD brazauk VARCHAR(30) NULL

