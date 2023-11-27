
USE master
CREATE DATABASE Exercicio10
USE Exercicio10


USE master
DROP DATABASE Exercicio10

CREATE TABLE Medicamento (				
Codigo			INT			NOT NULL,
Nome			VARCHAR(50)	NOT NULL,
Apresentacao  	VARCHAR(50) NOT NULL,
Unidade			VARCHAR(30)	NOT NULL, 	 
Preco_Composto	DECIMAL(7,2)NOT NULL
PRIMARY KEY (Codigo)
)
GO
 
INSERT INTO Medicamento VALUES 
(1,	 'Acetato de medroxiprogesterona',  	'150 mg/ml',  			    'Ampola',		6.700),
(2,	 'Aciclovir',							'200mg/comp.',  			'Comprimido',  	0.280),
(3,	 'Ácido Acetilsalicílico',  			'500mg/comp.',  			'Comprimido',  	0.035),
(4,	 'Ácido Acetilsalicílico',  			'100mg/comp.',  			'Comprimido',  	0.030),
(5,	 'Ácido Fólico',  						'5mg/comp.',				'Comprimido',  	0.054),
(6,	 'Albendazol',							'400mg/comp. mastigável',  	'Comprimido',  	0.560),
(7,	 'Alopurinol',  						'100mg/comp.',  			'Comprimido',  	0.080),
(8,	 'Amiodarona',  						'200mg/comp.',  			'Comprimido',  	0.200),
(9,	 'Amitriptilina(Cloridrato)',  			'25mg/comp.',  				'Comprimido',  	0.220),
(10, 'Amoxicilina',  						'500mg/cáps.',  			'Cápsula',  	0.190)

CREATE TABLE Clientes (					
CPF			CHAR(11)		NOT NULL,
Nome		VARCHAR(50)		NOT NULL,	
Rua			VARCHAR(30)		NOT NULL,
Numero		INT				NOT NULL,	
Bairro		VARCHAR(30)		NOT NULL,
Telefone	CHAR(08)		NOT NULL
PRIMARY KEY (CPF)
)
GO

INSERT INTO Clientes VALUES
('34390898700',	'Maria Zélia',		'Anhaia',					65,		'Barra Funda',	92103762),
('21345986290',	'Roseli Silva',		'Xv. De Novembro',			987,	'Centro',		82198763),
('86927981825',	'Carlos Campos',	'Voluntários da Pátria',	1276,	'Santana',		98172361),
('31098120900',	'João Perdizes',	'Carlos de Campos',			90,		'Pari',			61982371)


CREATE TABLE Vendas (					
    Nota_Fiscal         INT             NOT NULL,
    CPF_cliente         CHAR(11)        NOT NULL,
    Codigo_Medicamento  INT             NOT NULL,
    Quantidade          INT             NOT NULL,
    Valor_Total         DECIMAL(7,2)    NOT NULL,
    Data_Venda          DATE            NOT NULL
    PRIMARY KEY (CPF_cliente,Codigo_Medicamento)
    FOREIGN KEY (CPF_cliente) REFERENCES Clientes(CPF),
    FOREIGN KEY (Codigo_Medicamento) REFERENCES Medicamento(Codigo)
)
GO

INSERT INTO Vendas VALUES
(31501,	'86927981825',	10,	3,	0.57,	'2020-11-01'),
(31501,	'86927981825',	2,	10,	2.8,	'2020-11-01'),
(31501,	'86927981825',	5,	30,	1.05,	'2020-11-01'),
(31501,	'86927981825',	8,	30,	6.6,	'2020-11-01'),
(31502,	'34390898700',	8,	15,	3,		'2020-11-01'),
(31502,	'34390898700',	2,	10,	2.8,	'2020-11-01'),
(31502,	'34390898700',	9,	10,	2.2,	'2020-11-01'),
(31503,	'31098120900',	1,	20,	134,	'2020-11-02')

--Consultar																					
--Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos. Caso a unidade de cadastro seja comprimido, mostrar Comp.		
SELECT 
 m.Nome,
 CASE WHEN m.Unidade = 'Comprimido' THEN 'Comp.' ELSE m.Unidade END AS UnidadeFormatada,   
 m.Preco_Composto
FROM Medicamento m LEFT JOIN Vendas v
 ON  m.Codigo = v.Codigo_Medicamento
  WHERE v.Nota_Fiscal IS NULL

--Nome dos clientes que compraram Amiodarona	
SELECT 
 cli.Nome
FROM Clientes cli INNER JOIN  Vendas v
 ON cli.CPF = v.CPF_cliente
  INNER JOIN Medicamento m 
   ON m.Codigo = v.Codigo_Medicamento
    WHERE M.Nome = 'Amiodarona'


/*CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  
apresentação do remédio, unidade, preço proposto, quantidade vendida e valor total dos remédios vendidos a Maria Zélia											
*/
SELECT 
 SUBSTRING(cli.CPF,1,3) + '.' + SUBSTRING(cli.CPF,4,3)+ '.' + SUBSTRING(cli.CPF,7,3)+ '-' + SUBSTRING(cli.CPF,9,2) AS "CPF com Máscara",
 cli.Rua + ' ' + CAST(cli.Numero AS VARCHAR) + ' ' + cli.Bairro AS "Endereço Completo",
 med.Nome,
 med.Unidade,
 med.Preco_Composto,
 v.Quantidade,
 v.Valor_Total
FROM Clientes cli INNER JOIN Vendas v ON 
 cli.CPF = v.CPF_cliente
 INNER JOIN Medicamento med ON
  med.Codigo = v.Codigo_Medicamento
   WHERE cli.Nome = 'Maria Zélia'

--Data de compra, convertida, de Carlos Campos	

SELECT DISTINCT 
 CONVERT(CHAR(08),v.Data_Venda,103) AS Data_Convertida
FROM Clientes c INNER JOIN Vendas v ON
 c.CPF = v.CPF_cliente
  WHERE c.Nome = 'Carlos Campos'
 											
--Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina	
UPDATE Medicamento SET Nome = 'Cloridrato de Amitriptilina' WHERE Nome= 'Amitriptilina(Cloridrato)'


