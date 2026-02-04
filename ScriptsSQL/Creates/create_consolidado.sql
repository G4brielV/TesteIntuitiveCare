CREATE TABLE despesas_consolidadas (
    id SERIAL PRIMARY KEY,
    cnpj VARCHAR(14) REFERENCES operadoras(cnpj),
    valor_despesa NUMERIC(19, 2) NOT NULL,
    ano INT NOT NULL,
    trimestre INT NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    data_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);