
-- Antes de Rodas dar o CREATE DATABASE TRABALHO, PARA ABRIR O QUERY E COLOCAR O SCRIP PARA ARODAS

---------------------------------------
----- Criação da parte do cliente -----
---------------------------------------

CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    CPF VARCHAR(14) UNIQUE NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    DataCadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE TelefonesCliente (
    TelefoneID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    Telefone VARCHAR(15) NOT NULL,
    Tipo VARCHAR(50),
    CONSTRAINT fk_Telefone_Cliente
        FOREIGN KEY (ClienteID)
        REFERENCES Clientes(ClienteID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB; --ok

CREATE TABLE EmailsCliente (
    EmailID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Tipo VARCHAR(50),
    CONSTRAINT fk_Email_Cliente
        FOREIGN KEY (ClienteID)
        REFERENCES Clientes(ClienteID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB; --ok

CREATE TABLE EnderecoCliente (
    EnderecoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    CEP VARCHAR(9) NOT NULL,
    LOGRADOURO VARCHAR(100) NOT NULL,
    NUMERO INT NOT NULL,
    COMPLEMENTO VARCHAR(100),
    BAIRRO VARCHAR(100) NOT NULL,
    CIDADE VARCHAR(100) NOT NULL,
    ESTADO VARCHAR(2) NOT NULL,
    CONSTRAINT fk_Endereco_Cliente
        FOREIGN KEY (ClienteID)
        REFERENCES Clientes(ClienteID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB; --ok

----------------------------------------------------------------

-------------------------------------------
----- Criação da parte do Funcionario -----
-------------------------------------------

CREATE TABLE Funcionarios(
    FuncionarioID INT AUTO_INCREMENT PRIMARY KEY,
    CPF VARCHAR(14) UNIQUE NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    SALARIO DECIMAL(10,2) NOT NULL,
    DATACADASTRO TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENGINE = InnoDB; --ok


CREATE TABLE IF NOT EXISTS Atendentes (
    FuncionarioID INT NOT NULL,
    PRIMARY KEY (FuncionarioID),
    CONSTRAINT fk_Atendente_Funcionario
        FOREIGN KEY (FuncionarioID)
        REFERENCES Funcionarios(FuncionarioID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB; --ok

CREATE TABLE IF NOT EXISTS Cliente_Atendente (
    ClienteID INT NOT NULL,
    FuncionarioID INT NOT NULL,
    PRIMARY KEY (ClienteID, FuncionarioID),
    CONSTRAINT fk_Cliente_Atendente_Cliente
        FOREIGN KEY (ClienteID)
        REFERENCES Clientes(ClienteID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Cliente_Atendente_Funcionario
        FOREIGN KEY (FuncionarioID)
        REFERENCES Funcionarios(FuncionarioID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB; --ok

CREATE TABLE IF NOT EXISTS Loja(
    LojaID INT AUTO_INCREMENT PRIMARY KEY,
    CNPJ VARCHAR(18) UNIQUE NOT NULL,
    NOME VARCHAR(100) NOT NULL
)ENGINE = InnoDB; --ok

CREATE TABLE IF NOT EXISTS Loja_endereco(
    LojaID INT NOT NULL,
    CEP VARCHAR(9) NOT NULL,
    LOGRADOURO VARCHAR(100) NOT NULL,
    NUMERO INT NOT NULL,
    COMPLEMENTO VARCHAR(100),
    BAIRRO VARCHAR(100) NOT NULL,
    CIDADE VARCHAR(100) NOT NULL,
    ESTADO VARCHAR(2) NOT NULL,
    PRIMARY KEY (LojaID),
    CONSTRAINT fk_Loja_Endereco_Loja
        FOREIGN KEY (LojaID)
        REFERENCES Loja(LojaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB; --ok

CREATE TABLE IF NOT EXISTS Funcionario_Loja(
    FuncionarioID INT NOT NULL,
    LojaID INT NOT NULL,
    PRIMARY KEY (FuncionarioID, LojaID),
    CONSTRAINT fk_Funcionario_Loja_Loja
        FOREIGN KEY (FuncionarioID)
        REFERENCES Funcionarios(FuncionarioID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Funcionario_Loja_Funcionario
        FOREIGN KEY (LojaID)
    REFERENCES Loja(LojaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB; --ok

CREATE TABLE IF NOT EXISTS Gerente(
    FuncionarioID INT NOT NULL,
    LojaID INT NOT NULL,
    PRIMARY KEY (FuncionarioID),
    INDEX fk_Gerente_Funcionario_idx (FuncionarioID ASC) VISIBLE,
    INDEX fk_Gerente_Loja_idx (LojaID ASC) VISIBLE,
    CONSTRAINT fk_Gerente_Funcionario
        FOREIGN KEY (FuncionarioID)
        REFERENCES Funcionarios(FuncionarioID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Gerente_Loja
        FOREIGN KEY (LojaID)
        REFERENCES Loja(LojaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB; --ok

CREATE TABLE IF NOT EXISTS Caixa(
    FuncionarioID INT NOT NULL,
    PRIMARY KEY (FuncionarioID),
    CONSTRAINT fk_Caixa_Funcionario
        FOREIGN KEY (FuncionarioID)
        REFERENCES Funcionarios(FuncionarioID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB; --ok

CREATE TABLE IF NOT EXISTS Vendas(
    VendaID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    LojaID INT NOT NULL,
    DataVenda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ValorTotal DECIMAL(10, 2) NULL,
    Num_Vendas INT NULL,
    INDEX fk_Vendas_Loja_idx (LojaID ASC) VISIBLE,
    CONSTRAINT fk_Vendas_Loja
        FOREIGN KEY (LojaID)
        REFERENCES Loja(LojaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB; 

CREATE TABLE IF NOT EXISTS Compra(
    CompraID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    DataCompra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ValorTotal DECIMAL(10, 2) NULL,
    INDEX fk_Compra_Cliente_idx (ClienteID ASC) VISIBLE,
    CONSTRAINT fk_Compra_Cliente
        FOREIGN KEY (ClienteID)
        REFERENCES Clientes(ClienteID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Compra_Caixa(
    CompraID INT NOT NULL,
    FuncionarioID INT NOT NULL,
    PRIMARY KEY (CompraID, FuncionarioID),
    INDEX fk_Compra_Caixa_Caixa_idx (CompraID ASC) VISIBLE,
    CONSTRAINT fk_Compra_Caixa_Compra
        FOREIGN KEY (CompraID)
        REFERENCES Compra(CompraID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Compra_Caixa_Caixa
        FOREIGN KEY (FuncionarioID)
        REFERENCES Funcionarios(FuncionarioID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Tipo_Pagamento(
    TipoPagamentoID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Pagamento(
    PagamentoID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CompraID INT NOT NULL,
    CaixaID INT NOT NULL,
    TipoPagamentoID INT NOT NULL,
    DataPagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Valor DECIMAL(10, 2) NOT NULL,
    ClienteID INT NOT NULL,
    INDEX fk_Pagamento_Compra_idx (CompraID ASC) VISIBLE,
    INDEX fk_Pagamento_Caixa_idx (CaixaID ASC) VISIBLE,
    INDEX fk_Pagamento_TipoPagamento_idx (TipoPagamentoID ASC) VISIBLE,
    INDEX fk_Pagamento_Cliente_idx (ClienteID ASC) VISIBLE,
    CONSTRAINT fk_Pagamento_Compra
        FOREIGN KEY (CompraID)
        REFERENCES Compra(CompraID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Pagamento_Caixa
        FOREIGN KEY (CaixaID)
        REFERENCES Caixa(FuncionarioID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Pagamento_TipoPagamento
        FOREIGN KEY (TipoPagamentoID)
        REFERENCES Tipo_Pagamento(TipoPagamentoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Pagamento_Cliente
        FOREIGN KEY (ClienteID)
        REFERENCES Clientes(ClienteID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Fornecedor(
    FornecedorID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CNPJ VARCHAR(18) UNIQUE NOT NULL,
    Nome VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Pedido(
    PedidoID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FornecedorID INT NOT NULL,
    LojaID INT NOT NULL,
    DataPedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DataEntrega DATE,
    ValorTotal DECIMAL(10, 2) NULL,
    INDEX fk_Pedido_Fornecedor_idx (FornecedorID ASC) VISIBLE,
    INDEX fk_Pedido_Loja_idx (LojaID ASC) VISIBLE,
    CONSTRAINT fk_Pedido_Fornecedor
        FOREIGN KEY (FornecedorID)
        REFERENCES Fornecedor(FornecedorID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Pedido_Loja
        FOREIGN KEY (LojaID)
        REFERENCES Loja(LojaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Estoque(
    EstoqueID INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Categoria(
    CategoriaID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Fabricante(
    FabricanteID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Produto(
    ProdutoID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao VARCHAR(100) NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL,
    CategoriaID INT NOT NULL,
    FabricanteID INT NOT NULL,
    INDEX fk_Produto_Categoria_idx (CategoriaID ASC) VISIBLE,
    INDEX fk_Produto_Fabricante_idx (FabricanteID ASC) VISIBLE,
    CONSTRAINT fk_Produto_Categoria
        FOREIGN KEY (CategoriaID)
        REFERENCES Categoria(CategoriaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Produto_Fabricante
        FOREIGN KEY (FabricanteID)
        REFERENCES Fabricante(FabricanteID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Item_Pedido(
    ItemPedidoID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL,
    ValorUnitario DECIMAL(10, 2) NOT NULL,
    INDEX fk_Item_Pedido_Pedido_idx (PedidoID ASC) VISIBLE,
    INDEX fk_Item_Pedido_Produto_idx (ProdutoID ASC) VISIBLE,
    CONSTRAINT fk_Item_Pedido_Pedido
        FOREIGN KEY (PedidoID)
        REFERENCES Pedido(PedidoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Item_Pedido_Produto
        FOREIGN KEY (ProdutoID)
        REFERENCES Produto(ProdutoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Endereco_Fornecedor(
    FornecedorID INT NOT NULL,
    CEP VARCHAR(9) NOT NULL,
    LOGRADOURO VARCHAR(100) NOT NULL,
    NUMERO INT NOT NULL,
    COMPLEMENTO VARCHAR(100),
    BAIRRO VARCHAR(100) NOT NULL,
    CIDADE VARCHAR(100) NOT NULL,
    ESTADO VARCHAR(2) NOT NULL,
    PRIMARY KEY (FornecedorID),
    CONSTRAINT fk_Endereco_Fornecedor_Fornecedor
        FOREIGN KEY (FornecedorID)
        REFERENCES Fornecedor(FornecedorID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Estoque_Produto(
    EstoqueID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL,
    PRIMARY KEY (EstoqueID, ProdutoID),
    INDEX fk_Estoque_Produto_Estoque_idx (EstoqueID ASC) VISIBLE,
    INDEX fk_Estoque_Produto_Produto_idx (ProdutoID ASC) VISIBLE,
    CONSTRAINT fk_Estoque_Produto_Estoque
        FOREIGN KEY (EstoqueID)
        REFERENCES Estoque(EstoqueID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Estoque_Produto_Produto
        FOREIGN KEY (ProdutoID)
        REFERENCES Produto(ProdutoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Produto_Fornecedor(
    ProdutoID INT NOT NULL,
    FornecedorID INT NOT NULL,
    PRIMARY KEY (ProdutoID, FornecedorID),
    INDEX fk_Produto_Fornecedor_Produto_idx (ProdutoID ASC) VISIBLE,
    INDEX fk_Produto_Fornecedor_Fornecedor_idx (FornecedorID ASC) VISIBLE,
    CONSTRAINT fk_Produto_Fornecedor_Produto
        FOREIGN KEY (ProdutoID)
        REFERENCES Produto(ProdutoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Produto_Fornecedor_Fornecedor
        FOREIGN KEY (FornecedorID)
        REFERENCES Fornecedor(FornecedorID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Metragem_Unidade(
    MetragemID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Unidade VARCHAR(50) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Item_Compra(
    ItemCompraID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CompraID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL,
    ValorUnitario DECIMAL(10, 2) NOT NULL,
    MetragemID INT NOT NULL,
    INDEX fk_Item_Compra_Compra_idx (CompraID ASC) VISIBLE,
    INDEX fk_Item_Compra_Produto_idx (ProdutoID ASC) VISIBLE,
    INDEX fk_Item_Compra_Metragem_idx (MetragemID ASC) VISIBLE,
    CONSTRAINT fk_Item_Compra_Compra
        FOREIGN KEY (CompraID)
        REFERENCES Compra(CompraID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Item_Compra_Produto
        FOREIGN KEY (ProdutoID)
        REFERENCES Produto(ProdutoID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Item_Compra_Metragem
        FOREIGN KEY (MetragemID)
        REFERENCES Metragem_Unidade(MetragemID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Estoque_Loja(
    EstoqueID INT NOT NULL,
    LojaID INT NOT NULL,
    PRIMARY KEY (EstoqueID, LojaID),
    INDEX fk_Estoque_Loja_Estoque_idx (EstoqueID ASC) VISIBLE,
    INDEX fk_Estoque_Loja_Loja_idx (LojaID ASC) VISIBLE,
    CONSTRAINT fk_Estoque_Loja_Estoque
        FOREIGN KEY (EstoqueID)
        REFERENCES Estoque(EstoqueID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT fk_Estoque_Loja_Loja
        FOREIGN KEY (LojaID)
        REFERENCES Loja(LojaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Email_Fornecedor(
    EmailID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FornecedorID INT NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Tipo VARCHAR(50),
    INDEX fk_Email_Fornecedor_Fornecedor_idx (FornecedorID ASC) VISIBLE,
    CONSTRAINT fk_Email_Fornecedor_Fornecedor
        FOREIGN KEY (FornecedorID)
        REFERENCES Fornecedor(FornecedorID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE table if not exists email_loja(
    EmailID INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(50),
    LojaID INT,
    FOREIGN KEY (LojaID) REFERENCES loja(LojaID)
);

CREATE TABLE IF NOT EXISTS Telefone_Fornecedor(
    TelefoneID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FornecedorID INT NOT NULL,
    Telefone VARCHAR(15) NOT NULL,
    Tipo VARCHAR(50),
    INDEX fk_Telefone_Fornecedor_Fornecedor_idx (FornecedorID ASC) VISIBLE,
    CONSTRAINT fk_Telefone_Fornecedor_Fornecedor
        FOREIGN KEY (FornecedorID)
        REFERENCES Fornecedor(FornecedorID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Telefone_Loja(
    TelefoneID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    LojaID INT NOT NULL,
    Telefone VARCHAR(15) NOT NULL,
    Tipo VARCHAR(50),
    INDEX fk_Telefone_Loja_Loja_idx (LojaID ASC) VISIBLE,
    CONSTRAINT fk_Telefone_Loja_Loja
        FOREIGN KEY (LojaID)
        REFERENCES Loja(LojaID)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Log_Operacoes (
    LogID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Tabela VARCHAR(50) NOT NULL,
    Operacao VARCHAR(50) NOT NULL,
    Data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)ENGINE = InnoDB;



DELIMITER //


CREATE TRIGGER after_insert_telefone_fornecedor
AFTER INSERT ON Telefone_Fornecedor
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operacoes (Tabela, Operacao) VALUES ('Telefone_Fornecedor', 'INSERT');
END//


CREATE TRIGGER after_update_telefone_fornecedor
AFTER UPDATE ON Telefone_Fornecedor
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operacoes (Tabela, Operacao) VALUES ('Telefone_Fornecedor', 'UPDATE');
END//

CREATE TRIGGER after_delete_telefone_fornecedor
AFTER DELETE ON Telefone_Fornecedor
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operacoes (Tabela, Operacao) VALUES ('Telefone_Fornecedor', 'DELETE');
END//

CREATE TRIGGER after_insert_telefone_loja
AFTER INSERT ON Telefone_Loja
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operacoes (Tabela, Operacao) VALUES ('Telefone_Loja', 'INSERT');
END//


CREATE TRIGGER after_update_telefone_loja
AFTER UPDATE ON Telefone_Loja
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operacoes (Tabela, Operacao) VALUES ('Telefone_Loja', 'UPDATE');
END//


CREATE TRIGGER after_delete_telefone_loja
AFTER DELETE ON Telefone_Loja
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operacoes (Tabela, Operacao) VALUES ('Telefone_Loja', 'DELETE');
END//

DELIMITER ;


INSERT INTO Clientes (ClienteID, CPF, Nome, DataCadastro) VALUES
        (1, '123.456.789-00', 'João Silva', '2023-01-01'),
        (2, '987.654.321-00', 'Maria Oliveira', '2023-02-15'),
        (3, '456.789.123-00', 'Carlos Souza', '2023-03-20'),
        (4, '321.654.987-00', 'Ana Santos', '2023-04-10'),
        (5, '789.123.456-00', 'Paulo Lima', '2023-05-05'),
        (6, '654.987.321-00', 'Clara Mendes', '2023-06-18'),
        (7, '123.123.123-11', 'Pedro Rocha', '2023-07-22'),
        (8, '456.456.456-22', 'Fernanda Costa', '2023-08-30'),
        (9, '789.789.789-33', 'Lucas Almeida', '2023-09-12'),
        (10, '111.222.333-44', 'Juliana Vieira', '2023-10-01');

INSERT INTO TelefonesCliente (TelefoneID, ClienteID, Telefone, Tipo) VALUES
        (1, 1, '(11) 91234-5678', 'Celular'),
        (2, 2, '(21) 92345-6789', 'Celular'),
        (3, 3, '(31) 93456-7890', 'Residencial'),
        (4, 4, '(41) 94567-8901', 'Celular'),
        (5, 5, '(51) 95678-9012', 'Comercial'),
        (6, 6, '(61) 96789-0123', 'Celular'),
        (7, 7, '(71) 97890-1234', 'Residencial'),
        (8, 8, '(81) 98901-2345', 'Celular'),
        (9, 9, '(91) 99012-3456', 'Comercial'),
        (10, 10, '(92) 90123-4567', 'Celular');

INSERT INTO EmailsCliente (EmailID, ClienteID, Email, Tipo) VALUES
        (1, 1, 'joao.silva@email.com', 'Pessoal'),
        (2, 2, 'maria.oliveira@email.com', 'Pessoal'),
        (3, 3, 'carlos.souza@empresa.com', 'Comercial'),
        (4, 4, 'ana.santos@email.com', 'Pessoal'),
        (5, 5, 'paulo.lima@trabalho.com', 'Trabalho'),
        (6, 6, 'clara.mendes@email.com', 'Pessoal'),
        (7, 7, 'pedro.rocha@freelancer.com', 'Trabalho'),
        (8, 8, 'fernanda.costa@email.com', 'Pessoal'),
        (9, 9, 'lucas.almeida@startup.com', 'Comercial'),
        (10, 10, 'juliana.vieira@email.com', 'Pessoal');

        INSERT INTO EnderecoCliente (EnderecoID, ClienteID, CEP, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, CIDADE, ESTADO) VALUES
            (1, 1, '12345-678', 'Rua A', 123, 'Apto 1', 'Centro', 'São Paulo', 'SP'),
            (2, 2, '87654-321', 'Av. B', 456, 'Casa', 'Centro', 'Rio de Janeiro', 'RJ'),
            (3, 3, '45678-123', 'Praça C', 789, 'Bloco 2', 'Centro', 'Belo Horizonte', 'MG'),
            (4, 4, '21654-987', 'Rua D', 101, 'Apto 3', 'Centro', 'Curitiba', 'PR'),
            (5, 5, '78123-456', 'Av. E', 202, 'Casa', 'Centro', 'Porto Alegre', 'RS'),
            (6, 6, '54987-321', 'Praça F', 303, 'Bloco 1', 'Centro', 'Brasília', 'DF'),
            (7, 7, '21321-321', 'Rua G', 404, 'Apto 2', 'Centro', 'Salvador', 'BA'),
            (8, 8, '45456-456', 'Av. H', 505, 'Casa', 'Centro', 'Recife', 'PE'),
            (9, 9, '78789-789', 'Praça I', 606, 'Bloco 3', 'Centro', 'Belém', 'PA'),
            (10, 10, '11222-333', 'Rua J', 707, 'Apto 4', 'Centro', 'Manaus', 'AM');

INSERT INTO Funcionarios (FuncionarioID, CPF, Nome, Salario) VALUES
    (1, '123.456.789-00', 'Carlos Pereira', 5500.00),
    (2, '987.654.321-00', 'Fernanda Lima', 3500.00),
    (3, '456.789.123-00', 'João Almeida', 2500.00),
    (4, '321.654.987-00', 'Mariana Silva', 1800.00),
    (5, '789.123.456-00', 'Paulo Henrique', 4200.00),
    (6, '654.987.321-00', 'Juliana Souza', 2000.00),
    (7, '123.123.123-11', 'Ricardo Mendes', 2200.00),
    (8, '456.456.456-22', 'Ana Clara', 1200.00),
    (9, '789.789.789-33', 'Lucas Batista', 5000.00),
    (10, '111.222.333-44', 'Bianca Rocha', 2300.00);

INSERT INTO Atendentes (FuncionarioID) VALUES
        (4),
        (6),
        (7),
        (8),
        (10);
    
INSERT INTO Cliente_Atendente (ClienteID, FuncionarioID) VALUES
        (1, 4),
        (2, 6),
        (3, 7),
        (4, 8),
        (5, 10);

INSERT INTO Loja (LojaID, CNPJ, Nome) VALUES
        (1, '12.345.678/0001-00', 'Loja 1'),
        (2, '87.654.321/0001-00', 'Loja 2'),
        (3, '45.678.123/0001-00', 'Loja 3'),
        (4, '21.654.987/0001-00', 'Loja 4'),
        (5, '78.123.456/0001-00', 'Loja 5'),
        (6, '54.987.321/0001-00', 'Loja 6'),
        (7, '21.321.321/0001-11', 'Loja 7'),
        (8, '45.456.456/0001-22', 'Loja 8'),
        (9, '78.789.789/0001-33', 'Loja 9'),
        (10, '11.222.333/0001-44', 'Loja 10');

INSERT INTO Loja_endereco (LojaID, CEP, Logradouro, Numero, Bairro, Cidade, Estado) VALUES
        (1, '12345-678', 'Rua A, 123', 1, 'Centro', 'São Paulo', 'SP'),
        (2, '87654-321', 'Av. B, 456', 2, 'Centro', 'Rio de Janeiro', 'RJ'),
        (3, '45678-123', 'Praça C, 789', 3, 'Centro', 'Belo Horizonte', 'MG'),
        (4, '21654-987', 'Rua D, 101', 4, 'Centro', 'Curitiba', 'PR'),
        (5, '78123-456', 'Av. E, 202', 5, 'Centro', 'Porto Alegre', 'RS'),
        (6, '54987-321', 'Praça F, 303', 6, 'Centro', 'Brasília', 'DF'),
        (7, '21321-321', 'Rua G, 404', 7, 'Centro', 'Salvador', 'BA'),
        (8, '45456-456', 'Av. H, 505', 8, 'Centro', 'Recife', 'PE'),
        (9, '78789-789', 'Praça I, 606', 9, 'Centro', 'Belém', 'PA'),
        (10, '11222-333', 'Rua J, 707', 10, 'Centro', 'Manaus', 'AM');

INSERT INTO Funcionario_Loja (FuncionarioID, LojaID) VALUES
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
        (8, 8),
        (9, 9),
        (10, 10);

INSERT INTO Gerente (FuncionarioID, LojaID) VALUES
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
        (8, 8),
        (9, 9),
        (10, 10);

INSERT INTO Caixa (FuncionarioID) VALUES
        (1),
        (2),
        (3),
        (4),
        (5),
        (6),
        (7),
        (8),
        (9),
        (10);

INSERT INTO Vendas (VendaID, LojaID, DataVenda, ValorTotal, Num_Vendas) VALUES
        (1, 1, '2023-01-01', 1000.00, 10),
        (2, 2, '2023-02-15', 2000.00, 20),
        (3, 3, '2023-03-20', 3000.00, 30),
        (4, 4, '2023-04-10', 4000.00, 40),
        (5, 5, '2023-05-05', 5000.00, 50),
        (6, 6, '2023-06-18', 6000.00, 60),
        (7, 7, '2023-07-22', 7000.00, 70),
        (8, 8, '2023-08-30', 8000.00, 80),
        (9, 9, '2023-09-12', 9000.00, 90),
        (10, 10, '2023-10-01', 10000.00, 100);

INSERT INTO Compra (CompraID, ClienteID, DataCompra, ValorTotal) VALUES
        (1, 1, '2023-01-01', 1000.00),
        (2, 2, '2023-02-15', 2000.00),
        (3, 3, '2023-03-20', 3000.00),
        (4, 4, '2023-04-10', 4000.00),
        (5, 5, '2023-05-05', 5000.00),
        (6, 6, '2023-06-18', 6000.00),
        (7, 7, '2023-07-22', 7000.00),
        (8, 8, '2023-08-30', 8000.00),
        (9, 9, '2023-09-12', 9000.00),
        (10, 10, '2023-10-01', 10000.00);

INSERT INTO Compra_Caixa (CompraID, FuncionarioID) VALUES
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
        (8, 8),
        (9, 9),
        (10, 10);

INSERT INTO Tipo_Pagamento (TipoPagamentoID, Tipo) VALUES
        (1, 'Dinheiro'),
        (2, 'Cartão de Crédito'),
        (3, 'Cartão de Débito'),
        (4, 'Pix'),
        (5, 'Boleto');

INSERT INTO Pagamento (PagamentoID, CompraID, CaixaID, TipoPagamentoID, DataPagamento, Valor, ClienteID) VALUES
        (1, 1, 1, 1, '2023-01-01', 1000.00, 1),
        (2, 2, 2, 2, '2023-02-15', 2000.00, 2),
        (3, 3, 3, 3, '2023-03-20', 3000.00, 3),
        (4, 4, 4, 4, '2023-04-10', 4000.00, 4),
        (5, 5, 5, 5, '2023-05-05', 5000.00, 5),
        (6, 6, 6, 1, '2023-06-18', 6000.00, 6),
        (7, 7, 7, 2, '2023-07-22', 7000.00, 7),
        (8, 8, 8, 3, '2023-08-30', 8000.00, 8),
        (9, 9, 9, 4, '2023-09-12', 9000.00, 9),
        (10, 10, 10, 5, '2023-10-01', 10000.00, 10);

INSERT INTO Fornecedor (FornecedorID, CNPJ, Nome) VALUES
        (1, '12.345.678/0001-00', 'Fornecedor 1'),
        (2, '87.654.321/0001-00', 'Fornecedor 2'),
        (3, '45.678.123/0001-00', 'Fornecedor 3'),
        (4, '21.654.987/0001-00', 'Fornecedor 4'),
        (5, '78.123.456/0001-00', 'Fornecedor 5'),
        (6, '54.987.321/0001-00', 'Fornecedor 6'),
        (7, '21.321.321/0001-11', 'Fornecedor 7'),
        (8, '45.456.456/0001-22', 'Fornecedor 8'),
        (9, '78.789.789/0001-33', 'Fornecedor 9'),
        (10, '11.222.333/0001-44', 'Fornecedor 10');

INSERT INTO Pedido (PedidoID, FornecedorID, LojaID, DataPedido, DataEntrega, ValorTotal) VALUES
        (1, 1, 1, '2023-01-01', '2023-01-10', 1000.00),
        (2, 2, 2, '2023-02-15', '2023-02-25', 2000.00),
        (3, 3, 3, '2023-03-20', '2023-03-30', 3000.00),
        (4, 4, 4, '2023-04-10', '2023-04-20', 4000.00),
        (5, 5, 5, '2023-05-05', '2023-05-15', 5000.00),
        (6, 6, 6, '2023-06-18', '2023-06-28', 6000.00),
        (7, 7, 7, '2023-07-22', '2023-08-01', 7000.00),
        (8, 8, 8, '2023-08-30', '2023-09-09', 8000.00),
        (9, 9, 9, '2023-09-12', '2023-09-22', 9000.00),
        (10, 10, 10, '2023-10-01', '2023-10-11', 10000.00);


INSERT INTO Endereco_Fornecedor (FornecedorID, CEP, Logradouro, Numero, Bairro, Cidade, Estado) VALUES
        (1, '12345-678', 'Rua A, 123', 1, 'Centro', 'São Paulo', 'SP'),
        (2, '87654-321', 'Av. B, 456', 2, 'Centro', 'Rio de Janeiro', 'RJ'),
        (3, '45678-123', 'Praça C, 789', 3, 'Centro', 'Belo Horizonte', 'MG'),
        (4, '21654-987', 'Rua D, 101', 4, 'Centro', 'Curitiba', 'PR'),
        (5, '78123-456', 'Av. E, 202', 5, 'Centro', 'Porto Alegre', 'RS'),
        (6, '54987-321', 'Praça F, 303', 6, 'Centro', 'Brasília', 'DF'),
        (7, '21321-321', 'Rua G, 404', 7, 'Centro', 'Salvador', 'BA'),
        (8, '45456-456', 'Av. H, 505', 8, 'Centro', 'Recife', 'PE'),
        (9, '78789-789', 'Praça I, 606', 9, 'Centro', 'Belém', 'PA'),
        (10, '11222-333', 'Rua J, 707', 10, 'Centro', 'Manaus', 'AM');

INSERT INTO Estoque (EstoqueID) VALUES
        (1),
        (2),
        (3),
        (4),
        (5),
        (6),
        (7),
        (8),
        (9),
        (10);

INSERT INTO Categoria (CategoriaID, Nome) VALUES
        (1, 'Alimentos'),
        (2, 'Bebidas'),
        (3, 'Limpeza'),
        (4, 'Higiene'),
        (5, 'Eletrônicos'),
        (6, 'Móveis'),
        (7, 'Decoração'),
        (8, 'Roupas'),
        (9, 'Calçados'),
        (10, 'Acessórios');

INSERT INTO Fabricante (FabricanteID, Nome) VALUES
        (1, 'Fabricante 1'),
        (2, 'Fabricante 2'),
        (3, 'Fabricante 3'),
        (4, 'Fabricante 4'),
        (5, 'Fabricante 5'),
        (6, 'Fabricante 6'),
        (7, 'Fabricante 7'),
        (8, 'Fabricante 8'),
        (9, 'Fabricante 9'),
        (10, 'Fabricante 10');

INSERT INTO Produto (ProdutoID, Nome, Descricao, Valor, CategoriaID, FabricanteID) VALUES
        (1, 'Arroz', 'Arroz 1kg', 5.00, 1, 1),
        (2, 'Feijão', 'Feijão 1kg', 6.00, 1, 2),
        (3, 'Macarrão', 'Macarrão 500g', 3.00, 1, 3),
        (4, 'Óleo', 'Óleo 900ml', 4.00, 1, 4),
        (5, 'Açúcar', 'Açúcar 1kg', 3.50, 1, 5),
        (6, 'Café', 'Café 500g', 7.00, 1, 6),
        (7, 'Leite', 'Leite 1L', 3.00, 1, 7),
        (8, 'Margarina', 'Margarina 500g', 2.50, 1, 8),
        (9, 'Sal', 'Sal 1kg', 2.00, 1, 9),
        (10, 'Farinha', 'Farinha 1kg', 3.00, 1, 10);

INSERT INTO Estoque_Produto (EstoqueID, ProdutoID, Quantidade) VALUES
        (1, 1, 100),
        (2, 2, 200),
        (3, 3, 300),
        (4, 4, 400),
        (5, 5, 500),
        (6, 6, 600),
        (7, 7, 700),
        (8, 8, 800),
        (9, 9, 900),
        (10, 10, 1000);

INSERT INTO Produto_Fornecedor (ProdutoID, FornecedorID) VALUES
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
        (8, 8),
        (9, 9),
        (10, 10);

INSERT INTO Metragem_Unidade (MetragemID, Unidade) VALUES
        (1, 'Kg'),
        (2, 'g'),
        (3, 'L'),
        (4, 'ml'),
        (5, 'un');

INSERT INTO Item_Compra (ItemCompraID, CompraID, ProdutoID, Quantidade, ValorUnitario, MetragemID) VALUES
        (1, 1, 1, 10, 5.00, 1),
        (2, 2, 2, 20, 6.00, 1),
        (3, 3, 3, 30, 3.00, 1),
        (4, 4, 4, 40, 4.00, 1),
        (5, 5, 5, 50, 3.50, 1),
        (6, 6, 6, 60, 7.00, 1),
        (7, 7, 7, 70, 3.00, 1),
        (8, 8, 8, 80, 2.50, 1),
        (9, 9, 9, 90, 2.00, 1),
        (10, 10, 10, 100, 3.00, 1);

INSERT INTO Estoque_Loja (EstoqueID, LojaID) VALUES
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
        (8, 8),
        (9, 9),
        (10, 10);

INSERT INTO Email_Fornecedor (EmailID, FornecedorID, Email, Tipo) VALUES
        (1, 1, 'kkkkkkk@gmail.com', 'Pessoal'),
        (2, 2, 'ddddddd@gmail.com', 'Pessoal'),
        (3, 2, 'eeeeeee@gmail.com', 'Pessoal'),
        (4, 4, 'uuuuuuu@gmail.com', 'Pessoal'),
        (5, 5, 'uuuuuuu234d@gmail.com', 'Pessoal'),
        (6, 6, 'hhhhhhhh@gmail.com', 'Pessoal'),
        (7, 7, 'DennisGrandeMaverick@gmail.com', 'Pessoal'),
        (8, 8, 'xxxxxxxxxx@gmail.com', 'Pessoal'),
        (9, 9, 'xxisoa@gmail.com', 'Pessoal'),
        (10, 10, 'fkfklskl@gmail.com', 'Pessoal');

INSERT INTO Telefone_Fornecedor (TelefoneID, FornecedorID, Telefone, Tipo) VALUES
        (1, 1, '(11) 91234-5678', 'Celular'),
        (2, 2, '(21) 92345-6789', 'Celular'),
        (3, 3, '(31) 93456-7890', 'Residencial'),
        (4, 4, '(41) 94567-8901', 'Celular'),
        (5, 5, '(51) 95678-9012', 'Comercial'),
        (6, 6, '(61) 96789-0123', 'Celular'),
        (7, 7, '(71) 97890-1234', 'Residencial'),
        (8, 8, '(81) 98901-2345', 'Celular'),
        (9, 9, '(91) 99012-3456', 'Comercial'),
        (10, 10, '(92) 90123-4567', 'Celular');

INSERT INTO Telefone_Loja (TelefoneID, LojaID, Telefone, Tipo) VALUES
        (1, 1, '(11) 91234-5678', 'Celular'),
        (2, 2, '(21) 92345-6789', 'Celular'),
        (3, 3, '(31) 93456-7890', 'Residencial'),
        (4, 4, '(41) 94567-8901', 'Celular'),
        (5, 5, '(51) 95678-9012', 'Comercial'),
        (6, 6, '(61) 96789-0123', 'Celular'),
        (7, 7, '(71) 97890-1234', 'Residencial'),
        (8, 8, '(81) 98901-2345', 'Celular'),
        (9, 9, '(91) 99012-3456', 'Comercial'),
        (10, 10, '(92) 90123-4567', 'Celular');


INSERT INTO Item_Pedido (ItemPedidoID, PedidoID, ProdutoID, Quantidade, ValorUnitario) VALUES
    (1, 1, 1, 10, 100.00),
    (2, 2, 2, 20, 200.00),
    (3, 3, 3, 30, 300.00),
    (4, 4, 4, 40, 400.00),
    (5, 5, 5, 50, 500.00),
    (6, 6, 6, 60, 600.00),
    (7, 7, 7, 70, 700.00),
    (8, 8, 8, 80, 800.00),
    (9, 9, 9, 90, 900.00),
    (10, 10, 10, 100, 1000.00);
        

INSERT INTO email_loja (Email, LojaID) VALUES
    ('loja1@example.com', 1),
    ('loja2@example.com', 2),
    ('loja3@example.com', 3),
    ('loja4@example.com', 4),
    ('loja5@example.com', 5);

INSERT INTO Telefone_Fornecedor (TelefoneID, FornecedorID, Telefone, Tipo) VALUES (11, 2, '(89)99999-9999', 'Celular');