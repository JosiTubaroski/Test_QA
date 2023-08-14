
/****** Object:  StoredProcedure [dbo].[spcl_trata_clientes_duplicados]    Script Date: 2023-03-27 12:17:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Alter procedure [dbo].[spcl_trata_clientes_duplicados] @cd_carga int  
as  
begin try  
   
   
 declare @cd_cliente_legado varchar(max) 
 declare @vl_cap_finan_anual numeric(30,2)   
 declare @cd_radar varchar(50)
 declare @dt_inicio_relac date; 
  
 --Seleciona os clientes duplicados  
  
 with ttp_duplicados as(  
 select cd_cliente_legado       
 from dbo.ttp_cliente_detalhe_generico with(nolock)  
 group by cd_cliente_legado  
 having count(cd_cliente_legado) > 1  
 )  
  
 insert into dbo.tcl_cliente_detalhe_generico_duplicado(cd_cliente,cd_cliente_legado,dc_endereco,dc_numero,dc_complemento,dc_bairro,dc_cidade,dc_estado,dc_cep,dc_pais,dc_fone,dc_email,dc_ramo_atividade,  
               dt_inicio_relac,vl_cap_finan_anual,vl_renda,vl_patrimonio,cd_radar,dt_constituicao,dt_nascimento,cd_carga)  
 select distinct  
  cli.cd_cliente,  
  ori.cd_cliente_legado,  
     ori.dc_endereco,  
  ori.dc_numero,  
  ori.dc_complemento,  
  ori.dc_bairro,  
  ori.dc_cidade,  
  ori.dc_estado,  
  ori.dc_cep,  
  ori.dc_pais,  
  ori.dc_fone,  
  ori.dc_email,  
  ori.dc_ramo_atividade,  
  cast(substring(ori.dt_inicio_relac,7,4) + '-' + substring(ori.dt_inicio_relac,4,2) + '-' + substring(ori.dt_inicio_relac,1,2) as date) as dt_inicio_relac,  
  replace(replace(ori.vl_cap_finan_anual,'.',''),',','.') as vl_cap_finan_anual,  
  replace(replace(ori.vl_renda,'.',''),',','.') as vl_renda,  
  replace(replace(ori.vl_patrimonio,'.',''),',','.') as vl_patrimonio,  
  ori.cd_radar,  
  cast(substring(ori.dt_constituicao,7,4) + '-' + substring(ori.dt_constituicao,4,2) + '-' + substring(ori.dt_constituicao,1,2) as date) as dt_constituicao,  
  cast(substring(ori.dt_nascimento,7,4) + '-' + substring(ori.dt_nascimento,4,2) + '-' + substring(ori.dt_nascimento,1,2) as date) as dt_nascimento,  
  @cd_carga  
 from   dbo.ttp_cliente_detalhe_generico ori with(nolock)  
 join dbo.tcl_cliente cli with(nolock) on ori.cd_cliente_legado = cli.cd_cpf_cnpj   
 join ttp_duplicados dup on dup.cd_cliente_legado = ori.cd_cliente_legado   
 left join dbo.tcl_cliente_detalhe_generico des with(nolock) on ori.cd_cliente_legado = des.cd_cliente_legado  
 where des.cd_cliente_legado is null  
  
  
 --Começar a remover os duplicados e insere apenas uma linha do registro duplicado na tabela de clientes  
  
 DECLARE cr_cliente_duplicado CURSOR  
 LOCAL  
 FORWARD_ONLY  
 STATIC  
 TYPE_WARNING  
 FOR  
 select distinct cd_cliente_legado       
 from dbo.ttp_cliente_detalhe_generico with(nolock)  
 group by cd_cliente_legado  
 having count(cd_cliente_legado) > 1  
  
 open cr_cliente_duplicado  
 FETCH NEXT FROM cr_cliente_duplicado INTO @cd_cliente_legado  
  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  

--- 2022/03/24 Jozi: Convertendo todos os código legados para Numeric

  insert into dbo.tcl_cliente_detalhe_generico(cd_cliente,cd_cliente_legado,dc_endereco,dc_numero,dc_complemento,dc_bairro,dc_cidade,dc_estado,dc_cep,dc_pais,dc_fone,dc_email,dc_ramo_atividade,  
                dt_inicio_relac,vl_cap_finan_anual,vl_renda,vl_patrimonio,cd_radar,dt_constituicao,dt_nascimento,cd_carga,dt_criacao)  
  select distinct top 1  
   cli.cd_cliente,  
   ori.cd_cliente_legado,  
   ori.dc_endereco,  
   ori.dc_numero,  
   ori.dc_complemento,  
   ori.dc_bairro,  
   ori.dc_cidade,  
   ori.dc_estado,  
   ori.dc_cep,  
   ori.dc_pais,  
   ori.dc_fone,  
   ori.dc_email,  
   ori.dc_ramo_atividade,  
   cast(substring(ori.dt_inicio_relac,7,4) + '-' + substring(ori.dt_inicio_relac,4,2) + '-' + substring(ori.dt_inicio_relac,1,2) as date) as dt_inicio_relac,  
   replace(replace(ori.vl_cap_finan_anual,'.',''),',','.') as vl_cap_finan_anual,  
   replace(replace(ori.vl_renda,'.',''),',','.') as vl_renda,  
   replace(replace(ori.vl_patrimonio,'.',''),',','.') as vl_patrimonio,  
   ori.cd_radar,  
   cast(substring(ori.dt_constituicao,7,4) + '-' + substring(ori.dt_constituicao,4,2) + '-' + substring(ori.dt_constituicao,1,2) as date) as dt_constituicao,  
   cast(substring(ori.dt_nascimento,7,4) + '-' + substring(ori.dt_nascimento,4,2) + '-' + substring(ori.dt_nascimento,1,2) as date) as dt_nascimento,  
   @cd_carga,  
   getdate()  
  from   dbo.ttp_cliente_detalhe_generico ori with(nolock)  
  join dbo.tcl_cliente cli with(nolock) on ori.cd_cliente_legado = cli.cd_cpf_cnpj    
  left join dbo.tcl_cliente_detalhe_generico des with(nolock) on ori.cd_cliente_legado = des.cd_cliente_legado 
  where  des.cd_cliente_legado is null  
  and ori.cd_cliente_legado = @cd_cliente_legado   

--- 2022/03/24 Jozi: Dos registros que estão duplicados utilizar o Max 'vl_cap_finan_anual'

  set @vl_cap_finan_anual = (select top 1   
   max (cast(replace(replace(ori.vl_cap_finan_anual,'.',''),',','.')as numeric(30,2))) as vl_cap_finan_anual 
 from dbo.ttp_cliente_detalhe_generico ori  
 join dbo.tcl_cliente cli with(nolock) on ori.cd_cliente_legado = cli.cd_cpf_cnpj   
 join dbo.tcl_cliente_detalhe_generico des with(nolock) on ori.cd_cliente_legado = des.cd_cliente_legado  
 where   des.cd_cliente_legado = @cd_cliente_legado) 
 --group by cast (ori.cd_cliente_legado as numeric), ori.vl_cap_finan_anual)
 
--- 2022/03/24 Jozi: Dos registros que estão duplicados utilizar o Max 'cd_radar'

  set @cd_radar = (select top 1    
   max(ori.cd_radar)  
 from dbo.ttp_cliente_detalhe_generico ori  
 join dbo.tcl_cliente cli with(nolock) on ori.cd_cliente_legado = cli.cd_cpf_cnpj   
 join dbo.tcl_cliente_detalhe_generico des with(nolock) on ori.cd_cliente_legado = des.cd_cliente_legado 
 where   des.cd_cliente_legado = @cd_cliente_legado 
 group by ori.cd_cliente_legado);

--- 2022/03/24 Jozi: Dos registros que estão duplicados utilizar o Minimo para 'Data_Inicio_Relacionamento'

  set @dt_inicio_relac = (select top 1   
   min(cast(substring(ori.dt_inicio_relac,7,4) + '-' + substring(ori.dt_inicio_relac,4,2) + '-' + substring(ori.dt_inicio_relac,1,2) as date))   
 from dbo.ttp_cliente_detalhe_generico ori  
 join dbo.tcl_cliente cli with(nolock) on ori.cd_cliente_legado = cli.cd_cpf_cnpj    
 join dbo.tcl_cliente_detalhe_generico des with(nolock) on ori.cd_cliente_legado = des.cd_cliente_legado 
 where   des.cd_cliente_legado = @cd_cliente_legado 
 group by ori.cd_cliente_legado); 

--- 2022/03/24 Jozi: Realizar os updates com os valores das variaveis

 update des   
        set      
        des.dt_inicio_relac     = @dt_inicio_relac,  
        des.vl_cap_finan_anual  = cast(@vl_cap_finan_anual as varchar),  
        des.cd_radar            = @cd_radar,  
        des.cd_carga            = @cd_carga,  
        des.dt_alteracao        = getdate()  
 from dbo.tcl_cliente_detalhe_generico des   
 where des.cd_cliente_legado = @cd_cliente_legado 

--- Após as atualizações os registros duplicados são excluidos
  
  delete from dbo.ttp_cliente_detalhe_generico where cd_cliente_legado = @cd_cliente_legado 
  
  FETCH NEXT FROM cr_cliente_duplicado INTO @cd_cliente_legado  
  
 END  
 CLOSE cr_cliente_duplicado  
 DEALLOCATE cr_cliente_duplicado  
  
  
  
end try  
begin catch  
  
 exec spgr_tratar_erro  
  
end catch
GO


