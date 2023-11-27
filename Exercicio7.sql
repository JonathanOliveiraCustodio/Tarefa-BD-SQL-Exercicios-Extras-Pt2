USE master
--DROP DATABASE Exercicio7
CREATE DATABASE Exercicio7
USE Exercicio7


CREATE TABLE Cliente(								
RG			CHAR(9)		NOT NULL,
CPF			CHAR(11)	NOT NULL,
Nome		VARCHAR(50) NOT NULL,
Logradouro	VARCHAR(30)	NOT NULL,
Numero		INT			NOT NULL
PRIMARY KEY (RG)
)
GO

INSERT INTO Cliente	VALUES
('29531844',	'34519878040',	'Luiz André',	'R. Astorga',		500),
('13514996x',	'84984285630',	'Maria Luiza',	'R. Piauí',			174),
('121985541',	'23354997310',	'Ana Barbara',	'Av. Jaceguai',		1141),
('23987746x',	'43587669920',	'Marcos Alberto',	'R. Quinze',	22)

CREATE TABLE Fornecedor(																		
Codigo			INT				NOT NULL,	
Nome			VARCHAR(50)		NOT NULL,
Logradouro		VARCHAR(30)		NOT NULL,
Numero			INT			    NULL,	
Pais			CHAR(04)		NOT NULL,
Area			INT				NOT NULL,
Telefone		CHAR(10)		NULL,
CNPJ			CHAR(14)		NULL,
Cidade			VARCHAR(30)		NULL,
Transporte		VARCHAR(15)		NULL,
Moeda			CHAR(5)			NOT NULL
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Fornecedor VALUES
(1,	'Clone',		'Av. Nações Unidas, 12000',	12000,	'BR',	55,	'1141487000',		NULL,			  'São Paulo',   NULL,	    'R$'),
(2,	'Logitech',		'28th Street, 100',			100,	'USA',	1,	'2127695100',		NULL,			  NULL,		    'Avião',	'US$'),
(3,	'LG',			'Rod. Castello Branco',		NULL,	'BR',	55,	'800664400',		'4159978100001',  'Sorocaba',	 NULL,	     'R$'),
(4,	'PcChips',		'Ponte da Amizade',			NULL,	'PY',	595, NULL,				NULL,			  NULL,	        'Navio',	'US$')

CREATE TABLE Mercadoria(								
Codigo				INT			 NOT NULL,
Descricao			VARCHAR(50)  NOT NULL,
Preco				DECIMAL(7,2) NOT NULL,
Qtd					INT			 NOT NULL,
Cod_Fornecedor		INT			 NOT NULL
PRIMARY KEY (Codigo)
FOREIGN KEY (Cod_Fornecedor) REFERENCES Fornecedor(Codigo)
)
GO

INSERT INTO Mercadoria VALUES
(10,	'Mouse',		24,		30,	1),
(11,	'Teclado',		50,		20,	1),
(12,	'Cx. De Som',	30,		8,	2),
(13,	'Monitor 17',	350,	4,	3),
(14,	'Notebook',		1500,	7,	4)

CREATE TABLE Pedido(						
Nota_Fiscal			INT				NOT NULL,	
Valor				DECIMAL(7,2)	NOT NULL,
Data_Compra			DATE			NOT NULL,
RG_Cliente			CHAR(9)			NOT NULL
PRIMARY KEY	(Nota_Fiscal)
FOREIGN KEY (RG_Cliente) REFERENCES CLiente(RG)
)
GO

INSERT INTO Pedido	VALUES
(1001,	754,		'2018-04-01',	'121985541'),
(1002,	350,		'2018-04-02',	'121985541'),
(1003,	30,		'2018-04-02',	'29531844'),
(1004,	1500,	'2018-04-03',	'13514996x')


--Pede-se: (Quando o endereço concatenado não tiver número, colocar só o logradouro e o país, quando tiver colocar, também o número)															
--Nota: (CPF deve vir sempre mascarado no formato XXX.XXX.XXX-XX e RG Sempre com um traçao antes do último dígito (Algo como XXXXXXXX-X), mas alguns tem 8 e outros 9 dígitos)															
--FK: Cliente em Pedido - Fornecedor em Mercadoria															

--Consultar 10% de desconto no pedido 1003		
SELECT 
 ped.Valor,
 'R$ ' + CAST(CAST(ped.Valor * 0.9 AS DECIMAL(7,2)) AS VARCHAR(08)) AS PrecoComDesconto
FROM Pedido ped
 WHERE ped.Nota_Fiscal = 1003
--Consultar 5% de desconto em pedidos com valor maior de R$700,00	

SELECT
 ped.Data_Compra,
 ped.Valor,
 'RS'+ CAST(CAST(ped.Valor * 0.95 AS DECIMAL(7,2)) AS VARCHAR(08)) AS "Novo Valor"
FROM Pedido ped
 WHERE ped.Valor > 700

--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10	
SELECT 
 m.Codigo,
 m.Preco,
 'R$ ' + CAST(CAST(m.Preco * 1.25 AS DECIMAL(7,2)) AS CHAR(08)) AS "Novo Preço"
FROM Mercadoria m
 WHERE m.Qtd < 10

--Data e valor dos pedidos do Luiz				
SELECT 
 p.Data_Compra,
 p.Valor

FROM pedido p INNER JOIN Cliente c 
 ON p.RG_Cliente = c.RG
  WHERE c.Nome = 'Luiz André'
 
  

--CPF, Nome e endereço concatenado do cliente de nota 1004	

SELECT
 SUBSTRING(c.CPF,1,3)+'.'+SUBSTRING(c.CPF,4,3)+'.'+SUBSTRING(c.CPF,7,3)+'-'+SUBSTRING(c.CPF,9,2),
 c.Nome,
 c.Logradouro + ', ' + CAST(c.Numero AS VARCHAR) AS "Endereço Completo"
FROM Cliente c INNER JOIN Pedido p
 ON c.RG = p.RG_Cliente
  WHERE P.Nota_Fiscal = 1004

--País e meio de transporte da Cx. De som		
SELECT 
 f.Pais,
 f.Transporte

FROM Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo
  WHERE m.Descricao = 'Cx. De som'


--Nome e Quantidade em estoque dos produtos fornecidos pela Clone	
SELECT 
 m.Descricao,
 m.Qtd,
 f.Nome
FROM Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo
  WHERE f.Nome = 'Clone'

--Endereço concatenado e telefone dos fornecedores do monitor. (Telefone brasileiro (XX)XXXX-XXXX ou XXXX-XXXXXX (Se for 0800), Telefone Americano (XXX)XXX-XXXX)	
SELECT 
 f.Nome,
 f.Logradouro + ' ' +  CAST(f.Numero AS varchar) AS "Endereço Completo",
 CASE WHEN f.Pais = 'BR' THEN '(' + SUBSTRING(f.Telefone,1,2) + ')'+ SUBSTRING(f.Telefone,3,5) + '-'+ SUBSTRING(f.Telefone,6,4) 
  WHEN f.Pais = 'USA' THEN '(' + SUBSTRING(f.Telefone,1,3) + ')'+ SUBSTRING(f.Telefone,4,3) + '-'+ SUBSTRING(f.Telefone,7,4) 
   WHEN f.Telefone LIKE '0800%' THEN SUBSTRING(f.Telefone,1,4) + '-'+ SUBSTRING(f.Telefone,5,6) 
   WHEN F.Telefone IS NULL THEN 'Telefone Vazio' END AS "Telefone"
FROM Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo
  WHERE m.Descricao LIKE '%Monitor%'
 

--Tipo de moeda que se compra o notebook
SELECT
 m.Descricao,
 f.Nome,
 f.Moeda

FROM
Mercadoria m INNER JOIN Fornecedor f
 ON m.Cod_Fornecedor = f.Codigo 
  WHERE m.Descricao LIKE '%Notebook%'

--Considerando que hoje é 03/02/2019, há quantos dias foram feitos os pedidos e, 
--criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses e pedido recente para os outros
SELECT 
 p.Data_Compra,
 DATEDIFF (DAY,p.Data_Compra,'2019-02-03') AS "Dias",
 CASE WHEN DATEDIFF(MONTH,p.Data_Compra,'2019-02-03') > 6 THEN 'Pedido Antigo' 
 ELSE 'Pedido Recente' END AS Pedidos
FROM Pedido p

--Nome e Quantos pedidos foram feitos por cada cliente	
SELECT 
 c.Nome,
 COUNT(p.Nota_Fiscal) AS "Quantidade Pedidos"

FROM Pedido p INNER JOIN Cliente c
 ON P.RG_Cliente = c.RG
 GROUP BY c.Nome
  

--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT 
 c.RG,
 c.Nome,
 c.Logradouro
FROM Cliente c LEFT JOIN Pedido p
 ON p.RG_Cliente = c.RG
  WHERE P.Nota_Fiscal IS NULL


