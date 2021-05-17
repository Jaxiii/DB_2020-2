CREATE TYPE "vacina_status" AS ENUM (
  'out_of_stock',
  'in_stock',
  'running_low'
);

CREATE TABLE "cidadao" (
  "cpf" SERIAL PRIMARY KEY,
  "nome" varchar,
  "data_nascimento" date,
  "endereco_fk" int,
  "profissao_fk" int
);

CREATE TABLE "endereco" (
  "cep" int PRIMARY KEY,
  "cidade_fk" varchar,
  "rua" varchar,
  "bairro" varchar,
  "numero" int
);

CREATE TABLE "cidade" (
  "sigla" varchar PRIMARY KEY,
  "estado_fk" varchar,
  "nome" varchar
);

CREATE TABLE "estado" (
  "sigla" varchar PRIMARY KEY,
  "nome" varchar
);

CREATE TABLE "aplicacao" (
  "data_aplicacao" date,
  "aplicado" int,
  "quantity" int DEFAULT 1,
  "aplicador_cpf" int,
  "aplicador_registro" int,
  "vacina_lote" int,
  "vacina_fabricante" int,
  PRIMARY KEY ("data_aplicacao", "vacina_lote", "aplicador_registro", "aplicado")
);

CREATE TABLE "vacina" (
  "num_lote" int,
  "nome" varchar,
  "data_fabricacao" date,
  "fabricante_fk" int,
  "status" vacina_status,
  PRIMARY KEY ("fabricante_fk", "num_lote")
);

CREATE TABLE "local_vacinacao" (
  "num_registro" int PRIMARY KEY,
  "endereco_fk" int,
  "resp_registro" int,
  "resp_cpf" int
);

CREATE TABLE "fornecedor" (
  "cnpj" int PRIMARY KEY,
  "nome" varchar
);

CREATE TABLE "aplicador" (
  "registro" int,
  "cpf" int,
  "resp_registro" int,
  "resp_cpf" int,
  PRIMARY KEY ("registro", "cpf")
);

CREATE TABLE "profissao" (
  "num_registro" int PRIMARY KEY,
  "nome" varchar
);

CREATE TABLE "responsavel" (
  "registro" int,
  "cpf" int,
  "local_fk" int,
  PRIMARY KEY ("registro", "cpf")
);

CREATE TABLE "politico" (
  "partido" varchar,
  "cidade_fk" varchar,
  "cpf" int,
  PRIMARY KEY ("cpf", "cidade_fk")
);

ALTER TABLE "cidadao" ADD FOREIGN KEY ("endereco_fk") REFERENCES "endereco" ("cep");

ALTER TABLE "cidadao" ADD FOREIGN KEY ("profissao_fk") REFERENCES "profissao" ("num_registro");

ALTER TABLE "endereco" ADD FOREIGN KEY ("cidade_fk") REFERENCES "cidade" ("sigla");

ALTER TABLE "cidade" ADD FOREIGN KEY ("estado_fk") REFERENCES "estado" ("sigla");

ALTER TABLE "aplicacao" ADD FOREIGN KEY ("vacina_fabricante", "vacina_lote") REFERENCES "vacina" ("fabricante_fk", "num_lote");

ALTER TABLE "aplicacao" ADD FOREIGN KEY ("aplicado") REFERENCES "cidadao" ("cpf");

ALTER TABLE "aplicacao" ADD FOREIGN KEY ("aplicador_cpf", "aplicador_registro") REFERENCES "aplicador" ("cpf", "registro");

ALTER TABLE "aplicacao" ADD FOREIGN KEY ("vacina_lote", "vacina_fabricante") REFERENCES "vacina" ("num_lote", "fabricante_fk");

ALTER TABLE "vacina" ADD FOREIGN KEY ("fabricante_fk") REFERENCES "fornecedor" ("cnpj");

ALTER TABLE "local_vacinacao" ADD FOREIGN KEY ("endereco_fk") REFERENCES "endereco" ("cep");

ALTER TABLE "local_vacinacao" ADD FOREIGN KEY ("resp_registro", "resp_cpf") REFERENCES "responsavel" ("registro","cpf");

ALTER TABLE "responsavel" ADD FOREIGN KEY ("local_fk") REFERENCES "local_vacinacao" ("num_registro");

ALTER TABLE "aplicador" ADD FOREIGN KEY ("cpf") REFERENCES "cidadao" ("cpf");

