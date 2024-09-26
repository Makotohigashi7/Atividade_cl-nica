-- Eli Makoto Higashi Matias

-- RGM: 11221101848
 
-- Criação do Banco Clínica Veterinária

CREATE DATABASE Clinicaveterinaria;

USE Clinicaveterinaria;
 
-- Criação da tabela pacientes

CREATE TABLE pacientes ( id_paciente INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR (100), especie VARCHAR(50), idade INT );
 
-- Inserindo valores nos campos da tabela pacientes

INSERT INTO pacientes (nome, especie, idade) VALUES ('Pipoca','Gato','7'),('Bela','Papagaio','10'),('Bolt','Cachorro','14');

SELECT * FROM pacientes;
 
-- Criação da tabela veterinarios

CREATE TABLE veterinarios (id_veterinario INT
PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(100),
especialidade VARCHAR(50));
 
-- Inserindo valores nos campos da tabela veterinários

INSERT INTO veterinarios (nome, especialidade )VALUES ('Leticia Ribeiro','Veterinária'),('Nicole Monteiro','Veterinária'),('Camila Neves','Veterinária');

SELECT * FROM veterinarios;
 
-- Criação da tabela consultas

CREATE TABLE consultas (

   id_consulta INT AUTO_INCREMENT PRIMARY KEY,
   id_paciente INT,
   id_veterinario INT,
   data_consulta DATE NOT NULL,
   custo DECIMAL(10, 2) NOT NULL,
   FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
   FOREIGN KEY (id_veterinario) REFERENCES veterinarios(id_veterinario)

);
 
-- Criação de Procedure agendar a consulta

DELIMITER //

CREATE PROCEDURE agendar_consulta(IN pr_id_paciente INT, IN pr_id_veterinario INT,

pr_data_consulta DATE, pr_custo DECIMAL (10,2))

BEGIN

INSERT INTO Consultas (id_paciente, id_veterinario, data_consulta, custo)
VALUES (pr_id_paciente, pr_id_veterinario, pr_data_consulta, pr_custo);

END //

DELIMITER ;

-- Agendar as consultas

CALL agendar_consulta(1, 1, '2024-07-10', 150.00);
CALL agendar_consulta(2, 2, '2024-07-20', 120.00);
CALL agendar_consulta(3, 3, '2024-07-21', 140.00);

SELECT * FROM consultas;
 
 
 
-- Criação de Procedure para atualizar o paciente

DELIMITER //

CREATE PROCEDURE atualizar_paciente(IN pr_id_paciente INT, IN pr_novo_nome VARCHAR (100),

pr_nova_especie VARCHAR (50), pr_nova_idade INT)

BEGIN

UPDATE pacientes

   SET nome = pr_novo_nome,
       especie = pr_nova_especie,
       idade = pr_nova_idade
 WHERE id_paciente = pr_id_paciente;

END //

DELIMITER ;

-- Atualizar os pacientes

CALL atualizar_paciente('1','Cacau','Coelho','1');
CALL atualizar_paciente('2','Spike','Iguana','10');
CALL atualizar_paciente('3','Thor','Peixe','3');

SELECT * FROM pacientes;
 
 
-- Criação de Procedure para remover a consulta do paciente

DELIMITER //

CREATE PROCEDURE remover_consulta(IN pr_id_consulta INT)

BEGIN

DELETE FROM consultas

WHERE id_consulta = pr_id_consulta;

END //

DELIMITER ;

-- Remover as consultas

CALL remover_consulta(1);
CALL remover_consulta(2);
CALL remover_consulta(3);
 SELECT * FROM consultas;

-- Agendar as consultas

CALL agendar_consulta(1, 1, '2024-07-10', 150.00);
CALL agendar_consulta(2, 2, '2024-07-20', 120.00);
CALL agendar_consulta(3, 3, '2024-07-21', 140.00);

 SELECT * FROM consultas;
 
 
-- Function para saber o valor total gasto pelo paciente

DELIMITER //

CREATE FUNCTION total_gasto_paciente(pr_id_paciente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN

   DECLARE total DECIMAL(10,2);
   SELECT SUM(custo) INTO total
   FROM consultas
   WHERE id_paciente = pr_id_paciente;
   IF total IS NULL THEN

       SET total = 0.00;

   END IF;

   RETURN total;

END //

DELIMITER ;
 
SELECT p.id_paciente, p.nome, IFNULL(SUM(c.custo), 0.00) 
AS total_gasto FROM pacientes p LEFT JOIN 
consultas c ON p.id_paciente = c.id_paciente
GROUP BY p.id_paciente, p.nome;
 
-- Trigger para verificar a idade do paciente

DELIMITER //

CREATE TRIGGER verificar_idade_paciente

BEFORE INSERT ON pacientes

FOR EACH ROW

BEGIN

   
   IF NEW.idade <= 0 THEN

       SIGNAL SQLSTATE '45000'

       SET MESSAGE_TEXT = 'A idade do paciente deve ser um número positivo.';

   END IF;

END //

DELIMITER ;

INSERT INTO pacientes (nome, especie, idade) VALUES ('Mini', 'Papagaio', -7);

 
-- Criação da tabela de log

CREATE TABLE log_de_consultas (

   id_log INT PRIMARY KEY AUTO_INCREMENT,

   id_consulta INT,

   custo DECIMAL(10, 2),

   custo_novo DECIMAL(10, 2),

   FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta)

);
 
