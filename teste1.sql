-- Ajuste completo e otimização do script SQL

-- Criação da tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do cliente
    nome VARCHAR(100) NOT NULL,                -- Nome completo do cliente
    email VARCHAR(150) NOT NULL UNIQUE,        -- E-mail único para contato
    cpf CHAR(11) NOT NULL UNIQUE,              -- CPF formatado como string (11 caracteres)
    data_nascimento DATE NOT NULL,             -- Data de nascimento do cliente
    telefone VARCHAR(15),                      -- Telefone de contato do cliente
    endereco TEXT,                             -- Endereço completo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp de criação
);

-- Criação da tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do produto
    nome VARCHAR(100) NOT NULL,                -- Nome do produto
    descricao TEXT,                            -- Descrição detalhada do produto
    preco DECIMAL(10, 2) NOT NULL,             -- Preço do produto
    estoque INT NOT NULL,                      -- Quantidade em estoque
    id_fabricante INT,                         -- Referência ao fabricante
    id_categoria INT,                          -- Referência à categoria
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp de criação
    FOREIGN KEY (id_fabricante) REFERENCES fabricante(id_fabricante),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- Criação da tabela de pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único do pedido
    id_cliente INT NOT NULL,                   -- Referência ao cliente
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data e hora do pedido
    total DECIMAL(10, 2) NOT NULL,             -- Valor total do pedido
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Criação da tabela de itens do pedido
CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,    -- Identificador único do item
    id_pedido INT NOT NULL,                    -- Referência ao pedido
    id_produto INT NOT NULL,                   -- Referência ao produto
    quantidade INT NOT NULL,                   -- Quantidade do produto no pedido
    preco_unitario DECIMAL(10, 2) NOT NULL,    -- Preço unitário do produto
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Criação da tabela de fabricantes
CREATE TABLE IF NOT EXISTS fabricante (
    id_fabricante INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do fabricante
    nome VARCHAR(100) NOT NULL,                  -- Nome do fabricante
    endereco TEXT,                               -- Endereço do fabricante
    telefone VARCHAR(15),                        -- Telefone do fabricante
    email VARCHAR(150) UNIQUE                    -- E-mail do fabricante
);

-- Criação da tabela de categorias
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único da categoria
    nome VARCHAR(100) NOT NULL UNIQUE,           -- Nome da categoria
    descricao TEXT                               -- Descrição da categoria
);

-- Criação da tabela de estoques
CREATE TABLE IF NOT EXISTS estoque (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,   -- Identificador único do estoque
    id_produto INT NOT NULL,                     -- Referência ao produto
    quantidade INT NOT NULL,                     -- Quantidade em estoque
    id_loja INT,                                 -- Referência à loja
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto),
    FOREIGN KEY (id_loja) REFERENCES loja(id_loja)
);

-- Criação da tabela de lojas
CREATE TABLE IF NOT EXISTS loja (
    id_loja INT AUTO_INCREMENT PRIMARY KEY,      -- Identificador único da loja
    nome VARCHAR(100) NOT NULL,                  -- Nome da loja
    endereco TEXT,                               -- Endereço da loja
    telefone VARCHAR(15),                        -- Telefone da loja
    email VARCHAR(150) UNIQUE                    -- E-mail da loja
);

-- Criação de gatilhos para atualização de estoque após pedidos
DELIMITER //
CREATE TRIGGER atualizar_estoque_após_pedido
AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    UPDATE estoque
    SET quantidade = quantidade - NEW.quantidade
    WHERE id_produto = NEW.id_produto;
END;//
DELIMITER ;

-- Adiciona índices para buscas otimizadas
CREATE INDEX idx_clientes_email ON clientes (email);
CREATE INDEX idx_clientes_cpf ON clientes (cpf);
CREATE INDEX idx_produtos_nome ON produtos (nome);
CREATE INDEX idx_pedidos_cliente ON pedidos (id_cliente);

-- Inserção de valores iniciais em clientes
INSERT IGNORE INTO clientes (nome, email, cpf, data_nascimento, telefone, endereco)
VALUES 
    ('João Silva', 'joao.silva@email.com', '12345678901', '1990-05-20', '(11) 91234-5678', 'Rua A, 123, Cidade A'),
    ('Maria Oliveira', 'maria.oliveira@email.com', '23456789012', '1985-10-12', '(21) 98765-4321', 'Avenida B, 456, Cidade B')
ON DUPLICATE KEY UPDATE email = VALUES(email);

-- Inserção de valores iniciais em produtos
INSERT IGNORE INTO produtos (nome, descricao, preco, estoque, id_fabricante, id_categoria)
VALUES 
    ('Produto A', 'Descrição do Produto A', 49.90, 100, 1, 1),
    ('Produto B', 'Descrição do Produto B', 99.90, 50, 2, 2),
    ('Produto C', 'Descrição do Produto C', 19.90, 200, 3, 3);

-- Inserção de valores iniciais em fabricantes
INSERT IGNORE INTO fabricante (nome, endereco, telefone, email)
VALUES 
    ('Fabricante A', 'Endereço A', '(11) 91234-5678', 'fabricante.a@email.com'),
    ('Fabricante B', 'Endereço B', '(21) 98765-4321', 'fabricante.b@email.com'),
    ('Fabricante C', 'Endereço C', '(31) 99876-5432', 'fabricante.c@email.com');