ALTER TABLE "aplicador" ADD FOREIGN KEY ("resp_registro", "resp_cpf") REFERENCES "responsavel" ("registro","cpf");

ALTER TABLE "responsavel" ADD FOREIGN KEY ("cpf") REFERENCES "cidadao" ("cpf");

ALTER TABLE "politico" ADD FOREIGN KEY ("cidade_fk") REFERENCES "cidade" ("sigla");

ALTER TABLE "politico" ADD FOREIGN KEY ("cpf") REFERENCES "cidadao" ("cpf");


INSERT INTO estado(sigla, nome) VALUES ('DF', 'Distrito Federal');
INSERT INTO estado(sigla, nome) VALUES ('SP', 'São Paulo');
INSERT INTO estado(sigla, nome) VALUES ('AM', 'Amazonas');
INSERT INTO estado(sigla, nome) VALUES ('ES', 'Espírito Santo');
INSERT INTO estado(sigla, nome) VALUES ('RS', 'Rio Grande do Sul');
INSERT INTO estado(sigla, nome) VALUES ('PE', 'Pernanbuco');

INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('BSB', 'DF', 'Brasília');
INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('CGH', 'SP', 'São Paulo');
INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('VIX', 'ES', 'Vitória');
INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('MAO', 'AM', 'Manaus');
INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('POA', 'RS', 'Porto Alegre');
INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('GRU', 'SP', 'Guarulhos');
INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('REC', 'PE', 'Recife');
INSERT INTO cidade(sigla, estado_fk, nome) VALUES ('VCP', 'SP', 'Campinas');

INSERT INTO profissao (num_registro, nome) VALUES ('0001', 'Médico');
INSERT INTO profissao (num_registro, nome) VALUES ('0002', 'Enfermeiro');
INSERT INTO profissao (num_registro, nome) VALUES ('0003', 'Administrador');
INSERT INTO profissao (num_registro, nome) VALUES ('0004', 'Engenheiro');
INSERT INTO profissao (num_registro, nome) VALUES ('0005', 'Programador');
INSERT INTO profissao (num_registro, nome) VALUES ('0006', 'Educador Físico');
INSERT INTO profissao (num_registro, nome) VALUES ('0007', 'Professor');


--Politico
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('700000', 'BSB', '310', 'SQN', '602') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '123456789', 'Joao Maria', '11/10/1990', cep, '0001'
FROM moradia;

--Aplicado
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('700001', 'BSB', '112', 'SQS', '601') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '987654321', 'Maria Joao', '10/06/1995', cep, '0003'
FROM moradia;

--Resp
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('7030303', 'MAO', 'Avenida São Miguel', 'Zona Norte', '1001	') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '020202020', 'Jonas Marcos', '01/12/1983', cep, '0002'
FROM moradia;

--Aplicador
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('748303', 'MAO', 'Avenida São Lucas', 'Zona Sul', '103') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '03030303', 'Jaco Vinicus', '03/11/1988', cep, '0002'
FROM moradia;

--Aplicado
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('8003001', 'REC', 'Presidente Vicente', 'Mapoa', '2014') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '123123123', 'Ana Beatriz', '12/30/1998', cep, '0005'
FROM moradia;

--Aplicado
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('7876747', 'CGH', 'Passo Curto', 'Gonzaga', '6001') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '0807060504', 'Leticia Braga', '03/25/1976', cep, '0007'
FROM moradia;

--Resp
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('704883', 'MAO', 'Avenida Marcos Gonzales', 'Zona Sul', '400') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '040302847', 'Priscila Silva', '07/23/1990', cep, '0001'
FROM moradia;

--Aplicador
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('558333', 'MAO', 'Avenida Grande Rua', 'Zona Sul', '1040') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '0404040404', 'Amanda Silva', '01/21/1991', cep, '0002'
FROM moradia;

--Resp
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('838483', 'REC', 'Tabuabe', 'Itapora', '614') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '0683726146', 'Thales Rodrigues', '06/14/1993', cep, '0002'
FROM moradia;

--Aplicador
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('010394', 'REC', 'Tucano', 'Beija-flor', '441') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '333777773', 'Marta Braga', '03/09/1990', cep, '0002'
FROM moradia;

--Resp
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('3948382', 'CGH', 'Marcos Vinicius', 'Zona Leste', '1004') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '080462845', 'Gustavo Motta', '02/06/1989', cep, '0001'
FROM moradia;

