CREATE TABLE operadoras (
    registro_ans VARCHAR(20),
    cnpj VARCHAR(14) PRIMARY KEY, -- CNPJ como PK por ser único e identificador universal
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100),
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    cep VARCHAR(8),
    ddd VARCHAR(2),
    telefone VARCHAR(20),
    fax VARCHAR(30),
    email VARCHAR(150),
    representante VARCHAR(150),
    cargo_representante VARCHAR(100),
    regiao_comercializacao INT,
    data_registro_ans DATE
);