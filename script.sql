CREATE SCHEMA IF NOT EXISTS prova_concurso DEFAULT CHARACTER SET utf8 ;
USE prova_concurso ;

-- -----------------------------------------------------
-- Tabela CANDIDATO-ALUNO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CANDIDATO-ALUNO (
  cpf CHAR(11) NOT NULL,
  Nome VARCHAR(45) NOT NULL,
  Telefone VARCHAR(15) NULL,
  Email VARCHAR(25) NULL,
  Data_Nascimento DATE NOT NULL,
  Atendimento_Especial TINYINT(1) NOT NULL DEFAULT 0,
  End_Rua VARCHAR(45) NULL,
  End_Bairro VARCHAR(25) NULL,
  End_Municipio VARCHAR(25) NOT NULL,
  End_UF CHAR(2) NOT NULL,
  PRIMARY KEY (cpf),
  UNIQUE INDEX cpf_UNIQUE (cpf ASC));


-- -----------------------------------------------------
-- Tabela ESCOLA-FACULDADE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ESCOLA-FACULDADE (
  Cod_MEC INT NOT NULL,
  Nome VARCHAR(45) NOT NULL,
  Telefone VARCHAR(15) NULL,
  Email VARCHAR(25) NULL,
  Nome_Contato VARCHAR(45) NOT NULL,
  Disponivel_Local_Prova TINYINT(1) NOT NULL DEFAULT 1,
  End_Rua VARCHAR(45) NULL,
  End_Bairro VARCHAR(25) NULL,
  End_Municipio VARCHAR(25) NOT NULL,
  End_UF CHAR(2) NOT NULL,
  PRIMARY KEY (Cod_MEC),
  UNIQUE INDEX cpf_UNIQUE (Cod_MEC ASC));


-- -----------------------------------------------------
-- Tabela LOCAL-PROVA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS LOCAL-PROVA (
  idLocal INT NOT NULL AUTO_INCREMENT,
  idEscola_Faculdade INT NOT NULL,
  Salas_Disponiveis INT NULL,
  Carteiras_Sala INT NULL,
  Observacao VARCHAR(255) NULL,
  PRIMARY KEY (idLocal),
  UNIQUE INDEX idLocal_UNIQUE (idLocal ASC),
  INDEX fk_LOCAL-PROVA_1_idx (idEscola_Faculdade ASC),
  CONSTRAINT fk_LOCAL-PROVA_1
    FOREIGN KEY (idEscola_Faculdade)
    REFERENCES ESCOLA-FACULDADE (Cod_MEC)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Tabela CONCURSO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CONCURSO (
  idConcurso INT NOT NULL AUTO_INCREMENT,
  Data DATE NOT NULL,
  Titulo VARCHAR(45) NOT NULL,
  Organizador VARCHAR(45) NOT NULL,
  Contato_Organizador VARCHAR(45) NULL,
  PRIMARY KEY (idConcurso),
  UNIQUE INDEX idConcurso_UNIQUE (idConcurso ASC));


-- -----------------------------------------------------
-- Tabela SALA-PROVA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SALA-PROVA (
  idSala INT NOT NULL,
  idLocal_Prova INT NOT NULL,
  Capacidade INT NOT NULL,
  Atendimento_Especial TINYINT(1) NOT NULL DEFAULT 0,
  Acessibilidade TINYINT(1) NOT NULL DEFAULT 1,
  Andar INT NULL DEFAULT 0,
  Observacao VARCHAR(255) NULL,
  PRIMARY KEY (idSala),
  UNIQUE INDEX idSala_UNIQUE (idSala ASC),
  INDEX fk_SALA-PROVA_1_idx (idLocal_Prova ASC),
  CONSTRAINT fk_SALA-PROVA_1
    FOREIGN KEY (idLocal_Prova)
    REFERENCES LOCAL-PROVA (idLocal)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Tabela PROVA-MODELO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PROVA-MODELO (
  idProva INT NOT NULL AUTO_INCREMENT,
  idConcurso INT NOT NULL,
  Descricao VARCHAR(15) NOT NULL,
  Tempo_Prova_Horas DECIMAL NOT NULL,
  Qtd_Questoes_Objetivas INT NOT NULL,
  Qtd_Questoes_Discurssivas INT NULL DEFAULT 0,
  Redacao TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (idProva),
  INDEX fk_PROVA-MODELO_1_idx (idConcurso ASC),
  CONSTRAINT fk_PROVA-MODELO_1
    FOREIGN KEY (idConcurso)
    REFERENCES CONCURSO (idConcurso)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Tabela APLICACAO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS APLICACAO (
  idAplicacao INT NOT NULL,
  idProva INT NOT NULL,
  idSala INT NOT NULL,
  idCandidato CHAR(11) NOT NULL,
  Nota_Final INT NULL,
  Prova_Valida TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (idAplicacao),
  UNIQUE INDEX idAplicacao_UNIQUE (idAplicacao ASC),
  INDEX fk_APLICACAO_1_idx (idSala ASC),
  INDEX fk_APLICACAO_2_idx (idCandidato ASC),
  INDEX fk_APLICACAO_3_idx (idProva ASC),
  CONSTRAINT fk_APLICACAO_1
    FOREIGN KEY (idSala)
    REFERENCES SALA-PROVA (idSala)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_APLICACAO_2
    FOREIGN KEY (idCandidato)
    REFERENCES CANDIDATO-ALUNO (cpf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_APLICACAO_3
    FOREIGN KEY (idProva)
    REFERENCES PROVA-MODELO (idProva)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Tabela OCORRENCIA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS OCORRENCIA (
  idOcorrencia INT NOT NULL AUTO_INCREMENT,
  idAplicacao INT NOT NULL,
  Tipo ENUM('Supeita de cola', 'Candidato sem documento', 'Prova sem assinatura', 'Lista de presença sem assinatura', 'Outros') NOT NULL,
  Status ENUM('Concluida', 'Em tratamento', 'Aberta') NOT NULL,
  Tratamento VARCHAR(255) NULL,
  Data_Atualizacao DATETIME NULL,
  PRIMARY KEY (idOcorrencia),
  UNIQUE INDEX idOcorrencia_UNIQUE (idOcorrencia ASC),
  INDEX fk_OCORRENCIA_1_idx (idAplicacao ASC),
  CONSTRAINT fk_OCORRENCIA_1
    FOREIGN KEY (idAplicacao)
    REFERENCES APLICACAO (idAplicacao)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Tabela ESCOLA-ALUNO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ESCOLA-ALUNO (
  idEscola INT NOT NULL,
  idAluno CHAR(11) NOT NULL,
  Curso VARCHAR(25) NULL,
  Ano_Serie VARCHAR(10) NULL,
  PRIMARY KEY (idEscola, idAluno),
  INDEX fk_ESCOLA-ALUNO_1_idx (idAluno ASC),
  CONSTRAINT fk_ESCOLA-ALUNO_1
    FOREIGN KEY (idAluno)
    REFERENCES CANDIDATO-ALUNO (cpf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ESCOLA-ALUNO_2
    FOREIGN KEY (idEscola)
    REFERENCES ESCOLA-FACULDADE (Cod_MEC)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);