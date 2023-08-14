
--- Declarando as variaveis

Declare @cd_produto int
Declare @cd_tabela int
Declare @nm_produto varchar(100) = 'BrazaUK' 

select @cd_produto = 4

select @cd_tabela = 3

if not exists(select * from dbo.tsv_produtos 
              where nm_produto = @nm_produto)

Begin
insert into dbo.tsv_produtos
(cd_produto, 
 nm_produto, 
 cd_tabela, 
 cd_funcao_sistema_relat, 
 cd_funcao_sistema_opcoes,
 cd_funcao_sistema_server, 
 cd_produto_carga, 
 id_status)
values(@cd_produto, @nm_produto, @cd_tabela, 30, 67, 3002, @cd_produto, 1)
End







