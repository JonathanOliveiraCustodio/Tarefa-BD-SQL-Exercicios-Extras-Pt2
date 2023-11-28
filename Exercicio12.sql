USE master
--DROP DATABASE Exercicio12
CREATE DATABASE Exercicio12
USE Exercicio12


CREATE TABLE Planos(		
CodPlano		INT				NOT NULL,
NomePlano		VARCHAR(50)		NOT NULL,	
ValorPlano		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (CodPlano)
)
GO

INSERT INTO Planos VALUES 
(1,	'100 Minutos',	80),
(2,	'150 Minutos',	130),
(3,	'200 Minutos',	160),
(4,	'250 Minutos',	220),
(5,	'300 Minutos',	260),
(6,	'600 Minutos',	350)


CREATE TABLE Servicos(		
CodServico			INT				NOT NULL,
NomeServico			VARCHAR(50)		NOT NULL,
ValorServico		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (CodServico)
)
GO

INSERT INTO Servicos VALUES
(1,	'100 SMS',	10),
(2,	'SMS Ilimitado',	30),
(3,	'Internet 500 MB',	40),
(4,	'Internet 1 GB',	60),
(5,	'Internet 2 GB',	70)


CREATE TABLE Cliente(		
CodCliente		INT				NOT NULL,
NomeCliente		VARCHAR(50)		NOT NULL,
DataInicio		DATE			NOT NULL
PRIMARY KEY (CodCliente)
)
GO

INSERT INTO Cliente VALUES
(1234,	'Cliente A',	'2012-10-15'),
(2468,	'Cliente B',	'2012-11-20'),
(3702,	'Cliente C',	'2012-11-25'),
(4936,	'Cliente D',	'2012-12-01'),
(6170,	'Cliente E',	'2012-12-18'),
(7404,	'Cliente F',	'2013-01-20'),
(8638,	'Cliente G',	'2013-01-25')

DROP TABLE Contratos

CREATE TABLE Contratos(				
CodCliente			INT			NOT NULL,
CodPlano			INT			NOT NULL,
CodServico			INT			NOT NULL,
Status				CHAR(01)	NOT NULL,
Data_Contrato		DATE		NOT NULL
PRIMARY KEY (CodCliente,CodPlano,CodServico,Data_Contrato)
FOREIGN KEY (CodCliente) REFERENCES Cliente (CodCliente),
FOREIGN KEY (CodPlano)   REFERENCES Planos (CodPlano),
FOREIGN KEY (CodServico) REFERENCES Servicos (CodServico)
)
GO

INSERT INTO Contratos VALUES
(1234,	3,	1,	'E',	'2012-10-15'),
(1234,	3,	3,	'E',	'2012-10-15'),
(1234,	3,	3,	'A',	'2012-10-16'),
(1234,	3,	1,	'A',	'2012-10-16'),
(2468,	4,	4,	'E',	'2012-11-20'),
(2468,	4,	4,	'A',	'2012-11-21'),
(6170,	6,	2,	'E',	'2012-12-18'),
(6170,	6,	5,	'E',	'2012-12-19'),
(6170,	6,	2,	'A',	'2012-12-20'),
(6170,	6,	5,	'A',	'2012-12-21'),
(1234,	3,	1,	'D',	'2013-01-10'),
(1234,	3,	3,	'D',	'2013-01-10'),
(1234,	2,	1,	'E',	'2013-01-10'),
(1234,	2,	1,	'A',	'2013-01-11'),
(2468,	4,	4,	'D',	'2013-01-25'),
(7404,	2,	1,	'E',	'2013-01-20'),
(7404,	2,	5,	'E',	'2013-01-20'),
(7404,	2,	5,	'A',	'2013-01-21'),
(7404,	2,	1,	'A',	'2013-01-22'),
(8638,	6,	5,	'E',	'2013-01-25'),
(8638,	6,	5,	'A',	'2013-01-26'),
(7404,	2,	5,	'D',	'2013-02-03')


--Status de contrato A(Ativo), D(Desativado), E(Espera)									
--Um plano só é válido se existe pelo menos um serviço associado a ele									
 
-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos cancelados, ordenados pelo nome do cliente									
select c.NomeCliente,  p.NomePlano, count(co.status) As qtd
from Cliente c, Planos p, Contratos co
where c.CodCliente = co.CodCliente
and co.CodPlano =p.CodPlano
and co.status like 'D%'
group by c.NomeCliente,p.NomePlano
order by c.NomeCliente
-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos não cancelados, ordenados pelo nome do cliente									
select c.NomeCliente,  p.NomePlano, count(co.status) As qtd
from Cliente c, Planos p, Contratos co
where c.CodCliente = co.CodCliente
and co.CodPlano =p.CodPlano
and co.status like 'A%'
 
group by c.NomeCliente,p.NomePlano
order by c.NomeCliente 
-- Consultar o nome do cliente, o nome do plano, e o valor da conta de cada contrato que está ou esteve ativo, sob as seguintes condições:									
--	- A conta é o valor do plano, somado à soma dos valores de todos os serviços	
--	- Caso a conta tenha valor superior a R$400.00, deverá ser incluído um desconto de 8%								
--	- Caso a conta tenha valor entre R$300,00 a R$400.00, deverá ser incluído um desconto de 5%								
--	- Caso a conta tenha valor entre R$200,00 a R$300.00, deverá ser incluído um desconto de 3%								
--	- Contas com valor inferiores a R$200,00 não tem desconto		
select c.NomeCliente, p.NomePlano,
  case when   sum (s.ValorServico + p.ValorPlano)>=400
  then sum (s.ValorServico + p.ValorPlano)*0.92
  when sum (s.ValorServico + p.ValorPlano)>=300
  then sum (s.ValorServico + p.ValorPlano)*0.95
  when sum (s.ValorServico + p.ValorPlano)>=200
  then sum (s.ValorServico + p.ValorPlano)*0.97
  when sum (s.ValorServico + p.ValorPlano)<200
  then sum (s.ValorServico + p.ValorPlano)
  end as Valortotal
from Cliente c, Planos p, Servicos s, Contratos co
where c.CodCliente = co.CodCliente
and p.CodPlano =co.CodPlano
and co.CodServico = s.CodServico
group by  p.NomePlano, c.NomeCliente
 
 
-- Consultar o nome do cliente, o nome do serviço, e a duração, em meses (até a data de hoje) do serviço, dos cliente que nunca cancelaram nenhum plano									
select distinct c.NomeCliente, s.NomeServico ,  DateDiff(month,co.Data_Contrato, GETDATE())as meses
from Cliente c, Servicos s, Planos p, Contratos co
where c.CodCliente = co.CodCliente
and co.CodPlano =p.CodPlano
and co.CodServico = s.CodServico
and co.Status not like 'D%'