-- Inserção de valores iniciais em categorias
INSERT IGNORE INTO categoria (nome, descricao)
VALUES 
    ('Categoria 1', 'Descrição da Categoria 1'),
    ('Categoria 2', 'Descrição da Categoria 2'),
    ('Categoria 3', 'Descrição da Categoria 3');

-- Inserção de valores iniciais em lojas
INSERT IGNORE INTO loja (nome, endereco, telefone, email)
VALUES 
    ('Loja A', 'Endereço Loja A', '(11) 91234-5678', 'loja.a@email.com'),
    ('Loja B', 'Endereço Loja B', '(21) 98765-4321', 'loja.b@email.com'),
    ('Loja C', 'Endereço Loja C', '(31) 99876-5432', 'loja.c@email.com');

-- Inserção de valores iniciais em estoques
INSERT IGNORE INTO estoque (id_produto, quantidade, id_loja)
VALUES 
    (1, 50, 1),
    (2, 30, 2),
    (3, 70, 3);
-- Criação da tabela de funcionários
CREATE TABLE IF NOT EXISTS funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do funcionário
    nome VARCHAR(100) NOT NULL,                   -- Nome completo do funcionário
    cpf CHAR(11) NOT NULL UNIQUE,                 -- CPF formatado como string
    telefone VARCHAR(15),                         -- Telefone do funcionário
    endereco TEXT,                                -- Endereço do funcionário
    salario DECIMAL(10, 2) NOT NULL,              -- Salário do funcionário
    data_admissao DATE NOT NULL,                  -- Data de admissão
    tipo_funcionario ENUM('Gerente', 'Atendente') NOT NULL -- Tipo de funcionário
);

-- Criação da tabela de gerentes
CREATE TABLE IF NOT EXISTS gerentes (
    id_gerente INT PRIMARY KEY,                  -- Chave primária (herança de funcionários)
    id_loja INT NOT NULL,                        -- Loja gerenciada
    FOREIGN KEY (id_gerente) REFERENCES funcionarios(id_funcionario),
    FOREIGN KEY (id_loja) REFERENCES loja(id_loja)
);

-- Criação da tabela de atendentes
CREATE TABLE IF NOT EXISTS atendentes (
    id_atendente INT PRIMARY KEY,                -- Chave primária (herança de funcionários)
    id_loja INT NOT NULL,                        -- Loja onde o atendente trabalha
    FOREIGN KEY (id_atendente) REFERENCES funcionarios(id_funcionario),
    FOREIGN KEY (id_loja) REFERENCES loja(id_loja)
);

-- Criação da tabela de compras
CREATE TABLE IF NOT EXISTS compras (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,    -- Identificador único da compra
    id_fornecedor INT NOT NULL,                  -- Fornecedor da compra
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data e hora da compra
    total DECIMAL(10, 2) NOT NULL,               -- Valor total da compra
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Criação da tabela de itens de compra
CREATE TABLE IF NOT EXISTS itens_compra (
    id_item_compra INT AUTO_INCREMENT PRIMARY KEY, -- Identificador único do item
    id_compra INT NOT NULL,                        -- Referência à compra
    id_produto INT NOT NULL,                       -- Referência ao produto comprado
    quantidade INT NOT NULL,                       -- Quantidade do produto
    preco_unitario DECIMAL(10, 2) NOT NULL,        -- Preço unitário do produto
    FOREIGN KEY (id_compra) REFERENCES compras(id_compra),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Inserção de funcionários
INSERT IGNORE INTO funcionarios (nome, cpf, telefone, endereco, salario, data_admissao, tipo_funcionario)
VALUES
    ('Carlos Gerente', '98765432101', '(11) 91234-5678', 'Rua X, 456', 5000.00, '2020-01-15', 'Gerente'),
    ('Ana Atendente', '12345678909', '(21) 98765-4321', 'Rua Y, 789', 2000.00, '2021-05-20', 'Atendente');

-- Inserção de gerentes
INSERT IGNORE INTO gerentes (id_gerente, id_loja)
VALUES 
    (1, 1);

-- Inserção de atendentes
INSERT IGNORE INTO atendentes (id_atendente, id_loja)
VALUES 
    (2, 1);

-- Inserção de compras
INSERT IGNORE INTO compras (id_fornecedor, total)
VALUES 
    (1, 1500.00),
    (2, 2500.00);

-- Inserção de itens de compra
INSERT IGNORE INTO itens_compra (id_compra, id_produto, quantidade, preco_unitario)
VALUES 
    (1, 1, 100, 15.00),
    (1, 2, 50, 20.00),
    (2, 3, 200, 10.00);

-- Gatilho para atualizar estoque após compra
DELIMITER //
CREATE TRIGGER atualizar_estoque_apos_compra
AFTER INSERT ON itens_compra
FOR EACH ROW
BEGIN
    INSERT INTO estoque (id_produto, quantidade, id_loja)
    VALUES (NEW.id_produto, NEW.quantidade, 1)
    ON DUPLICATE KEY UPDATE quantidade = quantidade + NEW.quantidade;
END;//
DELIMITER ;

-- Gatilho para verificar estoque antes de inserir itens de pedido
DELIMITER //
CREATE TRIGGER verificar_estoque_pedido
BEFORE INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    DECLARE qtd_disponivel INT;
    SELECT quantidade INTO qtd_disponivel
    FROM estoque
    WHERE id_produto = NEW.id_produto;

    IF qtd_disponivel < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente para realizar o pedido.';
    END IF;
END;//
DELIMITER ;