-- Criação da Trigger para registrar alterações de custo

DELIMITER //

CREATE TRIGGER atualizar_custo_consulta
AFTER UPDATE ON consultas
FOR EACH ROW
BEGIN

   IF OLD.custo <> NEW.custo THEN
      INSERT INTO log_de_consultas (id_consulta, custo, custo_novo)
      VALUES (OLD.id_consulta, OLD.custo, NEW.custo);

   END IF;

END //

DELIMITER ;

SELECT * FROM consultas;

-- Atualizar o custo das consultas

UPDATE consultas SET custo = 210.00 WHERE id_consulta = 4;
UPDATE consultas SET custo = 70.00 WHERE id_consulta = 5;
UPDATE consultas SET custo = 21.00 WHERE id_consulta = 6;
 

SELECT * FROM log_de_consultas;
 
 

 
 
-- Continuação
 
-- tabelas


-- Criação da tabela diagnóstico

CREATE TABLE diagnostico
(id_diagnostico INT PRIMARY KEY AUTO_INCREMENT,
resultado_diagnostico VARCHAR (40), gravidade VARCHAR (40));

-- Inserindo valores na tabela diagnóstico

INSERT INTO diagnostico (resultado_diagnostico, gravidade ) VALUES ('Fratura na pata dianteira direita','Média'),('Catarata nos olhos','Alta'),('linfoma','Muito Alta');

SELECT * FROM diagnostico;




-- Criação da tabela procedimento

 CREATE TABLE procedimento
 (id_procedimento INT PRIMARY KEY AUTO_INCREMENT, 
 tipo_procedimento VARCHAR (40),
 data_procedimento DATE,
 valor_procedimento DECIMAL(10,2));
 
 -- Inserindo valores na tabela procedimento
 
 INSERT INTO procedimento (tipo_procedimento, data_procedimento, valor_procedimento) VALUES ('Engessar','2024-12-12',121.70),('Cirurgia','2024-12-13',710.70),('Cirurgia','2024-12-21',1477.70);
 
 SELECT * FROM procedimento;
 


 
 -- Criação da tabela medicamento
 
 CREATE TABLE medicamento
 (id_medicamento INT PRIMARY KEY AUTO_INCREMENT,
 nome_remedio VARCHAR (40),
 tipo_remedio VARCHAR (40),
 valor_remedio DECIMAL(10,2));
 
 -- Inserindo valores na tabela medicamento

INSERT INTO medicamento (nome_remedio, tipo_remedio, valor_remedio ) VALUES
('Carprofeno','Anti-inflamatório',122.80),
('Prednisolona','Anti-inflamatório',140.20),
('Doxorrubicina',' Quimioterápico',704.70),
('Ringer Lactato','Soluções de Hidratação',21.70);

 SELECT * FROM medicamento;




 -- Triggers
 
 -- Trigger para alterar o valor do procedimento
 
DELIMITER //

CREATE TRIGGER ajustar_valor_procedimento
BEFORE INSERT ON procedimento
FOR EACH ROW
BEGIN
    SET NEW.valor_procedimento = NEW.valor_procedimento * 1.10; 
END;

//

CREATE TRIGGER ajustar_valor_procedimento_update
BEFORE UPDATE ON procedimento
FOR EACH ROW
BEGIN
    SET NEW.valor_procedimento = NEW.valor_procedimento * 1.10; 
END;

//

DELIMITER ;

UPDATE procedimento 
SET valor_procedimento = 221 
WHERE id_procedimento = 1;

SELECT * FROM procedimento;



-- Trigger para substituir o remédio indicado

DELIMITER //

CREATE TRIGGER substituir_nome_remedio
BEFORE INSERT ON medicamento
FOR EACH ROW
BEGIN
    IF NEW.nome_remedio = 'Carprofeno' THEN
        SET NEW.nome_remedio = 'Meloxicam';
    END IF;
END;

//

DELIMITER ;


DELIMITER //

CREATE TRIGGER substituir_nome_remedio_update
BEFORE UPDATE ON medicamento
FOR EACH ROW
BEGIN
    IF NEW.nome_remedio = 'Carprofeno' THEN
        SET NEW.nome_remedio = 'Meloxicam';
    END IF;
END;

//

DELIMITER ;


UPDATE medicamento 
SET nome_remedio = 'Meloxicam'
WHERE id_medicamento = 1;

SELECT * FROM medicamento;




-- Trigger para alterar o valor do remédio

DELIMITER //

