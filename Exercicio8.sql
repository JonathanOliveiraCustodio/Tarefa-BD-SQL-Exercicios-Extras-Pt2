USE master
--DROP DATABASE Exercicio8
CREATE DATABASE Exercicio8
USE Exercicio8

CREATE TABLE Cliente(				
Codigo					INT			    NOT NULL IDENTITY (1,1),
Nome					VARCHAR(50)		NOT NULL,
Endereco				VARCHAR(30)		NOT NULL,
Telefone				CHAR(08)		NOT NULL,
Telefone_Comercial		CHAR(08)		NULL
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Cliente VALUES
('Luis Paulo',		'R. Xv de Novembro, 100',			'45657878',NULL),
('Maria Fernanda',	'R. Anhaia, 1098',					'27289098',	'40040090'),
('Ana Claudia',		'Av. Volunt�rios da P�tria, 876',	'21346548',	NULL),	
('Marcos Henrique',	'R. Pantojo, 76',					'51425890',	'30394540'),
('Emerson Souza',	'R. Pedro �lvares Cabral, 97',		'44236545',	'39389900'),
('Ricardo Santos',	'Trav. Hum, 10',					'98789878', NULL)

CREATE TABLE Tipo_Mercadoria(
Codigo			INT				NOT NULL IDENTITY(10001,1),
Nome			VARCHAR(30)		NOT NULL
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Tipo_Mercadoria VALUES 
('P�es'),
('Frios'),
('Bolacha'),
('Clorados'),
('Frutas'),
('Esponjas'),
('Massas'),
('Molhos')

CREATE TABLE Corredores(
Codigo			INT			NOT NULL IDENTITY(101,1),	
Tipo			INT			NULL,
Nome			VARCHAR(40)	NULL,
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Corredores VALUES
(10001,	'Padaria'),
(10002,	'Cal�ados'),
(10003,	'Biscoitos'),
(10004,	'Limpeza'),
(NULL,  NULL	),
(NULL,	NULL	),
(10007,	'Congelados')

--DROP TABLE Mercadoria
CREATE TABLE Mercadoria(				
Codigo		INT				NOT NULL IDENTITY(1001,1),
Nome		VARCHAR(30)			NOT NULL,
Corredor	INT				NOT NULL,
Tipo		INT				NOT NULL,
Valor		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (Codigo)
FOREIGN KEY (Corredor) REFERENCES Corredores(Codigo),
FOREIGN KEY	(Tipo)	   REFERENCES Tipo_Mercadoria(Codigo)	
)
GO

INSERT INTO	Mercadoria VALUES
('P�o de Forma',	101,	10001,	3.5),
('Presunto',		101,	10002,	2.0),
('Cream Cracker',	103,	10003,	4.5),
('�gua Sanit�ria',	104,	10004,	6.5),
('Ma��',			105,	10005,	0.9),
('Palha de A�o',	106,	10006,	1.3),
('Lasanha',			107,	10007,	9.7)

CREATE TABLE Compra(		
Nota_Fiscal			INT				NOT NULL,	
Codigo_Cliente		INT				NOT NULL,
Valor				DECIMAL(7,2)	NOT NULL
PRIMARY KEY (Nota_Fiscal)
FOREIGN KEY (Codigo_Cliente) REFERENCES Cliente(Codigo)
)
GO

INSERT INTO Compra VALUES
(1234,	2,	200),
(2345,	4,	156),
(3456,	6,	354),
(4567,	3,	19)

--Pede-se:		
--Valor da Compra de Luis Paulo		
SELECT 
 c.Valor,
 cli.Nome
FROM Compra c INNER JOIN Cliente cli
ON c.Codigo_Cliente = cli.Codigo
 WHERE cli.Nome = 'Luis Paulo'  

--Valor da Compra de Marcos Henrique	
SELECT 
 'R$ ' + CAST(CAST(c.Valor AS DECIMAL(7,2)) AS CHAR(08)) AS "Valor Compra"
FROM Compra c INNER JOIN Cliente cli
 ON c.Codigo_Cliente = cli.Codigo
  WHERE cli.Nome = 'Marcos Henrique'
--Endere�o e telefone do comprador de Nota Fiscal = 4567	
SELECT 
 cli.Endereco,
 cli.Telefone
FROM Cliente cli INNER JOIN Compra c
 ON cli.Codigo = c.Codigo_Cliente
   WHERE c.Nota_Fiscal = 4567

--Valor da mercadoria cadastrada do tipo " P�es"		
SELECT
 m.Valor
FROM Mercadoria m INNER JOIN Tipo_Mercadoria tm
 ON m.Tipo = tm.Codigo
  WHERE tm.Nome LIKE 'P�es'

--Nome do corredor onde est� a Lasanha
SELECT
 c.Nome
FROM
Mercadoria m INNER JOIN Corredores c
 ON m.Tipo = c.Tipo
  WHERE m.Nome = 'Lasanha'
 
--Nome do corredor onde est�o os clorados
 SELECT
 c.Nome
FROM
Mercadoria m INNER JOIN Corredores c
 ON m.Tipo = c.Tipo
  INNER JOIN Tipo_Mercadoria tm
   ON tm.Codigo = c.Tipo
  
  WHERE m.Nome = 'clorados'

  -- Nome do corredor onde est�o os clorados
SELECT
  c.Nome AS NomeCorredor
FROM
  Mercadoria m INNER JOIN Corredores c 
   ON m.Corredor = c.Codigo
  INNER JOIN Tipo_Mercadoria tm 
  ON m.Tipo = tm.Codigo
WHERE
  tm.Nome = 'Clorados';




