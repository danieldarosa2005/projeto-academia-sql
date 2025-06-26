
CREATE DATABASE IF NOT EXISTS academia;
USE academia;

CREATE TABLE alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15)
);

CREATE TABLE instrutores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100),
    telefone VARCHAR(15)
);

CREATE TABLE planos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    duracao_meses INT NOT NULL
);

CREATE TABLE aulas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    horario TIME NOT NULL,
    dias_semana VARCHAR(20),
    instrutor_id INT,
    FOREIGN KEY (instrutor_id) REFERENCES instrutores(id)
);

CREATE TABLE matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT,
    plano_id INT,
    data_inicio DATE,
    data_fim DATE,
    FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    FOREIGN KEY (plano_id) REFERENCES planos(id)
);

CREATE TABLE aluno_aula (
    aluno_id INT,
    aula_id INT,
    PRIMARY KEY (aluno_id, aula_id),
    FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    FOREIGN KEY (aula_id) REFERENCES aulas(id)
);

CREATE TABLE pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula_id INT,
    data_pagamento DATE NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    metodo_pagamento VARCHAR(20),
    FOREIGN KEY (matricula_id) REFERENCES matriculas(id)
);

INSERT INTO instrutores (nome, especialidade, telefone) VALUES
('Carlos Souza', 'Musculação', '11988887777'),
('Fernanda Lima', 'Funcional', '11999996666'),
('Rafael Torres', 'Pilates', '11888885555');

INSERT INTO planos (nome, preco, duracao_meses) VALUES
('Mensal', 100.00, 1),
('Trimestral', 270.00, 3),
('Anual', 1000.00, 12);

INSERT INTO alunos (nome, cpf, data_nascimento, telefone) VALUES
('João Silva', '123.456.789-00', '2000-01-15', '11999999999'),
('Maria Oliveira', '987.654.321-00', '1995-06-10', '11888888888');

INSERT INTO aulas (nome, horario, dias_semana, instrutor_id) VALUES
('Musculação', '08:00:00', 'Seg a Sex', 1),
('Funcional', '18:00:00', 'Seg, Qua, Sex', 2),
('Pilates', '07:30:00', 'Ter e Qui', 3);

INSERT INTO matriculas (aluno_id, plano_id, data_inicio, data_fim) VALUES
(1, 1, '2025-06-01', '2025-06-30'),
(2, 2, '2025-06-10', '2025-09-10');

INSERT INTO aluno_aula (aluno_id, aula_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3);

INSERT INTO pagamentos (matricula_id, data_pagamento, valor_pago, metodo_pagamento) VALUES
(1, '2025-06-01', 100.00, 'PIX'),
(2, '2025-06-10', 270.00, 'Cartão');

SELECT * FROM alunos;

-- Lista de aulas e seus instrutores
SELECT aulas.nome AS aula, aulas.horario, instrutores.nome AS instrutor
FROM aulas
JOIN instrutores ON aulas.instrutor_id = instrutores.id;

-- Ver matrículas dos alunos com nome do plano
SELECT alunos.nome AS aluno, planos.nome AS plano, matriculas.data_inicio, matriculas.data_fim
FROM matriculas
JOIN alunos ON matriculas.aluno_id = alunos.id
JOIN planos ON matriculas.plano_id = planos.id;

-- Ver pagamentos feitos
SELECT pagamentos.*, alunos.nome AS aluno
FROM pagamentos
JOIN matriculas ON pagamentos.matricula_id = matriculas.id
JOIN alunos ON matriculas.aluno_id = alunos.id;

-- Atualizar telefone do aluno João
UPDATE alunos
SET telefone = '11911112222'
WHERE nome = 'João Silva';

-- Atualizar valor do plano mensal
UPDATE planos
SET preco = 120.00
WHERE nome = 'Mensal';

-- Excluir uma aula específica
DELETE FROM aulas
WHERE nome = 'Pilates';

-- Excluir um aluno (os relacionamentos dele precisam ser removidos antes)
DELETE FROM aluno_aula
WHERE aluno_id = 1;

DELETE FROM matriculas
WHERE aluno_id = 1;

DELETE FROM alunos
WHERE id = 1;
