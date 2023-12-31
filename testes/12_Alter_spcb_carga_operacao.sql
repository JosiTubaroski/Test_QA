
/****** Object:  StoredProcedure [dbo].[spcb_carga_operacao]    Script Date: 2023-03-27 12:29:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Ajustar para retirar 0 e comparar e caso tenha 2 clientes seleciona o maior código Cliente

ALTER procedure [dbo].[spcb_carga_operacao]  
 @dt_referencia smalldatetime  
as  
  
begin try  
  
 set ansi_warnings off;  
  
 declare @cd_carga int   
  
 --seleciona o ultimo cód. carga  
 select @cd_carga = isnull(max(cd_carga), 0) + 1 from dbo.tgr_cargas    
  
 --inicio carga  
 insert into dbo.tgr_cargas(cd_carga, cd_produto, dt_referencia, nm_arquivo, nm_package, dt_inicio, dt_termino, id_termino)  
 values(@cd_carga, 1, @dt_referencia, 'SIRCOI_EXCHANGE', 'spcb_carga_operacao', getdate(), getdate(), 0)  
  
 --insere na tabela definitiva  
 insert into dbo.tcb_operacao  
 (  
 cd_cliente,  
 cd_transacao,  
 cd_cliente_legado,  
 tp_transacao,  
 nm_contraparte,  
 dc_sigla_pais,  
 dc_codigo_moeda,  
 cd_natureza_operacao,  
 vl_valor_real,  
 vl_valor_moeda_estrangeira,  
 vl_taxa_op,  
 dt_movimentacao,  
 cd_boleto,  
 cd_bacen,  
 cd_agente,  
 nm_banco,  
 nm_agencia,  
 nr_conta,  
 nm_conta_iban,  
 nm_banco_swift,  
 nm_banco_exterior,  
 dt_criacao,  
 dt_referencia,  
 cd_carga  
 )  
 select distinct 
 max(cli.cd_cliente),  
 ttp.cd_transacao,  
 cast (ttp.cd_cliente_legado as numeric),  --- Converter para tipo de dado Numerico
 ttp.tp_transacao,  
 ttp.nm_contraparte,  
 ttp.dc_sigla_pais,  
 ttp.dc_codigo_moeda,  
 ttp.cd_natureza_operacao,  
 cast(replace(replace(ttp.vl_valor_real,'.',''),',','.') as float),  
 cast(replace(replace(ttp.vl_valor_moeda_estrangeira,'.',''),',','.')  as float),  
 cast(replace(replace(ttp.vl_taxa_op,'.',''),',','.') as float),  
 cast(substring(ttp.dt_movimentacao,7,4) + '-' + substring(ttp.dt_movimentacao,4,2) + '-' + substring(ttp.dt_movimentacao,1,2) as date),  
 ttp.cd_boleto,  
 ttp.cd_bacen,  
 ttp.cd_agente,  
 ttp.nm_banco,  
 ttp.nm_agencia,  
 ttp.nr_conta,  
 ttp.nm_conta_iban,  
 ttp.nm_banco_swift,  
 ttp.nm_banco_exterior,   
 getdate(),  
 @dt_referencia,  
 @cd_carga  
 from dbo.ttp_cambio_operacao ttp with(nolock)  
 join dbo.tcl_cliente cli with(nolock) on cli.cd_cliente_legado = ttp.cd_cliente_legado  
 left join dbo.tcb_operacao ope with(nolock) on ope.cd_transacao = ttp.cd_transacao  
 where ope.cd_transacao is null 
 group by 
 ttp.cd_transacao,  
 cast (ttp.cd_cliente_legado as numeric),  --- Converter para tipo de dado Numerico
 ttp.tp_transacao,  
 ttp.nm_contraparte,  
 ttp.dc_sigla_pais,  
 ttp.dc_codigo_moeda,  
 ttp.cd_natureza_operacao,  
 cast(replace(replace(ttp.vl_valor_real,'.',''),',','.') as float),  
 cast(replace(replace(ttp.vl_valor_moeda_estrangeira,'.',''),',','.')  as float),  
 cast(replace(replace(ttp.vl_taxa_op,'.',''),',','.') as float),  
 cast(substring(ttp.dt_movimentacao,7,4) + '-' + substring(ttp.dt_movimentacao,4,2) + '-' + substring(ttp.dt_movimentacao,1,2) as date),  
 ttp.cd_boleto,  
 ttp.cd_bacen,  
 ttp.cd_agente,  
 ttp.nm_banco,  
 ttp.nm_agencia,  
 ttp.nr_conta,  
 ttp.nm_conta_iban,  
 ttp.nm_banco_swift,  
 ttp.nm_banco_exterior 
  
 --atualiza a operacao  
  
 --Operações que não entraram no sistema pq não há cliente vinculado as mesmas  

-- 2021-12-03: Declarando a variavel para verificar se alguma operação não foi integrada

declare @operacao_Problema int

--- Atribuir o valor 1 caso tenha ao menos uma operação que não tenha integrado

 if exists ( select top 1 * from dbo.ttp_cambio_operacao ttp  
 left join dbo.tcb_operacao ope with(nolock) on ope.cd_transacao = ttp.cd_transacao  
 where ope.cd_transacao is null)
 Begin
   set @operacao_Problema = 1
  
 insert into dbo.ttp_cambio_operacao_problema(cd_transacao,cd_cliente_legado,tp_transacao,nm_contraparte,dc_sigla_pais,dc_codigo_moeda,cd_natureza_operacao,vl_valor_real,  
                vl_valor_moeda_estrangeira,vl_taxa_op,dt_movimentacao,cd_boleto,cd_bacen,cd_agente,nm_banco,nm_agencia,nr_conta,nm_conta_iban,  
             nm_banco_swift,nm_banco_exterior, dt_cadastro, cd_carga)  
 select  ttp.cd_transacao,  
   ttp.cd_cliente_legado,  
   ttp.tp_transacao,  
   ttp.nm_contraparte,  
   ttp.dc_sigla_pais,  
   ttp.dc_codigo_moeda,  
   ttp.cd_natureza_operacao,  
   ttp.vl_valor_real,  
   ttp.vl_valor_moeda_estrangeira,  
   ttp.vl_taxa_op,  
   ttp.dt_movimentacao,  
   ttp.cd_boleto,  
   ttp.cd_bacen,  
   ttp.cd_agente,  
   ttp.nm_banco,  
   ttp.nm_agencia,  
   ttp.nr_conta,  
   ttp.nm_conta_iban,  
   ttp.nm_banco_swift,  
   ttp.nm_banco_exterior,
   getdate(),
   @cd_carga  
 from dbo.ttp_cambio_operacao ttp  
 left join dbo.tcb_operacao ope with(nolock) on ope.cd_transacao = ttp.cd_transacao  
 where ope.cd_transacao is null  

    INSERT INTO [dbo].[tsv_erro_carga_1]
           ([nm_package]
           ,[dc_erro]
           ,[dt_erro])
     VALUES
           ('SIRCOI_EXCHANGE'
           ,'Cliente não encontrado para vinculo com operação.'
           ,getdate())

 if (@operacao_Problema = 1)
 Begin

  set @operacao_Problema = 'Incluindo Texto em Int para erro'

 end   
end
 --fim carga  
   
 update dbo.tgr_cargas  
 set dt_termino = getdate(),  
 id_termino = 1  
 where cd_carga = @cd_carga    
  
end try  
begin catch  
  
    exec dbo.spgr_tratar_erro   
  
end catch  