CREATE TRIGGER ajustar_valor_remedio
BEFORE INSERT ON medicamento
FOR EACH ROW
BEGIN
    SET NEW.valor_remedio = NEW.valor_remedio * 1.15; 
END;

//

DELIMITER ;


DELIMITER //

CREATE TRIGGER ajustar_valor_remedio_update
BEFORE UPDATE ON medicamento
FOR EACH ROW
BEGIN
    SET NEW.valor_remedio = NEW.valor_remedio * 1.15; 
END;

//

DELIMITER ;
 
 
UPDATE medicamento 
SET valor_remedio = 210.00 
WHERE id_medicamento = 1; 

SELECT * FROM medicamento;




-- Trigger para alterar o diagnóstico do paciente

DELIMITER //

CREATE TRIGGER atualizar_resultado_diagnostico
BEFORE UPDATE ON diagnostico
FOR EACH ROW
BEGIN
    SET NEW.resultado_diagnostico = 'Verme do coração'; 
END;

//

DELIMITER ;



UPDATE diagnostico 
SET gravidade = 'Muito alta' 
WHERE id_diagnostico = 1; 

SELECT * FROM diagnostico;




-- Trigger para impedir que o valor do procedimento seja menor ou igual a 0

DELIMITER //

CREATE TRIGGER verificar_valor_procedimento
BEFORE INSERT ON procedimento
FOR EACH ROW
BEGIN
    IF NEW.valor_procedimento <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro!!! O valor do procedimento não pode ser menor ou igual a 0.';
    END IF;
END;

//

DELIMITER ;

INSERT INTO procedimento (tipo_procedimento, data_procedimento, valor_procedimento) VALUES ('Engessar', '2024-12-07', -10);






 -- procedures
 

 -- Criação de Procedure para cancelar o procedimento do paciente
 
 DELIMITER //

CREATE PROCEDURE cancelar_procedimento(IN procedimento_id INT)
BEGIN
    DECLARE num_procedimentos INT;

    
    SELECT COUNT(*) INTO num_procedimentos 
    FROM procedimento 
    WHERE id_procedimento = procedimento_id;

    IF num_procedimentos = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro!!! Procedimento não encontrado.';
    ELSE
        
        DELETE FROM procedimento WHERE id_procedimento = procedimento_id;
        SELECT 'Procedimento cancelado.' AS mensagem;
    END IF;
END;

//

DELIMITER ;

CALL cancelar_procedimento(1); 

SELECT * FROM procedimento;

 
 
 -- Criação de Procedure para impedir que a data do procedimento seja em 2025

 DELIMITER //

CREATE PROCEDURE adicionar_procedimento(
    IN tipo_proc VARCHAR(40),
    IN data_proc DATE,
    IN valor_proc DECIMAL(10,2),
    IN id_paciente INT
)
BEGIN
    
    IF YEAR(data_proc) = 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: A data do procedimento não pode ser em 2025.';
    ELSE
        
        INSERT INTO procedimento (tipo_procedimento, data_procedimento, valor_procedimento, id_paciente)
        VALUES (tipo_proc, data_proc, valor_proc, id_paciente);
        SELECT 'Procedimento adicionado com sucesso.' AS mensagem;
    END IF;
END;

//

DELIMITER ;


CALL adicionar_procedimento('Cirurgia', '2025-01-15', 1500.00, 1); 



-- Criação de Procedure para impedir que o valor do remédio seja menor ou igual a 0

DELIMITER //

CREATE PROCEDURE adicionar_medicamento(
    IN nome_remedio VARCHAR(40),
    IN tipo_remedio VARCHAR(40),
    IN valor_remedio DECIMAL(10,2)
)
BEGIN
  
    IF valor_remedio <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: O valor do remédio não pode ser menor ou igual a 0.';
    ELSE
        
        INSERT INTO medicamento (nome_remedio, tipo_remedio, valor_remedio)
        VALUES (nome_remedio, tipo_remedio, valor_remedio);
        SELECT 'Remédio adicionado com sucesso.' AS mensagem;
    END IF;
END;

//

DELIMITER ;

CALL adicionar_medicamento('Paracetamol', 'Analgesico', 0); 
 


-- Criação de Procedure para somar os valores dos procedimentos de todos os dias

DELIMITER //

CREATE PROCEDURE somar_todos_procedimentos(
    OUT total_valor DECIMAL(10, 2)
)
BEGIN
    
    SET total_valor = 0;

    
    SELECT SUM(valor_procedimento) INTO total_valor
    FROM procedimento;

    
END;

//

DELIMITER ;

 SELECT * FROM procedimento;

CALL somar_todos_procedimentos(@total);

SELECT @total AS Total_Procedimentos;




-- Criação de Procedure para somar os valores dos remédios

DELIMITER //

CREATE PROCEDURE SomarTodosOsValores()
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(valor_remedio) INTO total
    FROM medicamento;

    SELECT total AS TotalValoresMedicamentos;
END //

DELIMITER ;


 SELECT * FROM medicamento;

CALL SomarTodosOsValores();