--Aplicador
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('3746382', 'CGH', 'Avenida Paulista', 'Zona Central', '4694') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '01393842', 'Thiago Cardozo', '07/19/1988', cep, '0001'
FROM moradia;

--Politico
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('8183723', 'REC', 'Tabuabe', 'Itapora', '614') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '043348332', 'Marcos Gomes', '02/17/1992', cep, '0004'
FROM moradia;

--Politico
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('483746', 'VIX', 'LSN', 'Alto Sul', '1044') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '372748573', 'Andre Silva', '01/005/1983', cep, '0005'
FROM moradia;

--Politico
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('4657384', 'REC', 'Rua Velha', 'Taquaca', '344') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '583757493', 'Marcos Britto', '10/13/1991', cep, '0006'
FROM moradia;

--Aplicado
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('4627638', 'VIX', 'Avenida Silva', 'Homperus', '44') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '364757382', 'Rafael Gustavo', '12/03/1988', cep, '0005'
FROM moradia;

--Politico
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('2947562', 'CGH', 'Gato Bonito', 'Fundao', '114') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '484756382', 'Carlos Almeida', '09/07/1974', cep, '0004'
FROM moradia;

--Resp
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('4827646', 'VCP', 'Grande Avenida', 'Zona Norte', '1014') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '573897536', 'Felipe Franco', '04/13/1953', cep, '0002'
FROM moradia;

--Aplicador
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('4857352', 'VCP', 'Voadouro', 'Baixada', '467') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '4857294', 'Vânia Cavo', '09/11/1964', cep, '0002'
FROM moradia;

--Aplicado
WITH moradia AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('42847557', 'VCP', 'Pequena Avenida', 'Zona Norte', '1614') RETURNING cep
)
INSERT INTO cidadao (cpf, nome, data_nascimento, endereco_fk, profissao_fk)
SELECT '465758285', 'Vitoria Abrão', '07/13/1991', cep, '0004'
FROM moradia;

INSERT INTO politico (partido, cidade_fk, cpf) VALUES ('MDB', 'VIX', '372748573');
INSERT INTO politico (partido, cidade_fk, cpf) VALUES ('PT', 'CGH', '583757493');
INSERT INTO politico (partido, cidade_fk, cpf) VALUES ('PDT', 'REC', '484756382');
INSERT INTO politico (partido, cidade_fk, cpf) VALUES ('SOL', 'BSB', '123456789');
INSERT INTO politico (partido, cidade_fk, cpf) VALUES ('REDE', 'REC', '043348332');

INSERT INTO fornecedor (cnpj, nome) VALUES ('1039394', 'Pfizer');
INSERT INTO fornecedor (cnpj, nome) VALUES ('4857667', 'Moderna');
INSERT INTO fornecedor (cnpj, nome) VALUES ('4757583', 'Astrazeneca');
INSERT INTO fornecedor (cnpj, nome) VALUES ('4957472', 'Johnson & Johnson');
INSERT INTO fornecedor (cnpj, nome) VALUES ('9274656', ' ');
INSERT INTO fornecedor (cnpj, nome) VALUES ('3857574', 'Fiocruz');
INSERT INTO fornecedor (cnpj, nome) VALUES ('5637489', 'Novartis');
INSERT INTO fornecedor (cnpj, nome) VALUES ('2945775', 'Sinovac Biotech');

INSERT INTO vacina(num_lote, nome, data_fabricacao, fabricante_fk) VALUES ('00002', 'CoronaVac', '04/12/2021', '2945775');
INSERT INTO vacina(num_lote, nome, data_fabricacao, fabricante_fk) VALUES ('00234', 'AZD1222', '03/16/2021', '4757583');
INSERT INTO vacina(num_lote, nome, data_fabricacao, fabricante_fk) VALUES ('00034', 'BNT162', '05/02/2021', '1039394');
INSERT INTO vacina(num_lote, nome, data_fabricacao, fabricante_fk) VALUES ('00001', 'mRNA 1273', '02/03/2021', '4857667');
INSERT INTO vacina(num_lote, nome, data_fabricacao, fabricante_fk) VALUES ('00003', 'Ad26 SARS-CoV-2', '03/26/2021', '4957472');
INSERT INTO vacina(num_lote, nome, data_fabricacao, fabricante_fk) VALUES ('00044', 'ButanVac', '04/11/2021', '9274656');
INSERT INTO vacina(num_lote, nome, data_fabricacao, fabricante_fk) VALUES ('00055', 'Covaxin', '04/11/2021', '3857574');

