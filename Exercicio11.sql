USE master
--DROP DATABASE Exercicio11

CREATE DATABASE Exercicio11

USE Exercicio11


CREATE TABLE Plano_Saude(				
Codigo		INT				NOT NULL,	
Nome		VARCHAR(50)		NOT NULL,
Telefone	CHAR(08)		NOT NULL
PRIMARY KEY (Codigo)
)
GO

INSERT INTO Plano_Saude VALUES
(1234,	'Amil',	'41599856'),
(2345,	'Sul Am�rica',	'45698745'),
(3456,	'Unimed',	'48759836'),
(4567,	'Bradesco Sa�de',	'47265897'),
(5678,	'Interm�dica',	'41415269')

CREATE TABLE Paciente(												
CPF				CHAR(11)		NOT NULL,
Nome			VARCHAR(50)		NOT NULL,
Rua				VARCHAR(50)		NOT NULL,
Numero			INT				NOT NULL,		
Bairro			VARCHAR(40)		NOT NULL,
Telefone		CHAR(08)		NOT NULL,
Plano_Saude		INT				NOT NULL
PRIMARY KEY (CPF)
FOREIGN KEY (Plano_Saude) REFERENCES Plano_Saude(Codigo)
)
GO

INSERT INTO Paciente VALUES
('85987458920',	'Maria Paula',	'R. Volunt�rios da P�tria',	589,	'Santana',		'98458741',		2345),
('87452136900',	'Ana Julia',	'R. XV de Novembro',		657,	'Centro',		'69857412',		5678),
('23659874100',	'Jo�o Carlos',	'R. Sete de Setembro',		12,		'Rep�blica',	'74859632',	1234),
('63259874100',	'Jos� Lima',	'R. Anhaia',				768,	'Barra Funda',	'96524156',	2345)

CREATE TABLE Medico(						
Codigo				INT			NOT NULL,
Nome				VARCHAR(50)	NOT NULL,
Especialidade		VARCHAR(30)	NOT NULL,
Plano_Saude			INT			NOT NULL
PRIMARY KEY (Codigo)
FOREIGN KEY (Plano_Saude) REFERENCES Plano_Saude(Codigo)
)
GO

INSERT INTO Medico VALUES 
(1,	'Claudio',	'Cl�nico Geral',			1234),
(2,	'Larissa',	'Ortopedista',				2345),
(3,	'Juliana',	'Otorrinolaringologista',	4567),
(4,	'S�rgio',	'Pediatra',					1234),
(5,	'Julio',	'Cl�nico Geral',			4567),
(6,	'Samara',	'Cirurgi�o',				1234)

DROP  TABLE Consultas

CREATE TABLE Consultas(						
Medico			INT			    NOT NULL,
Paciente		CHAR(11)	    NOT NULL,
Data_Hora	    DATETIME		NOT NULL,
Diagnostico		VARCHAR(50)  	NOT NULL
PRIMARY KEY (Medico,Paciente,Data_Hora)
FOREIGN KEY (Medico) REFERENCES Medico(Codigo),
FOREIGN KEY (Paciente) REFERENCES Paciente(CPF)
)
GO


INSERT INTO Consultas VALUES 
(1,	'85987458920',	'2021-02-10 10:30:00',	'Gripe'),
(2,	'23659874100',	'2021-02-10 11:00:00',	'P� Fraturado'),
(4,	'85987458920',	'2021-02-11 14:00:00',	'Pneumonia'),
(1,	'23659874100',	'2021-02-11 15:00:00',	'Asma'),
(3,	'87452136900',	'2021-02-11 16:00:00',	'Sinusite'),
(5,	'63259874100',	'2021-02-11 17:00:00',	'Rinite'),
(4,	'23659874100',	'2021-02-11 18:00:00',	'Asma'),
(5,	'63259874100',	'2021-02-12 10:00:00',	'Rinoplastia')

SELECT * FROM Medico 

--Consultar Nome e especialidade dos m�dicos da Amil		
select m.Nome, m.Especialidade
from Medico m, Plano_Saude p
where m.Plano_Saude = p.Codigo
and p.Nome like 'Amil%'
 
 
--Consultar Nome, Endere�o concatenado, Telefone e Nome do Plano de Sa�de de todos os pacientes										
select p.Nome,  p.Rua+','+ cast(p.Numero as varchar(5))+','+p.Bairro  as Endere�o , p.Telefone ,pa.Nome 
from Paciente p, Plano_Saude pa
where p.Plano_Saude =pa.Codigo
 
--Consultar Telefone do Plano de  Sa�de de Ana J�lia										
select p.Telefone
from Plano_Saude p, Paciente pa
where p.Codigo =pa.Plano_Saude
and pa.Nome like 'Ana%'
 
--Consultar Plano de Sa�de que n�o tem pacientes cadastrados										
select p.Nome
from Plano_Saude p Left join Paciente pa
on p.Codigo = pa.Plano_Saude
where pa.Plano_Saude is null
 
--Consultar Planos de Sa�de que n�o tem m�dicos cadastrados										
select p.Nome
from Plano_Saude p left join Medico m
on p.Codigo =m.Plano_Saude
where m.Plano_Saude is null
 
--Consultar Data da consulta, Hora da consulta, nome do m�dico, nome do paciente e diagn�stico de todas as consultas										
select convert(char(20),c.Data_Hora,103) as Data_consulta, m.Nome, p.Nome, c.Diagnostico
from Consultas c, Medico m, Paciente p
where c.Medico =m.Codigo
and c.Paciente = p.CPF
 
 
--Consultar Nome do m�dico, data e hora de consulta e diagn�stico de Jos� Lima										
select m.Nome , convert(char(20),c.Data_Hora,103),c.Diagnostico
from Medico m, Consultas c,Paciente p
where m.Codigo = c.Medico
and c.Paciente= p.CPF
and p.Nome like 'Jos�%'
--Consultar Diagn�stico e Quantidade de consultas que aquele diagn�stico foi dado (Coluna deve chamar qtd)										
select Diagnostico, COUNT(diagnostico) As QTD
from Consultas
group by Diagnostico
 
--Consultar Quantos Planos de Sa�de que n�o tem m�dicos cadastrados										
 
select count (p.Nome)
from Plano_Saude p left join Medico m
on p.Codigo =m.Plano_Saude
where m.Plano_Saude is null								
 
 
--Alterar o nome de Jo�o Carlos para Jo�o Carlos da Silva
UPDATE Paciente SET Nome = 'Jo�o Carlos da Silva' WHERE Nome = 'Jo�o Carlos';


--Deletar o plano de Sa�de Unimed
DELETE FROM Plano_Saude WHERE Nome = 'Unimed';



--Renomear a coluna Rua da tabela Paciente para Logradouro			

EXEC sp_rename 'Paciente.Rua', 'Logradouro', 'COLUMN';

--Inserir uma coluna, na tabela Paciente, de nome data_nasc e inserir os valores (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18) respectivamente

ALTER TABLE Paciente
ADD data_nasc DATE;

-- Inserir os valores na nova coluna
UPDATE Paciente
SET data_nasc = '1990-04-18'
WHERE CPF = '85987458920'

UPDATE Paciente
SET data_nasc = '1981-03-25'
WHERE CPF = '87452136900'

UPDATE Paciente
SET data_nasc = '2004-09-04'
WHERE CPF = '23659874100'

UPDATE Paciente
SET data_nasc = '1986-06-18'
WHERE CPF = '63259874100'