INSERT INTO responsavel(registro, cpf) VALUES ('55555', '020202020');
INSERT INTO responsavel(registro, cpf) VALUES ('44444', '040302847');
INSERT INTO responsavel(registro, cpf) VALUES ('11111', '080462845');
INSERT INTO responsavel(registro, cpf) VALUES ('22222', '573897536');
INSERT INTO responsavel(registro, cpf) VALUES ('99999', '0683726146');

INSERT INTO aplicador(registro, cpf, resp_registro) VALUES ('050505', '03030303','55555');
INSERT INTO aplicador(registro, cpf, resp_registro) VALUES ('040404', '0404040404','44444');
INSERT INTO aplicador(registro, cpf, resp_registro) VALUES ('010101', '333777773','11111');
INSERT INTO aplicador(registro, cpf, resp_registro) VALUES ('020202', '01393842','22222');
INSERT INTO aplicador(registro, cpf, resp_registro) VALUES ('090909', '4857294','99999');

WITH localizacao AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('4758362', 'MAO', 'Pequena Rua', 'Zona Oeste', '3855') RETURNING cep
)
INSERT INTO local_vacinacao (num_registro, endereco_fk, resp_registro, resp_cpf)
SELECT '005005', cep, '55555', '020202020'
FROM localizacao;

WITH localizacao AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('483753', 'MAO', 'Pequena Rua', 'Zona Oeste', '4445') RETURNING cep
)
INSERT INTO local_vacinacao (num_registro, endereco_fk, resp_registro, resp_cpf)
SELECT '004004', cep, '44444', '040302847'
FROM localizacao;

WITH localizacao AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('485736', 'VCP', 'Setor de Hospitais', 'Zona Central', '55') RETURNING cep
)
INSERT INTO local_vacinacao (num_registro, endereco_fk, resp_registro, resp_cpf)
SELECT '002002', cep, '22222', '573897536'
FROM localizacao;

WITH localizacao AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('937462', 'REC', 'Porto', 'Zona Central', '382') RETURNING cep
)
INSERT INTO local_vacinacao (num_registro, endereco_fk, resp_registro, resp_cpf)
SELECT '003003', cep, '99999', '0683726146'
FROM localizacao;

WITH localizacao AS (
   INSERT INTO endereco(cep, cidade_fk, rua, bairro, numero) VALUES ('7362527', 'CGH', 'Aeroporto', 'Zona Central', '4736') RETURNING cep
)
INSERT INTO local_vacinacao (num_registro, endereco_fk, resp_registro, resp_cpf)
SELECT '006006', cep, '11111', '080462845'
FROM localizacao;

INSERT INTO aplicacao(data_aplicacao, aplicado, aplicador_cpf, aplicador_registro, vacina_lote,vacina_fabricante) VALUES ('04/01/2021', '465758285', '4857294', '090909', '00002', '2945775');
INSERT INTO aplicacao(data_aplicacao, aplicado, aplicador_cpf, aplicador_registro, vacina_lote,vacina_fabricante) VALUES ('04/02/2021', '364757382', '4857294', '090909', '00001', '4857667');
INSERT INTO aplicacao(data_aplicacao, aplicado, aplicador_cpf, aplicador_registro, vacina_lote,vacina_fabricante) VALUES ('04/03/2021', '0807060504', '01393842', '020202', '00044', '9274656');
INSERT INTO aplicacao(data_aplicacao, aplicado, aplicador_cpf, aplicador_registro, vacina_lote,vacina_fabricante) VALUES ('04/04/2021', '123123123', '333777773', '010101', '00234', '4757583');
INSERT INTO aplicacao(data_aplicacao, aplicado, aplicador_cpf, aplicador_registro, vacina_lote,vacina_fabricante) VALUES ('04/05/2021', '987654321', '0404040404', '040404', '00034', '1039394');

CREATE VIEW idadeDosVacinado
 AS SELECT M.*
	FROM cidadao M
	WHERE data_nascimento < '1985-03-01';

CREATE PROCEDURE grupoDeRisco()
LANGUAGE SQL
AS $$
SELECT cpf FROM cidadao WHERE data_nascimento < '1980-12-12';
$$;

CALL grupoDeRisco();














